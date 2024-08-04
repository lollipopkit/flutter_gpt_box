import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gpt_box/data/res/l10n.dart';

final class ImagePageArgs {
  final String? title;
  final String tag;
  final ImageProvider image;
  final String url;

  const ImagePageArgs({
    this.title,
    required this.tag,
    required this.image,
    required this.url,
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
      appBar: CustomAppBar(
        actions: [
          // Share
          IconButton(
            onPressed: () async {
              final (path, err) = await context.showLoadingDialog(
                fn: () => _getImgData(args!.url),
              );
              if (err != null || path == null) return;
              await Pfs.share(
                path: path,
                name: 'gptbox_img.jpg',
                mime: 'image/jpeg',
              );
            },
            icon: const Icon(Icons.share),
          ),
          // Delete
          IconButton(
            onPressed: () async {
              final sure = await context.showRoundDialog(
                title: l10n.delete,
                child: Text(
                  l10n.delFmt(args?.title ?? l10n.untitled, l10n.image),
                ),
                actions: Btnx.oks,
              );
              if (sure != true) return;
              context.pop(const ImagePageRet(isDeleted: true));
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
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

Future<String> _getImgData(String url) async {
  if (url.startsWith('http')) {
    /// TODO: If is supa url
    final resp = await myDio.get(url,
        options: Options(responseType: ResponseType.bytes));
    final data = resp.data as Uint8List;
    final path = '${Paths.temp}/gptbox_temp_${data.md5Sum}.jpg';
    final file = File(path);
    await file.writeAsBytes(data);
    return file.path;
  } else if (url.startsWith('assets')) {
    // Write assets to tmp dir
    final data = (await rootBundle.load(url)).buffer.asUint8List();
    final path = '${Paths.temp}/gptbox_temp_${data.md5Sum}.jpg';
    final file = File(path);
    await file.writeAsBytes(data);
    return file.path;
  }

  final file = File(url);
  if (!(await file.exists())) await file.readAsBytes();
  return file.path;
}
