part of 'home.dart';

/// Meta on macOS, Control elsewhere: on Linux the Super key belongs to the
/// window manager.
SingleActivator _chord(LogicalKeyboardKey key) =>
    SingleActivator(key, meta: isMacOS, control: !isMacOS);

/// The keys a desktop expects. [PlatformMenuBar] only exists on macOS, so the
/// bindings live here to work on Linux and Windows too.
Map<ShortcutActivator, VoidCallback> _desktopShortcuts(BuildContext context) {
  if (!isDesktop) return const {};
  return {
    _chord(LogicalKeyboardKey.keyN): _onTapNewChat,
    _chord(LogicalKeyboardKey.comma): () => _onTapSettings(context),
    _chord(LogicalKeyboardKey.keyF): () => _onTapSearch(context),
    _chord(LogicalKeyboardKey.bracketLeft): _switchPreviousChat,
    _chord(LogicalKeyboardKey.bracketRight): _switchNextChat,
  };
}

/// Replaces the default macOS menu bar, so the standard items are kept.
List<PlatformMenuItem> _macosMenus(BuildContext context) {
  return [
    PlatformMenu(
      label: BuildData.name,
      menus: [
        const PlatformMenuItemGroup(
          members: [
            PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.about,
            ),
          ],
        ),
        PlatformMenuItemGroup(
          members: [
            PlatformMenuItem(
              label: libL10n.setting,
              shortcut: _chord(LogicalKeyboardKey.comma),
              onSelected: () => _onTapSettings(context),
            ),
          ],
        ),
        const PlatformMenuItemGroup(
          members: [
            PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.hide),
            PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.hideOtherApplications,
            ),
            PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.showAllApplications,
            ),
          ],
        ),
        const PlatformProvidedMenuItem(
          type: PlatformProvidedMenuItemType.quit,
        ),
      ],
    ),
    PlatformMenu(
      label: l10n.chat,
      menus: [
        PlatformMenuItem(
          label: libL10n.add,
          shortcut: _chord(LogicalKeyboardKey.keyN),
          onSelected: _onTapNewChat,
        ),
        PlatformMenuItem(
          label: libL10n.search,
          shortcut: _chord(LogicalKeyboardKey.keyF),
          onSelected: () => _onTapSearch(context),
        ),
        PlatformMenuItemGroup(
          members: [
            PlatformMenuItem(
              label: libL10n.previous,
              shortcut: _chord(LogicalKeyboardKey.bracketLeft),
              onSelected: _switchPreviousChat,
            ),
            PlatformMenuItem(
              label: libL10n.next,
              shortcut: _chord(LogicalKeyboardKey.bracketRight),
              onSelected: _switchNextChat,
            ),
          ],
        ),
      ],
    ),
    const PlatformMenu(
      label: 'Window',
      menus: [
        PlatformProvidedMenuItem(
          type: PlatformProvidedMenuItemType.minimizeWindow,
        ),
        PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.zoomWindow),
        PlatformProvidedMenuItem(
          type: PlatformProvidedMenuItemType.toggleFullScreen,
        ),
      ],
    ),
  ];
}
