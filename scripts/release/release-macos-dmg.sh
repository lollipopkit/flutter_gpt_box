#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
if [[ -n "${GPTBOX_RELEASE_ENV_FILE:-}" ]]; then
  ENV_FILE="$GPTBOX_RELEASE_ENV_FILE"
elif [[ -f "$REPO_ROOT/.env.release" ]]; then
  ENV_FILE="$REPO_ROOT/.env.release"
else
  ENV_FILE=""
fi

if [[ -n "$ENV_FILE" && -f "$ENV_FILE" ]]; then
  set -a
  # shellcheck disable=SC1090
  source "$ENV_FILE"
  set +a
elif [[ "${GPTBOX_RELEASE_ENV_FILE:-}" != "" ]]; then
  echo "release environment file not found: $ENV_FILE" >&2
  exit 1
fi

require_var() {
  local name="$1"
  if [[ -z "${!name:-}" ]]; then
    echo "$name is required" >&2
    exit 1
  fi
}

require_file() {
  local path="$1"
  if [[ ! -e "$path" ]]; then
    echo "file not found: $path" >&2
    exit 1
  fi
}

require_cmd() {
  local name="$1"
  if ! command -v "$name" >/dev/null 2>&1; then
    echo "command not found: $name" >&2
    exit 1
  fi
}

warn_pre_notary_spctl_rejection() {
  local app_path="$1"

  echo "Skipping pre-notarization spctl enforcement for $app_path"
  echo 'Developer ID signed apps can be rejected by Gatekeeper before notarization with source=Unnotarized Developer ID'
}

