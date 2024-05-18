part of 'home.dart';

final class _MarkdownCopyPage extends StatelessWidget {
  final String text;

  const _MarkdownCopyPage({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(l10n.raw),
        centerTitle: false,
        actions: IconButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: text));
          },
          icon: const Icon(Icons.copy, size: 20),
        ).asList,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 13),
      child: SelectableText(
        text,
        autofocus: true,
        showCursor: true,
        style: TextStyle(
          fontSize: 14,
          color: UIs.textColor.fromBool(RNodes.dark.value),
        ),
      ),
    );
  }
}
