import 'dart:async';
import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/material.dart';
import 'package:gpt_box/core/route/page.dart';
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
  final completer = Completer<ImageProvider>();

  @override
  void initState() {
    super.initState();

    final imageUrl = widget.imageUrl;
    if (imageUrl.startsWith('http')) {
      final isSupa = imageUrl.startsWith(Urls.supaUrl);
      final headers = isSupa ? SupaUtils.authHeaders : null;
      completer.complete(ExtendedNetworkImageProvider(
        imageUrl,
        headers: headers,
        cache: true,
      ));
    } else if (imageUrl.startsWith('assets')) {
      completer.complete(AssetImage(imageUrl));
    } else {
      completer.complete(FileImage(File(imageUrl)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ImageCard.height,
      height: ImageCard.height,
      child: CardX(
        child: FutureWidget(
          future: completer.future,
          error: _buildErr,
          success: _buildImage,
        ),
      ),
    );
  }

  Widget _buildImage(ImageProvider? provider) {
    if (provider == null) {
      return _buildErr('provider is null', null);
    }
    return InkWell(
      onTap: () async {
        if (!completer.isCompleted) return;

        final ret = await Routes.image.go(
          context,
          args: ImagePageArgs(
            tag: widget.heroTag,
            image: await completer.future,
            url: widget.imageUrl,
          ),
        );
        if (ret != null) widget.onRet?.call(ret);
      },
      child: Hero(
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
                SizedLoading.centerSmall,
                UIs.height13,
                Text(progress),
              ],
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return _buildErr(error, stackTrace);
          },
        ),
      ),
    );
  }

  Widget _buildErr(Object? err, StackTrace? trace) {
    return InkWell(
      onTap: () {
        context.showErrDialog(err, trace);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.broken_image, size: 50),
          UIs.height13,
          Text('${libL10n.error} Log'),
        ],
      ),
    );
  }
}
