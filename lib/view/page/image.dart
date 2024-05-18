import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/material.dart';
import 'package:gpt_box/data/res/l10n.dart';

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
              actions: Btns.oks(onTap: () => context.pop(true), okStr: l10n.ok,),
            );
            if (sure != true) return;
            context.pop(const ImagePageRet(isDeleted: true));
          },
          child: const Icon(Icons.delete)),
      body: GestureDetector(
        onTap: () => context.pop(),
        child: Container(
          color: Colors.black,
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
