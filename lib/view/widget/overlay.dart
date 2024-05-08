import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:gpt_box/data/res/ui.dart';

/// A Cupertino like overlay with blur effect.
class BlurOverlay extends StatefulWidget {
  final Widget child;
  final Widget Function() popup;
  final Widget Function()? bottom;

  const BlurOverlay({
    super.key,
    required this.child,
    this.bottom,
    required this.popup,
  });

  static void Function()? close;

  @override
  State<BlurOverlay> createState() => _BlurOverlayState();
}

class _BlurOverlayState extends State<BlurOverlay>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  /// Can't use `late` because it's not initialized in [dispose]
  ///
  /// The animation controller is created when the overlay is shown.
  AnimationController? _animeCtrl;
  Animation<double>? _blurAnime;
  Animation<double>? _fadeAnime;

  MediaQueryData? _media;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _media = MediaQuery.of(context);
  }

  @override
  void dispose() {
    _animeCtrl?.dispose();
    super.dispose();
    BlurOverlay.close = null;
  }

  void _showOverlay(BuildContext context) {
    /// Set it here, so [BlurOverlay.close] must point to this function owned by
    /// this instance.
    BlurOverlay.close = _removeOverlay;

    /// Only create once (`??=`)
    _animeCtrl ??= AnimationController(
      vsync: this,
      duration: Durations.medium1,
    );
    _blurAnime = Tween(begin: 0.0, end: 5.0).animate(
      CurvedAnimation(parent: _animeCtrl!, curve: Curves.easeInOutCubic),
    );
    _fadeAnime = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animeCtrl!, curve: Curves.easeInOutCubic),
    );

    _overlayEntry = _createOverlayEntry(context);
    Overlay.of(context).insert(_overlayEntry!);

    _animeCtrl?.forward();
  }

  void _removeOverlay() {
    _animeCtrl!.reverse().then((value) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

  OverlayEntry _createOverlayEntry(BuildContext context) {
    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _removeOverlay,
        behavior: HitTestBehavior.opaque,
        child: AnimatedBuilder(
          animation: _animeCtrl!,
          builder: (_, __) {
            return BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: _blurAnime!.value,
                sigmaY: _blurAnime!.value,
              ),
              child: Container(
                color: const Color.fromARGB(77, 0, 0, 0),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 7),
                child: FadeTransition(
                  opacity: _fadeAnime!,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: (_media?.size.height ?? 700) * 0.7,
                        ),
                        child: widget.popup(),
                      ),
                      if (widget.bottom != null) UIs.height13,
                      if (widget.bottom != null) widget.bottom!(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: PopScope(
        canPop: false,
        onPopInvoked: (_) => _removeOverlay(),
        child: GestureDetector(
          onLongPress: () => _showOverlay(context),
          child: widget.child,
        ),
      ),
    );
  }
}
