part of 'home.dart';

final class _FilePicked {
  final String local;
  final String? remote;

  const _FilePicked({
    required this.local,
    this.remote,
  });

  /// Save the bytes to a file and upload it to the server.
  static Future<_FilePicked> fromBytes(Uint8List data, {String? mime}) async {
    final path = await data.save();
    if (canUpload) {
      final remote = await FileApi.upload([path]);
      return _FilePicked(local: path, remote: remote.first);
    }
    return _FilePicked(local: path);
  }

  // static Future<_FilePicked?> fromLocal(String path) async {
  //   final file = File(path);
  //   if (!await file.exists()) return null;
  //   if (canUpload) {
  //     final remote = await FileApi.upload([path]);
  //     return _FilePicked(local: path, remote: remote.first);
  //   }
  //   return _FilePicked(local: path);
  // }

  // static Future<_FilePicked?> fromRemote(String url) async {
  //   if (url.isEmpty || !url.startsWith('http')) return null;
  //   final data = await FileApi.download(url);
  //   final path = await data.save();
  //   return _FilePicked(local: path, remote: url);
  // }

  /// Get the file from the server.
  // static Future<_FilePicked?> fromUrl(String url) async {
  //   if (url.isEmpty) return null;
  //   final isHttp = url.startsWith('http');
  //   final isFile = url.isFileUrl();
  //   if (!isHttp && !isFile) return null;
  //   if (isFile) return fromLocal(url);
  //   return fromRemote(url);
  // }

  Future<void> delete() async {
    if (remote != null) {
      await FileApi.delete([remote!]);
    }
    await file.delete();
  }

  /// Return the file object of [local].
  File get file => File(local);

  /// If [remote] is null, use [local] as the url.
  String get url => remote ?? local;

  static bool get canUpload =>
      Stores.setting.usePhotograph.fetch() && UserApi.loggedIn;

  @override
  String toString() => '_FilePicked(local: $local, remote: $remote)';
}
