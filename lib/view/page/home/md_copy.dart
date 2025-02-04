part of 'home.dart';

final class _MarkdownCopyPage extends StatelessWidget {
  final ChatHistoryItem args;

  const _MarkdownCopyPage({Key? key, required this.args});

  static const route = AppRouteArg(
    page: _MarkdownCopyPage.new,
    path: '/md_copy',
  );

  @override
  Widget build(BuildContext context) {
    return FutureWidget(
      future: compute((e) => e.toMarkdown, args),
      error: (e, s) => SimpleMarkdown(data: '$e\n\n$s'),
      loading: Scaffold(
        appBar: AppBar(
          title: Text(l10n.raw),
          centerTitle: false,
          actions: const [SizedLoading.small, UIs.width7],
        ),
      ),
      success: (val) => Scaffold(
        appBar: AppBar(
          title: Text(l10n.raw),
          centerTitle: false,
        ),
        body: _buildBody(val),
      ),
    );
  }

  Widget _buildBody(String? val) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 13),
      child: SelectableText(
        val ?? 'null',
        autofocus: true,
      ),
    );
  }
}
