import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chatgpt/core/ext/context/dialog.dart';
import 'package:flutter_chatgpt/core/ext/num.dart';
import 'package:flutter_chatgpt/core/route/page.dart';
import 'package:flutter_chatgpt/data/res/l10n.dart';
import 'package:flutter_chatgpt/data/res/ui.dart';
import 'package:flutter_chatgpt/view/page/image.dart';
import 'package:flutter_chatgpt/view/widget/card.dart';

final class ImageCard extends StatefulWidget {
  final String imageUrl;
  final String heroTag;
  final void Function(ImagePageRet)? onRet;

  const ImageCard({
    super.key,
    required this.imageUrl,
    required this.heroTag,
    this.onRet,
  });

  static double height = 177;

  @override
  State<ImageCard> createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard> {
  Object? err;
  StackTrace? trace;

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.imageUrl;
    final ImageProvider provider = switch (imageUrl) {
      _ when imageUrl.startsWith('http') =>
        NetworkImage(imageUrl) as ImageProvider,
      _ when imageUrl.startsWith('assets') => AssetImage(imageUrl),
      _ => FileImage(File(imageUrl)),
    };

    return CardX(
      child: InkWell(
        onTap: () async {
          if (err != null || trace != null) {
            final text = '$err\n\n$trace';
            context.showRoundDialog(
              title: l10n.error,
              child: SingleChildScrollView(child: Text(text)),
              actions: [
                TextButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: text));
                  },
                  child: Text(l10n.copy),
                )
              ],
            );
            return;
          }
          final ret = await Routes.image.go(
            context,
            args: ImagePageArgs(
              tag: widget.heroTag,
              image: provider,
            ),
          );
          if (ret != null) widget.onRet?.call(ret);
        },
        child: Padding(
          padding: const EdgeInsets.all(7),
          child: SizedBox(
            width: ImageCard.height,
            height: ImageCard.height,
            child: _buildImage(provider),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(ImageProvider provider) {
    return Hero(
      tag: widget.heroTag,
      transitionOnUserGestures: true,
      child: Image(
        image: provider,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          final loadedBytes = loadingProgress.cumulativeBytesLoaded.bytes2Str;
          final totalBytes = loadingProgress.expectedTotalBytes?.bytes2Str;
          final progress = '$loadedBytes / $totalBytes';
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UIs.centerSizedLoading,
              UIs.height13,
              Text(progress),
            ],
          );
        },
        errorBuilder: (context, error, stackTrace) {
          err = error;
          trace = stackTrace;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.broken_image, size: 50),
              UIs.height13,
              Text('${l10n.error} Log'),
            ],
          );
        },
      ),
    );
  }
}
