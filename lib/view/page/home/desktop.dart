part of 'home.dart';

/// Meta on macOS, Control elsewhere: on Linux the Super key belongs to the
/// window manager.
SingleActivator _chord(LogicalKeyboardKey key) => SingleActivator(key, meta: isMacOS, control: !isMacOS);

/// The keys a desktop expects. [PlatformMenuBar] only exists on macOS, so the
/// bindings live here to work on Linux and Windows too.
Map<ShortcutActivator, VoidCallback> _desktopShortcuts(_HomePageState s) {
  if (!isDesktop) return const {};
  return {
    _chord(LogicalKeyboardKey.keyN): s._newChat,
    _chord(LogicalKeyboardKey.comma): s._openSettings,
    _chord(LogicalKeyboardKey.keyF): s._search,
    _chord(LogicalKeyboardKey.bracketLeft): () => s._step(-1),
    _chord(LogicalKeyboardKey.bracketRight): () => s._step(1),
  };
}

/// Replaces the default macOS menu bar, so the standard items are kept.
List<PlatformMenuItem> _macosMenus(_HomePageState s) {
  return [
    PlatformMenu(
      label: BuildData.name,
      menus: [
        const PlatformMenuItemGroup(
          members: [PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.about)],
        ),
        PlatformMenuItemGroup(
          members: [
            PlatformMenuItem(
              label: libL10n.setting,
              shortcut: _chord(LogicalKeyboardKey.comma),
              onSelected: s._openSettings,
            ),
          ],
        ),
        const PlatformMenuItemGroup(
          members: [
            PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.hide),
            PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.hideOtherApplications),
            PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.showAllApplications),
          ],
        ),
        const PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.quit),
      ],
    ),
    PlatformMenu(
      label: l10n.chat,
      menus: [
        PlatformMenuItem(label: l10n.newChat, shortcut: _chord(LogicalKeyboardKey.keyN), onSelected: s._newChat),
        PlatformMenuItem(label: libL10n.search, shortcut: _chord(LogicalKeyboardKey.keyF), onSelected: s._search),
        PlatformMenuItemGroup(
          members: [
            PlatformMenuItem(
              label: libL10n.previous,
              shortcut: _chord(LogicalKeyboardKey.bracketLeft),
              onSelected: () => s._step(-1),
            ),
            PlatformMenuItem(
              label: libL10n.next,
              shortcut: _chord(LogicalKeyboardKey.bracketRight),
              onSelected: () => s._step(1),
            ),
          ],
        ),
      ],
    ),
    const PlatformMenu(
      label: 'Window',
      menus: [
        PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.minimizeWindow),
        PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.zoomWindow),
        PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.toggleFullScreen),
      ],
    ),
  ];
}
