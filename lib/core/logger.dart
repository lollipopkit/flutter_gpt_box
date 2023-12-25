import 'package:logging/logging.dart';

abstract final class Loggers {
  static final root = Logger('Root');
  static final store = Logger('Store');
  static final route = Logger('Route');
  static final app = Logger('App');
}