normalize_abs_path() {
  local path="$1"
  if [[ -z "$path" ]]; then
    echo 'path must not be empty' >&2
    exit 1
  fi
  if [[ "$path" != /* ]]; then
    echo "path must be absolute: $path" >&2
    exit 1
  fi

  local normalized="${path%/}"
  if [[ -z "$normalized" ]]; then
    normalized='/'
  fi

  case "$normalized" in
    *$'\n'* | *'//'*) echo "path contains invalid characters: $path" >&2; exit 1 ;;
    ../* | */../* | */.. | .. | . | */./* | */.) echo "path must not contain traversal segments: $path" >&2; exit 1 ;;
  esac

  printf '%s\n' "$normalized"
}

resolve_path_for_validation() {
  local path="$1"
  local normalized
  local existing
  local remainder=''
  local name
  local parent
  local resolved

  normalized="$(normalize_abs_path "$path")"
  existing="$normalized"

  while [[ ! -e "$existing" ]]; do
    if [[ "$existing" == "/" ]]; then
      echo "unable to canonicalize path: $path" >&2
      exit 1
    fi

    name="${existing##*/}"
    parent="${existing%/*}"
    if [[ -z "$parent" ]]; then
      parent='/'
    fi

    remainder="/$name$remainder"
    existing="$parent"
  done

  if [[ -n "$remainder" && ! -d "$existing" ]]; then
    echo "path parent is not a directory: $existing" >&2
    exit 1
  fi

  if ! resolved="$(realpath "$existing" 2>/dev/null)"; then
    echo "unable to canonicalize path: $path" >&2
    exit 1
  fi

  if [[ -z "$remainder" ]]; then
    printf '%s\n' "$resolved"
  elif [[ "$resolved" == "/" ]]; then
    printf '/%s\n' "${remainder#/}"
  else
    printf '%s%s\n' "$resolved" "$remainder"
  fi
}

validate_allowed_path() {
  local label="$1"
  local path="$2"
  local resolved_path
  local resolved_repo_build
  local resolved_tmp
  local resolved_var_folders

  resolved_path="$(resolve_path_for_validation "$path")"
  resolved_repo_build="$(resolve_path_for_validation "$REPO_ROOT/build")"
  resolved_tmp="$(resolve_path_for_validation '/tmp')"
  resolved_var_folders="$(resolve_path_for_validation '/var/folders')"

  case "$resolved_path" in
    "$resolved_tmp" | "$resolved_var_folders")
      echo "$label must not be the temp root directory: $resolved_path" >&2
      exit 1
      ;;
  esac

  case "$resolved_path" in
    "$resolved_repo_build" | "$resolved_repo_build/"* | "$resolved_tmp"/* | "$resolved_var_folders"/*)
      printf '%s\n' "$resolved_path"
      ;;
    *)
      echo "$label must be under $resolved_repo_build, $resolved_tmp, or $resolved_var_folders: $resolved_path" >&2
      exit 1
      ;;
  esac
}

validate_path_within_base() {
  local label="$1"
  local path="$2"
  local base="$3"
  local resolved_path
  local resolved_base

  resolved_path="$(resolve_path_for_validation "$path")"
  resolved_base="$(validate_allowed_path "$label base" "$base")"

  case "$resolved_path" in
    "$resolved_base" | "$resolved_base/"*)
      printf '%s\n' "$resolved_path"
      ;;
    *)
      echo "$label must be within $resolved_base: $resolved_path" >&2
      exit 1
      ;;
  esac
}

safe_remove() {
  local mode="$1"
  local label="$2"
  local path="$3"
  local base="${4:-}"
  local normalized_path

  if [[ -n "$base" ]]; then
    normalized_path="$(validate_path_within_base "$label" "$path" "$base")"
  else
    normalized_path="$(validate_allowed_path "$label" "$path")"
  fi

  rm "$mode" "$normalized_path"
}

read_pubspec_versions() {
  local version_line
  version_line="$(sed -nE 's/^version:[[:space:]]*([^+]+)\+([0-9]+)$/\1 \2/p' "$REPO_ROOT/pubspec.yaml" | head -n 1)"
  if [[ -z "$version_line" ]]; then
    echo "unable to parse version from pubspec.yaml" >&2
    exit 1
  fi
  printf '%s\n' "$version_line"
}

# Map Xcode architecture names to the names used by release assets. The project
# already uses `amd64` for APK and AppImage assets.
asset_arch_for() {
  case "$1" in
    arm64) printf 'arm64\n' ;;
    x86_64) printf 'amd64\n' ;;
    *) echo "unknown architecture: $1" >&2; exit 1 ;;
  esac
}

# Verify that every Mach-O contains exactly the requested architecture. This
# catches the Rust toolchain's fallback to the host target, which could place an
# arm64 library in an Intel app and cause `RustLib.init` to fail at runtime.
verify_app_arch() {
  local app_path="$1"
  local expected="$2"
  local checked=0
  local binary archs
  local -a bad=()

  while IFS= read -r -d '' binary; do
    archs="$(lipo -archs "$binary" 2>/dev/null)" || continue
    checked=$((checked + 1))
    case "${binary##*/}" in
      # Apple's Swift back-deployment runtime, copied out of the toolchain by
      # Xcode's "Copy Swift Standard Libraries" phase and universal as it
      # ships. It only has to carry this slice.
      libswift*.dylib)
        [[ " $archs " == *" $expected "* ]] || bad+=("${binary#"$app_path/"}: $archs")
        ;;
      *)
        [[ "$archs" == "$expected" ]] || bad+=("${binary#"$app_path/"}: $archs")
        ;;
    esac
  done < <(find "$app_path/Contents/MacOS" "$app_path/Contents/Frameworks" -type f -print0)

  if (( checked == 0 )); then
    echo "no Mach-O binary found in $app_path" >&2
    exit 1
  fi
  if (( ${#bad[@]} )); then
    echo "${#bad[@]} binary/binaries in $app_path are not $expected alone:" >&2
    printf '  %s\n' "${bad[@]}" >&2
    exit 1
  fi
  echo "$app_path: $checked binaries, all $expected"
}

# Adds [dmg...] to the release's SHA256SUMS and MD5SUMS, which CI wrote for
# everything it published, replacing the line an earlier upload of the same
# name left. A release without them yet gets them started.
update_release_checksums() {
  local dir list dmg name sum assets
  dir="$(mktemp -d)"
  # Asked first rather than inferred from a failed download: a download that
  # failed for any other reason would start the list over, and the upload
  # below would replace CI's list with one naming only these DMGs.
  assets="$(gh release view "$RELEASE_TAG" --repo "$APP_REPO_SLUG" \
    --json assets --jq '.assets[].name')"
  for list in SHA256SUMS MD5SUMS; do
    if grep -qxF "$list" <<< "$assets"; then
      gh release download "$RELEASE_TAG" --repo "$APP_REPO_SLUG" \
        --pattern "$list" --dir "$dir"
    else
      : > "$dir/$list"
    fi
    for dmg in "$@"; do
      name="$(basename "$dmg")"
      # By field, not by pattern: `.` in every name is a literal.
      awk -v n="$name" '$2 != n' "$dir/$list" > "$dir/$list.tmp"
      mv "$dir/$list.tmp" "$dir/$list"
      case "$list" in
        SHA256SUMS) sum="$(shasum -a 256 "$dmg" | cut -d' ' -f1)" ;;
        MD5SUMS) sum="$(md5 -q "$dmg")" ;;
      esac
      printf '%s  %s\n' "$sum" "$name" >> "$dir/$list"
    done
  done
  gh release upload "$RELEASE_TAG" "$dir/SHA256SUMS" "$dir/MD5SUMS" \
    --repo "$APP_REPO_SLUG" \
    --clobber
  rm -rf "$dir"
}

