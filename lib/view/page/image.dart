import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/core/ext/context/base.dart';
import 'package:flutter_chatgpt/core/ext/context/dialog.dart';
import 'package:flutter_chatgpt/core/util/ui.dart';
import 'package:flutter_chatgpt/data/res/l10n.dart';
import 'package:flutter_chatgpt/data/res/ui.dart';

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

final class ImagePageRet {
  final bool isDeleted;

  const ImagePageRet({
    this.isDeleted = false,
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
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final sure = await context.showRoundDialog(
              title: l10n.delete,
              child:
                  Text(l10n.delFmt(args?.title ?? l10n.untitled, l10n.image)),
              actions: Btns.oks(onTap: () => context.pop(true)),
            );
            if (sure != true) return;
            context.pop(const ImagePageRet(isDeleted: true));
          },
          child: const Icon(Icons.delete)),
      body: GestureDetector(
        onTap: () => context.pop(),
        child: Align(
          alignment: Alignment.center,
          child: Hero(
            tag: args!.tag,
            transitionOnUserGestures: true,
            child: Image(image: args!.image),
          ),
        ),
      ),
    );
  }
}
