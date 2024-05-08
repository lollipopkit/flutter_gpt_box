import 'package:flutter/material.dart';
import 'package:gpt_box/core/ext/value_notifier.dart';
import 'package:gpt_box/data/res/ui.dart';

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

  /// Can't use `late` because it's not initialized in [dispose]
  ///
  /// The animation controller is created when the overlay is shown.
  AnimationController? _animeCtrl;
  Animation<Offset>? _offsetAnime;
  Animation<double>? _fadeAnime;
  Animation<Color?>? _colorAnime;

  MediaQueryData? _media;

  final _isShowingOverlay = false.vn;

  // @override
  // void initState() {
  //   super.initState();
  // }

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

  void _showOverlay(BuildContext context) async {
    /// Set it here, so [BlurOverlay.close] must point to this function owned by
    /// this instance.
    BlurOverlay.close = _removeOverlay;

    /// Only create once (`??=`)
    _animeCtrl ??= AnimationController(
      vsync: this,
      duration: Durations.medium1,
    );

    final renderBox = context.findRenderObject() as RenderBox;
    var startOffset = renderBox.localToGlobal(Offset.zero);
    final overlayState = Overlay.of(context);
    final overlayBox = overlayState.context.findRenderObject() as RenderBox;
    var endOffset = overlayBox.size.centerLeft(Offset.zero);
    _offsetAnime = Tween(
      begin: startOffset - endOffset,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animeCtrl!, curve: Curves.easeInOutCubic),
    );

    _fadeAnime = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animeCtrl!, curve: Curves.easeInOutCubic),
    );
    _colorAnime = ColorTween(
      begin: Colors.transparent,
      end: Colors.black,
    ).animate(
      CurvedAnimation(parent: _animeCtrl!, curve: Curves.easeInOutCubic),
    );

    _overlayEntry = _createOverlayEntry(context);
    overlayState.insert(_overlayEntry!);

    await _animeCtrl?.forward();
    _isShowingOverlay.value = true;
  }

  void _removeOverlay() async {
    await _animeCtrl!.reverse();
    _overlayEntry!.remove();
    _overlayEntry = null;
    _isShowingOverlay.value = false;
  }

  OverlayEntry _createOverlayEntry(BuildContext context) {
    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _removeOverlay,
        behavior: HitTestBehavior.opaque,
        child: AnimatedBuilder(
          animation: _animeCtrl!,
          builder: (_, __) {
            return Container(
              color: _colorAnime!.value,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 11),
              child: FadeTransition(
                opacity: _fadeAnime!,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.translate(
                      offset: _offsetAnime!.value,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: (_media?.size.height ?? 700) * 0.6,
                        ),
                        child: widget.popup(),
                      ),
                    ),
                    if (widget.bottom != null) UIs.height13,
                    if (widget.bottom != null) widget.bottom!(),
                  ],
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
    return ValueListenableBuilder(
      valueListenable: _isShowingOverlay,
      builder: (_, isShowing, __) {
        return PopScope(
          canPop: !isShowing,
          onPopInvoked: (didPop) {
            if (_overlayEntry == null) return;
            _removeOverlay();
          },
          child: GestureDetector(
            onLongPress: () => _showOverlay(context),
            child: widget.child,
          ),
        );
      },
    );
  }
}
