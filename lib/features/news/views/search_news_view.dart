import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../data/news_service.dart';
import '../models/article.dart';
import '../widgets/article_card.dart';
import 'news_detail_view.dart';

class SearchNewsView extends StatefulWidget {
  const SearchNewsView({super.key});

  @override
  State<SearchNewsView> createState() => _SearchNewsViewState();
}

class _SearchNewsViewState extends State<SearchNewsView> {
  final _controller = TextEditingController();
  final _newsService = NewsService();
  Future<List<Article>>? _articlesFuture;

  @override
  void dispose() {
    _controller.dispose();
    _newsService.close();
    super.dispose();
  }

  void _search() {
    final query = _controller.text.trim();
    if (query.isEmpty) return;
    final arabic = Localizations.localeOf(context).languageCode == 'ar';
    setState(() {
      _articlesFuture = _newsService.getNews(query, arabic: arabic);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsetsDirectional.only(end: 12),
          child: TextField(
            controller: _controller,
            autofocus: true,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _search(),
            decoration: InputDecoration(
              hintText: l10n.searchHint,
              border: InputBorder.none,
              suffixIcon: IconButton(
                tooltip: l10n.clearSearch,
                onPressed: () {
                  _controller.clear();
                  setState(() => _articlesFuture = null);
                },
                icon: const Icon(Icons.close),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            tooltip: l10n.searchNews,
            onPressed: _search,
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body:
          _articlesFuture == null
              ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.search,
                        size: 48,
                        color: colors.onSurfaceVariant,
                      ),
                      const SizedBox(height: 12),
                      Text(l10n.searchHint, textAlign: TextAlign.center),
                    ],
                  ),
                ),
              )
              : FutureBuilder<List<Article>>(
                future: _articlesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return _SearchMessage(
                      message: '${l10n.unableToLoadNews}\n${snapshot.error}',
                      actionLabel: l10n.tryAgain,
                      onAction: _search,
                    );
                  }

                  final articles = snapshot.data ?? const <Article>[];
                  if (articles.isEmpty) {
                    return _SearchMessage(message: l10n.noSearchResults);
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      _search();
                      await _articlesFuture;
                    },
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      itemCount: articles.length,
                      itemBuilder: (context, index) {
                        final article = articles[index];
                        return ArticleCard(
                          article: article,
                          onTap:
                              () => Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder:
                                      (_) => NewsDetailView(article: article),
                                ),
                              ),
                        );
                      },
                      separatorBuilder: (_, _) => const SizedBox(height: 14),
                    ),
                  );
                },
              ),
    );
  }
}

class _SearchMessage extends StatelessWidget {
  const _SearchMessage({
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 12),
              OutlinedButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