# How many times a call to Apple's notary service is worth making.
NOTARY_ATTEMPTS="${NOTARY_ATTEMPTS:-4}"

# Retried on a transport failure and never on a verdict.
#
# `notarytool submit --wait` exits non-zero both when it could not deliver the
# file and when the service looked at the file and said no. Resubmitting a
# refused build queues the same refusal again, so the retry is gated on the
# output *not* carrying a terminal status.
#
# Worth having because of where this sits: an upload that dies (e.g.
# `Connection reset by peer`) comes after the archive, the export, the DMG and
# the signature are all done, and without a retry the only way back is to build
# that architecture again from nothing.
notarize_dmg() {
  local dmg_path="$1"
  local attempt=1
  local delay=15
  local status=1
  local log
  log="$(mktemp)"

  while :; do
    if xcrun notarytool submit "$dmg_path" \
      --keychain-profile "$APPLE_NOTARY_KEYCHAIN_PROFILE" \
      --wait 2>&1 | tee "$log"; then
      status=0
      break
    fi

    if grep -qE 'status: (Invalid|Rejected)' "$log"; then
      echo "The notary service refused $dmg_path. Not retrying." >&2
      break
    fi

    if (( attempt >= NOTARY_ATTEMPTS )); then
      echo "No verdict on $dmg_path after $attempt attempts." >&2
      break
    fi

    echo "Notarization attempt $attempt ended before a verdict; retrying in ${delay}s." >&2
    sleep "$delay"
    attempt=$(( attempt + 1 ))
    delay=$(( delay * 2 ))
  done

  rm -f "$log"
  return "$status"
}

# The ticket is fetched from Apple, and it is not always there the moment the
# submission is accepted. `stapler` reports that wait with the same failure it
# gives for a build that was never notarized at all.
staple_dmg() {
  local dmg_path="$1"
  local attempt=1
  local delay=15

  while :; do
    if xcrun stapler staple "$dmg_path"; then
      return 0
    fi

    if (( attempt >= NOTARY_ATTEMPTS )); then
      echo "Could not staple $dmg_path after $attempt attempts." >&2
      return 1
    fi

    echo "Stapling attempt $attempt failed; retrying in ${delay}s." >&2
    sleep "$delay"
    attempt=$(( attempt + 1 ))
    delay=$(( delay * 2 ))
  done
}

require_var APPLE_TEAM_ID
require_var APPLE_NOTARY_KEYCHAIN_PROFILE

require_cmd xcodebuild
require_cmd codesign
require_cmd xcrun
require_cmd hdiutil
require_cmd lipo
require_cmd spctl
require_cmd realpath
require_file /usr/libexec/PlistBuddy

