import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/core/ext/context/base.dart';
import 'package:flutter_chatgpt/data/res/ui.dart';
import 'package:flutter_chatgpt/view/widget/appbar.dart';

final class ImagePageArgs {
  final String? title;
  final String tag;
  final ImageProvider image;

  const ImagePageArgs({
    this.title,
    required this.tag,
    required this.image,
  });
}

final class ImagePage extends StatelessWidget {
  final ImagePageArgs? args;

  const ImagePage({super.key, this.args});

  @override
  Widget build(BuildContext context) {
    if (args == null) {
      return UIs.placeholder;
    }
    return Stack(
      alignment: Alignment.center,
      children: [
        Hero(tag: args!.tag, child: Image(image: args!.image)),
        Positioned(
          top: CustomAppBar.titlebarHeight?.toDouble() ??
              MediaQuery.maybeOf(context)?.padding.top ??
              17,
          left: 17,
          child: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.close),
          ),
        )
      ],
    );
  }
}
