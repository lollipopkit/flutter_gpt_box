part of 'home.dart';

final class _MarkdownCopyPage extends StatelessWidget {
  final ChatHistoryItem item;

  const _MarkdownCopyPage({required this.item});

  static void go(BuildContext context, ChatHistoryItem item) =>
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => _MarkdownCopyPage(item: item),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(l10n.raw),
        centerTitle: false,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 13),
      child: FutureWidget(
        future: compute((e) => e.toMarkdown, item),
        error: (e, s) => SimpleMarkdown(data: '$e\n\n$s'),
        success: (val) => SelectableText(
          val ?? 'null',
          autofocus: true,
          showCursor: true,
          style: TextStyle(
            fontSize: 14,
            color: UIs.textColor.fromBool(RNodes.dark.value),
          ),
        ),
      ),
    );
  }
}