WORKSPACE_PATH="${WORKSPACE_PATH:-$REPO_ROOT/macos/Runner.xcworkspace}"
SCHEME="${SCHEME:-Runner}"
CONFIGURATION="${CONFIGURATION:-Release}"
APP_NAME="${APP_NAME:-LLMBox}"
APP_ASSET_NAME="${APP_ASSET_NAME:-LLMBox}"
APP_BUNDLE_ID="${APP_BUNDLE_ID:-com.lollipopkit.gpt}"
VOLUME_NAME="${VOLUME_NAME:-LLMBox}"
SIGNING_IDENTITY="${SIGNING_IDENTITY:-Developer ID Application}"
APP_PROFILE_NAME="${APP_PROFILE_NAME:-GPTBox DMG Profile}"
BUILD_ROOT="${BUILD_ROOT:-$REPO_ROOT/build/release}"
ARTIFACTS_PATH="${ARTIFACTS_PATH:-$REPO_ROOT/build/artifacts}"
EXPORT_OPTIONS_PATH="${EXPORT_OPTIONS_PATH:-$BUILD_ROOT/ExportOptions-${APP_ASSET_NAME}.plist}"
OVERRIDE_XCCONFIG_PATH="${OVERRIDE_XCCONFIG_PATH:-$BUILD_ROOT/${APP_ASSET_NAME}-release-overrides.xcconfig}"
RUNNER_PROJECT_FILE="${RUNNER_PROJECT_FILE:-$REPO_ROOT/macos/Runner.xcodeproj/project.pbxproj}"
RUNNER_PROJECT_BACKUP="${RUNNER_PROJECT_BACKUP:-$BUILD_ROOT/Runner.project.pbxproj.backup}"
DMG_STAGING_PATH="${DMG_STAGING_PATH:-$REPO_ROOT/build/dmg-root}"
PUBLISH_GITHUB_RELEASE="${PUBLISH_GITHUB_RELEASE:-1}"
APP_REPO_SLUG="${APP_REPO_SLUG:-lollipopkit/flutter_gpt_box}"
RELEASE_TITLE="${RELEASE_TITLE:-}"

if [[ "$PUBLISH_GITHUB_RELEASE" == "1" ]]; then
  require_cmd gh
fi

require_file "$WORKSPACE_PATH"

read -r DEFAULT_MARKETING_VERSION DEFAULT_CURRENT_PROJECT_VERSION <<<"$(read_pubspec_versions)"
MARKETING_VERSION="${MARKETING_VERSION_OVERRIDE:-$DEFAULT_MARKETING_VERSION}"
CURRENT_PROJECT_VERSION="${CURRENT_PROJECT_VERSION_OVERRIDE:-$DEFAULT_CURRENT_PROJECT_VERSION}"
RELEASE_TAG="${RELEASE_TAG:-v${MARKETING_VERSION}}"
RELEASE_TITLE="${RELEASE_TITLE:-$RELEASE_TAG}"
DMG_BASENAME="${DMG_BASENAME:-${APP_ASSET_NAME}-${MARKETING_VERSION}}"

# Build one DMG per architecture instead of a universal DMG, so each one is
# verified on its own before release.
#
# `RELEASE_ARCHS` supports partial retries: if one architecture fails during
# notarization, rerun only that architecture.
RELEASE_ARCHS="${RELEASE_ARCHS:-arm64 x86_64}"
if [[ -z "${RELEASE_ARCHS//[[:space:]]/}" ]]; then
  echo "RELEASE_ARCHS must name at least one architecture" >&2
  exit 1
fi
for arch in $RELEASE_ARCHS; do
  asset_arch_for "$arch" >/dev/null
done

validate_allowed_path 'BUILD_ROOT' "$BUILD_ROOT" >/dev/null
validate_allowed_path 'ARTIFACTS_PATH' "$ARTIFACTS_PATH" >/dev/null
validate_allowed_path 'DMG_STAGING_PATH' "$DMG_STAGING_PATH" >/dev/null
validate_path_within_base 'EXPORT_OPTIONS_PATH' "$EXPORT_OPTIONS_PATH" "$BUILD_ROOT" >/dev/null
validate_path_within_base 'OVERRIDE_XCCONFIG_PATH' "$OVERRIDE_XCCONFIG_PATH" "$BUILD_ROOT" >/dev/null
validate_path_within_base 'RUNNER_PROJECT_BACKUP' "$RUNNER_PROJECT_BACKUP" "$BUILD_ROOT" >/dev/null

