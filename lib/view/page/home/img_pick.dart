part of 'home.dart';

final class _ImgPicked {
  final String id;
  final String pubUrl;
  final String signedUrl;
  final Uint8List data;

  const _ImgPicked({
    required this.id,
    required this.pubUrl,
    required this.signedUrl,
    required this.data,
  });

  static final Map<String, _ImgPicked> _md5Cache = {};
  static final Map<String, _ImgPicked> _pubUrlCache = {};

  static Future<_ImgPicked> fromData(Uint8List data) async {
    final id = data.md5Sum;
    final cache = _md5Cache[id];
    if (cache != null) return cache;

    final uid = supa.client.auth.currentUser?.id;
    final path = '$uid/$id.jpg';
    try {
      await Supa.imgBucket.uploadBinary(path, data);
    } catch (e, s) {
      if (e is StorageException) {
        switch (e.statusCode) {
          case '409':
            // File already exists, pass
            break;
        }
      } else {
        Loggers.app.warning('Failed to upload image', e, s);
      }
    }
    final pubUrl =
        Supa.imgBucket.getPublicUrl(path).replaceFirst('/public/', '/');
    final priUrl = await Supa.imgBucket.createSignedUrl(path, 600);
    final item = _ImgPicked(
      id: id,
      pubUrl: pubUrl,
      signedUrl: priUrl,
      data: data,
    );
    _md5Cache[id] = item;
    _pubUrlCache[pubUrl] = item;
    return item;
  }

  static Future<_ImgPicked> fromPubUrl(String pubUrl) async {
    final cache = _pubUrlCache[pubUrl];
    if (cache != null) return cache;

    final path = pubUrl.replaceFirst(Supa.imgBucket.url, '');
    //assert(Supa.imgBucket.getPublicUrl(path) == pubUrl);
    final data = await Supa.imgBucket.download(path);
    return fromData(data);
  }

  /// Write [data] to tmp dir and return [File]
  Future<File> get file async {
    final path = '${Paths.temp}/gptbox_temp_$id.jpg';
    final file = File(path);
    await file.writeAsBytes(data);
    return file;
  }

  @override
  String toString() {
    return '_ImgPicked{id: $id, pubUrl: $pubUrl}';
  }
}
