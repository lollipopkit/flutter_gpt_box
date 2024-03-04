import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chatgpt/core/ext/context/dialog.dart';
import 'package:flutter_chatgpt/core/route/page.dart';
import 'package:flutter_chatgpt/data/res/l10n.dart';
import 'package:flutter_chatgpt/data/res/ui.dart';
import 'package:flutter_chatgpt/view/page/image.dart';

final class ImageListTile extends StatelessWidget {
  final String imageUrl;
  final String heroTag;

  const ImageListTile({
    super.key,
    required this.imageUrl,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final ImageProvider provider = switch (imageUrl) {
      _ when imageUrl.startsWith('http') =>
        NetworkImage(imageUrl) as ImageProvider,
      _ when imageUrl.startsWith('assets') => AssetImage(imageUrl),
      _ => FileImage(File(imageUrl)),
    };
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Material(
        child: InkWell(
          onTap: () => Routes.image.go(
            context,
            args: ImagePageArgs(
              tag: heroTag,
              image: provider,
            ),
          ),
          child: Container(
            height: 77,
            decoration: BoxDecoration(
              color: const Color.fromARGB(39, 245, 245, 245),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 7),
            child: Row(
              children: [
                SizedBox(
                  width: 77,
                  height: 77,
                  child: _buildImage(provider),
                ),
                UIs.width13,
                Expanded(
                  child: Text(
                    imageUrl,
                    style: UIs.text11Bold,
                    maxLines: 3,
                    overflow: TextOverflow.fade,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(ImageProvider provider) {
    return Hero(
      tag: heroTag,
      child: Image(
        image: provider,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return Column(
            children: [
              UIs.centerSizedLoading,
              UIs.height13,
              Text(
                  '${loadingProgress.cumulativeBytesLoaded} / ${loadingProgress.expectedTotalBytes}'),
            ],
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Column(
            children: [
              const Icon(Icons.broken_image, size: 50),
              UIs.height13,
              TextButton(
                onPressed: () {
                  final text = '$error\n\n$stackTrace';
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
                },
                child: Text(l10n.error),
              ),
            ],
          );
        },
      ),
    );
  }
}