mkdir -p \
  "$ARTIFACTS_PATH" \
  "$BUILD_ROOT/export" \
  "$(dirname "$EXPORT_OPTIONS_PATH")" \
  "$(dirname "$OVERRIDE_XCCONFIG_PATH")" \
  "$(dirname "$RUNNER_PROJECT_BACKUP")"

safe_remove -rf 'DMG_STAGING_PATH' "$DMG_STAGING_PATH"
safe_remove -f 'EXPORT_OPTIONS_PATH' "$EXPORT_OPTIONS_PATH" "$BUILD_ROOT"
safe_remove -f 'OVERRIDE_XCCONFIG_PATH' "$OVERRIDE_XCCONFIG_PATH" "$BUILD_ROOT"
safe_remove -f 'RUNNER_PROJECT_BACKUP' "$RUNNER_PROJECT_BACKUP" "$BUILD_ROOT"

restore_runner_project() {
  if [[ -f "$RUNNER_PROJECT_BACKUP" ]]; then
    cp "$RUNNER_PROJECT_BACKUP" "$RUNNER_PROJECT_FILE"
  fi
}

cp "$RUNNER_PROJECT_FILE" "$RUNNER_PROJECT_BACKUP"
trap restore_runner_project EXIT

cat >"$OVERRIDE_XCCONFIG_PATH" <<EOF
CODE_SIGN_STYLE = Manual
CODE_SIGN_IDENTITY[sdk=macosx*] = $SIGNING_IDENTITY
DEVELOPMENT_TEAM[sdk=macosx*] = $APPLE_TEAM_ID
OTHER_CODE_SIGN_FLAGS = --timestamp --options runtime
EOF

/usr/libexec/PlistBuddy -c 'Clear dict' "$EXPORT_OPTIONS_PATH"
/usr/libexec/PlistBuddy -c 'Add :method string developer-id' "$EXPORT_OPTIONS_PATH"
/usr/libexec/PlistBuddy -c 'Add :signingStyle string manual' "$EXPORT_OPTIONS_PATH"
/usr/libexec/PlistBuddy -c 'Add :stripSwiftSymbols bool true' "$EXPORT_OPTIONS_PATH"
/usr/libexec/PlistBuddy -c "Add :teamID string $APPLE_TEAM_ID" "$EXPORT_OPTIONS_PATH"
/usr/libexec/PlistBuddy -c "Add :signingCertificate string $SIGNING_IDENTITY" "$EXPORT_OPTIONS_PATH"
/usr/libexec/PlistBuddy -c 'Add :provisioningProfiles dict' "$EXPORT_OPTIONS_PATH"
/usr/libexec/PlistBuddy -c "Add :provisioningProfiles:$APP_BUNDLE_ID string $APP_PROFILE_NAME" "$EXPORT_OPTIONS_PATH"

built_dmgs=()

