part of 'home.dart';

final class _MarkdownCopyPage extends StatelessWidget {
  final String text;
  final List<Widget> actions;
  final String heroTag;

  const _MarkdownCopyPage({
    required this.text,
    required this.actions,
    required this.heroTag,
  });

//   @override
//   State<_MarkdownCopyPage> createState() => _MarkdownCopyPageState();
// }

// final class _MarkdownCopyPageState extends State<_MarkdownCopyPage>
//     with SingleTickerProviderStateMixin {
//   late final _animeCtrl = AnimationController(
//     vsync: this,
//     duration: Durations.medium1,
//   );

//   @override
//   void initState() {
//     super.initState();
//     _animeCtrl.forward();
//   }

  // @override
  // Widget build(BuildContext context) {
  //   return PopScope(
  //     canPop: true,
  //     onPopInvoked: (_) async {
  //       await _animeCtrl.reverse();
  //     },
  //     child: _buildBody(),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(l10n.raw),
        centerTitle: false,
        actions: actions,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Hero(
      tag: heroTag,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 13),
        child: SelectableText(
          text,
          autofocus: true,
          showCursor: true,
          style: TextStyle(
            fontSize: 14,
            color: UIs.textColor.fromBool(RNode.dark.value),
          ),
        ),
      ),
    );
  }
}
