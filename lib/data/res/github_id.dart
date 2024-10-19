abstract final class GithubId {
  static const participants = {
    'Annalasu',
    'bxoooooo',
    'CHEN1016',
    'Http-200',
    'luoxiashen',
    'Mgrsc',
    'SeaHI-Robot',
    'alphavvv',
    'vimbackground',
  };

  static const contributors = {
    'ParperCube',
    'Integral',
  };

  static final String markdownStr = () {
    final sb = StringBuffer();
    sb.write('### 👋🏻 Contributors\n');
    for (final c in contributors) {
      sb.write('[$c](https://github.com/$c) ');
    }
    sb.writeln();
    sb.write('### 🥳 Participants\n');
    for (final p in participants) {
      sb.write('[$p](https://github.com/$p) ');
    }
    return sb.toString();
  }();
}
