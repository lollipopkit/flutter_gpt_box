import 'dart:async';
import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gpt_box/core/route/page.dart';
import 'package:gpt_box/core/supa.dart';
import 'package:gpt_box/data/res/l10n.dart';
import 'package:gpt_box/data/res/url.dart';
import 'package:gpt_box/view/page/image.dart';

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

  final provider = Completer<ImageProvider>();

  @override
  void initState() {
    super.initState();

    final imageUrl = widget.imageUrl;
    if (imageUrl.startsWith('http')) {
      final isSupa = imageUrl.startsWith(Urls.supaUrl);
      final headers = isSupa ? SupaUtils.authHeaders : null;
      provider.complete(ExtendedNetworkImageProvider(
        imageUrl,
        headers: headers,
        cache: true,
      ));
    } else if (imageUrl.startsWith('assets')) {
      provider.complete(AssetImage(imageUrl));
    } else {
      provider.complete(FileImage(File(imageUrl)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return CardX(
      child: InkWell(
        onTap: () async {
          if (!provider.isCompleted) return;
          if (err != null || trace != null) {
            final text = '$err\n\n```sh\n$trace```';
            context.showRoundDialog(
              title: l10n.error,
              child: SimpleMarkdown(data: text),
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
              image: await provider.future,
              url: widget.imageUrl,
            ),
          );
          if (ret != null) widget.onRet?.call(ret);
        },
        child: Padding(
          padding: const EdgeInsets.all(7),
          child: SizedBox(
            width: ImageCard.height,
            height: ImageCard.height,
            child: FutureWidget(
              future: provider.future,
              error: (e, s) {
                err = e;
                trace = s;
                return _buildErr();
              },
              success: _buildImage,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(ImageProvider? provider) {
    if (provider == null) {
      err = 'provider is null';
      return _buildErr();
    }
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
          return _buildErr();
        },
      ),
    );
  }

  Widget _buildErr() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.broken_image, size: 50),
        UIs.height13,
        Text('${l10n.error} Log'),
      ],
    );
  }
}
