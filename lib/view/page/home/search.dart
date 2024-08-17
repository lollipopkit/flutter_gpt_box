part of 'home.dart';

class _ChatSearchDelegate extends SearchDelegate<ChatHistory> {
  _ChatSearchDelegate({String? initKeyword}) {
    query = initKeyword ?? '';
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => context.pop(),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSuggestionList(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSuggestionList(context);
  }

  Future<List<ChatHistory>> _filterChats(String query) async {
    query = query.toLowerCase();
    if (query.isEmpty) return [];
    return await compute((message) {
      final keys = <String>[];
      for (final chat in message.values) {
        if (chat.name?.toLowerCase().contains(query) ?? false) {
          keys.add(chat.id);
          continue;
        }
        if (chat.items.map((e) => e.toMarkdown).join('\n').contains(query)) {
          keys.add(chat.id);
        }
      }
      final list = <ChatHistory>[];
      for (final key in keys) {
        final chat = message[key];
        if (chat == null) continue;
        list.add(chat);
      }
      return list;
    }, _allHistories);
  }

  Widget _buildSuggestionList(BuildContext context) {
    return FutureWidget(
      future: _filterChats(query),
      loading: SizedBox(
        width: _media?.size.width ?? 300,
        child: SizedLoading.centerMedium,
      ),
      error: (error, trace) {
        Loggers.app.warning(error, trace);
        return ListTile(
          title: Text(l10n.attention),
          subtitle: Text('$error'),
        );
      },
      success: (data) {
        if (data == null || data.isEmpty) {
          return UIs.placeholder;
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 7),
          itemCount: data.length,
          itemBuilder: (_, index) {
            final chat = data[index];
            final len = '${chat.items.length} ${l10n.message}';
            final time = chat.items.lastOrNull?.createdAt.ymdhms();
            return ListTile(
              title: Text(chat.name ?? l10n.untitled),
              subtitle: time == null
                  ? Text(len, style: UIs.textGrey)
                  : Text(
                      '$len · $time',
                      style: UIs.textGrey,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
              onTap: () {
                context.pop();
                _gotoHistory(chat.id);
                _switchChat(chat.id);
                if (_curPage.value != HomePageEnum.chat) {
                  _switchPage(HomePageEnum.chat);
                }
              },
            ).cardx;
          },
        );
      },
    );
  }
}
