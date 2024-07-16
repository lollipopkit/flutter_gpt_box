abstract final class GithubId {
  /// Sorted by name
  static const participants = {
    'Annalasu',
    'bxoooooo',
    'CHEN1016',
    'Http-200',
    'luoxiashen',
    'Mgrsc',
    'SeaHI-Robot',
  };

  static const contributors = {
    'ParperCube',
  };

  static final String markdownStr = () {
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
  }();
}
