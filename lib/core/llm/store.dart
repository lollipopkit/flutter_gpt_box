import 'package:fl_lib/fl_lib.dart';
import 'package:fl_pi_llm/fl_pi_llm.dart';

/// pi's sessions, kept in the app's encrypted SQLite database.
///
/// A session is an append-only JSONL file to pi, so a file is stored as its
/// appended chunks, one row each: an append is an insert, and a read joins
/// the rows in order. Nothing is rewritten on append.
final class SqlitePiSessionStore implements PiSessionStore {
  SqlitePiSessionStore() {
    SqliteDb.instance.execute('''
CREATE TABLE IF NOT EXISTS pi_chunks (
  path  TEXT    NOT NULL,
  seq   INTEGER NOT NULL,
  text  TEXT    NOT NULL,
  mtime INTEGER NOT NULL,
  PRIMARY KEY (path, seq)
) WITHOUT ROWID;
''');
  }

  static final instance = SqlitePiSessionStore();

  static int get _now => DateTime.now().millisecondsSinceEpoch;

  @override
  Future<String?> read(String path, {int? maxLines}) async {
    final rows = SqliteDb.instance.select(
      'SELECT text FROM pi_chunks WHERE path = ? ORDER BY seq;',
      [path],
    );
    if (rows.isEmpty) return null;
    final sb = StringBuffer();
    var lines = 0;
    for (final r in rows) {
      final t = r['text'] as String;
      sb.write(t);
      if (maxLines != null) {
        lines += '\n'.allMatches(t).length;
        if (lines >= maxLines) break;
      }
    }
    return sb.toString();
  }

  @override
  Future<void> write(String path, String text) async {
    SqliteStore.transact(() {
      final db = SqliteDb.instance;
      db.execute('DELETE FROM pi_chunks WHERE path = ?;', [path]);
      db.execute('INSERT INTO pi_chunks (path, seq, text, mtime) VALUES (?, 0, ?, ?);', [path, text, _now]);
    });
  }

  @override
  Future<void> append(String path, String text) async {
    SqliteDb.instance.execute(
      '''
INSERT INTO pi_chunks (path, seq, text, mtime)
SELECT ?1, COALESCE(MAX(seq) + 1, 0), ?2, ?3 FROM pi_chunks WHERE path = ?1;
''',
      [path, text, _now],
    );
  }

  @override
  Future<void> rename(String from, String to) async {
    SqliteStore.transact(() {
      final db = SqliteDb.instance;
      db.execute('DELETE FROM pi_chunks WHERE path = ?;', [to]);
      db.execute('UPDATE pi_chunks SET path = ? WHERE path = ?;', [to, from]);
    });
  }

  @override
  Future<void> remove(String path, {bool recursive = false}) async {
    final db = SqliteDb.instance;
    db.execute('DELETE FROM pi_chunks WHERE path = ?;', [path]);
    if (recursive) {
      db.execute("DELETE FROM pi_chunks WHERE substr(path, 1, length(?) + 1) = ? || '/';", [path, path]);
    }
  }

  @override
  Future<StoredFile?> stat(String path) async {
    final rows = SqliteDb.instance.select(
      'SELECT SUM(length(text)) AS size, MAX(mtime) AS mtime FROM pi_chunks WHERE path = ?;',
      [path],
    );
    final r = rows.first;
    if (r['mtime'] == null) return null;
    return StoredFile(path, r['size'] as int, DateTime.fromMillisecondsSinceEpoch(r['mtime'] as int));
  }

  @override
  Future<List<StoredFile>> list(String dir) async {
    final prefix = dir == '/' ? '/' : '$dir/';
    final rows = SqliteDb.instance.select(
      '''
SELECT path, SUM(length(text)) AS size, MAX(mtime) AS mtime FROM pi_chunks
WHERE substr(path, 1, length(?1)) = ?1 GROUP BY path;
''',
      [prefix],
    );
    return [
      for (final r in rows)
        StoredFile(r['path'] as String, r['size'] as int, DateTime.fromMillisecondsSinceEpoch(r['mtime'] as int)),
    ];
  }

  /// Every stored file, for a backup.
  Map<String, String> dump() {
    final rows = SqliteDb.instance.select('SELECT path, text FROM pi_chunks ORDER BY path, seq;');
    final out = <String, StringBuffer>{};
    for (final r in rows) {
      (out[r['path'] as String] ??= StringBuffer()).write(r['text'] as String);
    }
    return out.map((k, v) => MapEntry(k, v.toString()));
  }

  /// When anything was last written: a cheap "has something changed".
  int latestMtime() =>
      SqliteDb.instance.select('SELECT MAX(mtime) AS m FROM pi_chunks;').firstOrNull?['m'] as int? ?? 0;

  /// The chat among [ids] the session file at [path] belongs to. pi names a
  /// session `<created>_<encoded id>.jsonl`, and an id may itself contain
  /// `_`, so it is matched rather than split out.
  static String? chatIdOf(String path, Iterable<String> ids) {
    final name = path.split('/').last;
    if (!name.endsWith('.jsonl')) return null;
    for (final id in ids) {
      if (name.endsWith('_${Uri.encodeComponent(id)}.jsonl')) return id;
    }
    return null;
  }

  /// Whether any stored file contains [needle], and which.
  List<String> search(String needle) {
    final rows = SqliteDb.instance.select(
      'SELECT DISTINCT path FROM pi_chunks WHERE instr(text, ?) > 0;',
      [needle],
    );
    return [for (final r in rows) r['path'] as String];
  }
}
