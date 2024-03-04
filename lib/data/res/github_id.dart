abstract final class GithubId {
  static const participants = {
    'SeaHI-Robot',
    'Http-200',
    'bxoooooo',
  };

  static const contributors = {
    'ParperCube',
  };

  static String get markdownStr {
    final sb = StringBuffer();
    sb.write('- Participants: ');
    for (final p in participants) {
      sb.write('[$p](https://github.com/$p) ');
    }
    sb.writeln();
    sb.write('- Contributors: ');
    for (final c in contributors) {
      sb.write('[$c](https://github.com/$c) ');
    }
    return sb.toString();
  }
}
