enum ErrFrom {
  unknown,
  icloud,
  webdav,
  ;
}

abstract class Err<T> {
  final ErrFrom from;
  final T type;
  final String? message;

  Err({required this.from, required this.type, this.message});
}

enum ICloudErrType {
  generic,
  notFound,
  multipleFiles,
}

class ICloudErr extends Err<ICloudErrType> {
  ICloudErr({required super.type, super.message}) : super(from: ErrFrom.icloud);

  @override
  String toString() {
    return 'ICloudErr<$type>: $message';
  }
}

enum WebdavErrType {
  generic,
  notFound,
  ;
}

class WebdavErr extends Err<WebdavErrType> {
  WebdavErr({required super.type, super.message}) : super(from: ErrFrom.webdav);

  @override
  String toString() {
    return 'WebdavErr<$type>: $message';
  }
}