for arch in $RELEASE_ARCHS; do
  asset_arch="$(asset_arch_for "$arch")"
  archive_path="$BUILD_ROOT/${APP_ASSET_NAME}-${asset_arch}.xcarchive"
  export_path="$BUILD_ROOT/export/${APP_ASSET_NAME}-${asset_arch}"
  dmg_path="$ARTIFACTS_PATH/${DMG_BASENAME}-${asset_arch}.dmg"

  validate_path_within_base 'ARCHIVE_PATH' "$archive_path" "$BUILD_ROOT" >/dev/null
  validate_path_within_base 'EXPORT_PATH' "$export_path" "$BUILD_ROOT" >/dev/null
  validate_path_within_base 'DMG_PATH' "$dmg_path" "$ARTIFACTS_PATH" >/dev/null

  safe_remove -rf 'ARCHIVE_PATH' "$archive_path" "$BUILD_ROOT"
  safe_remove -rf 'EXPORT_PATH' "$export_path" "$BUILD_ROOT"
  safe_remove -f 'DMG_PATH' "$dmg_path" "$ARTIFACTS_PATH"

  echo "==> $arch"

  # The Developer ID profile (it carries the iCloud container) is set on the
  # Runner target alone. An `-xcconfig` value would reach every target in the
  # workspace, including the Swift packages Flutter's plugins are built as,
  # and those have no profile. Re-applied per architecture because the archive
  # below is followed by a restore: the checkout is left as it was found even
  # when a build fails.
  APP_PROFILE_NAME="$APP_PROFILE_NAME" perl -0pi -e '
    my $profile = $ENV{"APP_PROFILE_NAME"};
    s{(CODE_SIGN_ENTITLEMENTS = Runner/Release\.entitlements;.*?PROVISIONING_PROFILE_SPECIFIER = )"";}{$1"$profile";}s
      or die "macOS Runner Release provisioning profile setting not found\n";
  ' "$RUNNER_PROJECT_FILE"

  # Command-line ARCHS takes precedence over the `-xcconfig` file.
  # ONLY_ACTIVE_ARCH=NO prevents Xcode from silently selecting the host
  # architecture instead of the requested one.
  xcodebuild \
    -workspace "$WORKSPACE_PATH" \
    -scheme "$SCHEME" \
    -configuration "$CONFIGURATION" \
    -archivePath "$archive_path" \
    -xcconfig "$OVERRIDE_XCCONFIG_PATH" \
    ARCHS="$arch" \
    ONLY_ACTIVE_ARCH=NO \
    FLUTTER_BUILD_NAME="$MARKETING_VERSION" \
    FLUTTER_BUILD_NUMBER="$CURRENT_PROJECT_VERSION" \
    archive

  restore_runner_project

  xcodebuild -exportArchive \
    -archivePath "$archive_path" \
    -exportPath "$export_path" \
    -exportOptionsPlist "$EXPORT_OPTIONS_PATH"

  app_path="$export_path/${APP_NAME}.app"
  if [[ ! -d "$app_path" ]]; then
    echo "exported app not found at $app_path" >&2
    exit 1
  fi

  verify_app_arch "$app_path" "$arch"
  codesign --verify --deep --strict --verbose=2 "$app_path"
  warn_pre_notary_spctl_rejection "$app_path"

  APP_PATH="$app_path" \
  APP_NAME="$APP_NAME" \
  APP_ASSET_NAME="$APP_ASSET_NAME" \
  VOLUME_NAME="$VOLUME_NAME" \
  ARTIFACTS_PATH="$ARTIFACTS_PATH" \
  DMG_STAGING_PATH="$DMG_STAGING_PATH" \
  DMG_BASENAME="${DMG_BASENAME}-${asset_arch}" \
  DMG_PATH="$dmg_path" \
  REQUIRE_SPCTL=0 \
  bash "$SCRIPT_DIR/package-dmg.sh"

  codesign --force --sign "$SIGNING_IDENTITY" --timestamp "$dmg_path"
  codesign --verify --verbose=2 "$dmg_path"

  notarize_dmg "$dmg_path"
  staple_dmg "$dmg_path"
  xcrun stapler validate "$dmg_path"
  spctl -a -t open --context context:primary-signature -vv "$dmg_path"

  built_dmgs+=("$dmg_path")
  done

if [[ "$PUBLISH_GITHUB_RELEASE" == "1" ]]; then
  if gh release view "$RELEASE_TAG" --repo "$APP_REPO_SLUG" >/dev/null 2>&1; then
    gh release edit "$RELEASE_TAG" \
      --repo "$APP_REPO_SLUG" \
      --title "$RELEASE_TITLE"
  else
    gh release create "$RELEASE_TAG" \
      --repo "$APP_REPO_SLUG" \
      --title "$RELEASE_TITLE" \
      --notes ""
  fi

  gh release upload "$RELEASE_TAG" "${built_dmgs[@]}" \
    --repo "$APP_REPO_SLUG" \
    --clobber
  update_release_checksums "${built_dmgs[@]}"
fi

echo "Release complete"
echo "Marketing version: $MARKETING_VERSION"
echo "Build number: $CURRENT_PROJECT_VERSION"
echo "Architectures: $RELEASE_ARCHS"
for dmg in "${built_dmgs[@]}"; do
  echo "DMG: $dmg"
done
if [[ "$PUBLISH_GITHUB_RELEASE" == "1" ]]; then
  echo "GitHub release: $APP_REPO_SLUG $RELEASE_TAG"
fi
