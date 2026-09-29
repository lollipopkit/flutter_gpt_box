import 'package:fl_lib/fl_lib.dart';

/// A path the memory refuses: outside it, malformed, or too long.
final class MemoryPathError implements Exception {
  const MemoryPathError(this.message);

  final String message;

  @override
  String toString() => message;
}

/// The model's memory: text files under `/memories`, kept across chats.
///
/// One row per file, keyed by its path below `/memories` (`MEMORY.md`,
/// `projects/app.md`); directories are only prefixes. Being a store, it is
/// encrypted with the rest, and backups merge it per file.
final class MemoryStore extends SqliteStore {
  MemoryStore._() : super('memory') {
    watch().listen((_) => changes.notify());
  }

  static final instance = MemoryStore._();

  static const root = '/memories';

  /// The index: shown in every chat's system prompt.
  static const index = 'MEMORY.md';

  static const maxFileChars = 64 * 1024;
  static const _maxPathChars = 200;

  /// Notified on every change, for the memory page.
  final changes = RNode();

  /// [path] as a key: relative to [root], `/`-separated, no `.`/`..`, empty
  /// for the root itself. Accepts `/memories/a.md`, `/a.md` and `a.md`.
  static String keyOf(String path) {
    var p = path.trim().replaceAll(RegExp(r'/+'), '/');
    if (p == root || p == '$root/') return '';
    if (p.startsWith('$root/')) {
      p = p.substring(root.length + 1);
    } else if (p.startsWith('/')) {
      p = p.substring(1);
    }
    if (p.endsWith('/')) p = p.substring(0, p.length - 1);
    if (p.isEmpty) return '';
    if (p.length > _maxPathChars) throw const MemoryPathError('Path too long');
    if (p.contains('\\') || p.contains(_invisible)) throw MemoryPathError('Invalid path: $path');
    for (final seg in p.split('/')) {
      if (seg == '.' || seg == '..') throw MemoryPathError('Path outside $root: $path');
      // The store's own bookkeeping starts with an underscore.
      if (seg.startsWith('_')) throw MemoryPathError('Invalid path: $path');
    }
    return p;
  }

  /// [key] as the model sees it.
  static String pathOf(String key) => key.isEmpty ? root : '$root/$key';

  /// Characters that hide text from a reader: zero-width and bidi controls.
  static final _invisible = RegExp(r'[\u200B-\u200F\u202A-\u202E\u2060-\u2064\u2066-\u2069\uFEFF]');

  /// Every file, by key, sorted.
  Map<String, String> files() {
    final all = getAllMap();
    final keys = all.keys.toList()..sort();
    return {
      for (final k in keys)
        if (all[k] case final String v) k: v,
    };
  }

  String? read(String key) => get<String>(key);

  bool isDir(String key) {
    if (key.isEmpty) return true;
    final prefix = '$key/';
    return keys().any((k) => k.startsWith(prefix));
  }

  /// Files at or below [key]: the file itself, or everything in the directory.
  List<String> under(String key) {
    if (key.isEmpty) return files().keys.toList();
    final prefix = '$key/';
    return [
      for (final k in files().keys)
        if (k == key || k.startsWith(prefix)) k,
    ];
  }

  DateTime? modified(String key) {
    final ts = lastUpdateTs?[key];
    return ts == null ? null : DateTime.fromMillisecondsSinceEpoch(ts);
  }

  /// Writes [content] to the file at [key], creating it.
  void write(String key, String content) {
    if (key.isEmpty) throw const MemoryPathError('Not a file');
    if (content.length > maxFileChars) {
      throw MemoryPathError('Too long: ${content.length} characters, at most $maxFileChars');
    }
    if (content.contains(_invisible)) {
      throw const MemoryPathError('Content has invisible characters (zero-width or bidi controls)');
    }
    if (isDir(key)) throw MemoryPathError('${pathOf(key)} is a directory');
    // A file cannot be where a directory of it would be: `a` and `a/b`.
    final parts = key.split('/');
    for (var i = 1; i < parts.length; i++) {
      final dir = parts.take(i).join('/');
      if (read(dir) != null) throw MemoryPathError('${pathOf(dir)} is a file');
    }
    set(key, content);
  }

  /// Deletes the file or directory at [key]; how many files went.
  int delete(String key) {
    final gone = under(key);
    SqliteStore.transact(() {
      for (final k in gone) {
        remove(k);
      }
    });
    return gone.length;
  }

  /// Moves the file or directory at [from] to [to]; how many files moved.
  int move(String from, String to) {
    if (from.isEmpty || to.isEmpty) throw const MemoryPathError('Cannot move the root');
    if (to == from || to.startsWith('$from/')) throw const MemoryPathError('Cannot move into itself');
    final src = under(from);
    if (src.isEmpty) throw MemoryPathError('Not found: ${pathOf(from)}');
    if (under(to).isNotEmpty) throw MemoryPathError('Already exists: ${pathOf(to)}');
    SqliteStore.transact(() {
      for (final k in src) {
        final dest = k == from ? to : '$to${k.substring(from.length)}';
        write(dest, read(k)!);
        remove(k);
      }
    });
    return src.length;
  }
}
