import 'package:flutter/material.dart';

import '../../../data/models/categories_data.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/news_service.dart';
import '../models/article.dart';
import '../widgets/article_card.dart';
import 'news_detail_view.dart';
import 'search_news_view.dart';

class CategoryNewsView extends StatefulWidget {
  const CategoryNewsView({super.key, required this.category});

  final Category category;

  @override
  State<CategoryNewsView> createState() => _CategoryNewsViewState();
}

class _CategoryNewsViewState extends State<CategoryNewsView> {
  final NewsService _newsService = NewsService();
  late Future<List<Article>> _articlesFuture;
  String? _selectedSource;
  bool _didLoadArticles = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didLoadArticles) {
      _articlesFuture = _loadArticles();
      _didLoadArticles = true;
    }
  }

  Future<List<Article>> _loadArticles() {
    return _newsService.fetchCategory(
      widget.category,
      arabic: Localizations.localeOf(context).languageCode == 'ar',
    );
  }

  @override
  void dispose() {
    _newsService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title = _categoryName(widget.category, l10n);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            tooltip: l10n.searchNews,
            onPressed:
                () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const SearchNewsView(),
                  ),
                ),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: FutureBuilder<List<Article>>(
        future: _articlesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return _MessageView(
              icon: Icons.cloud_off_outlined,
              title: l10n.unableToLoadNews,
              details: snapshot.error.toString(),
              actionLabel: l10n.tryAgain,
              onAction:
                  () => setState(() {
                    _selectedSource = null;
                    _articlesFuture = _loadArticles();
                  }),
            );
          }

          final articles = snapshot.data ?? const <Article>[];
          if (articles.isEmpty) {
            return _MessageView(
              icon: Icons.newspaper_outlined,
              title: l10n.noNews,
              actionLabel: l10n.tryAgain,
              onAction: () => setState(() => _articlesFuture = _loadArticles()),
            );
          }

          final sources =
              articles
                  .map((article) => article.source)
                  .whereType<String>()
                  .toSet()
                  .toList();
          final visibleArticles =
              _selectedSource == null
                  ? articles
                  : articles
                      .where((article) => article.source == _selectedSource)
                      .toList();

          return RefreshIndicator(
            onRefresh: () async {
              final future = _loadArticles();
              setState(() => _articlesFuture = future);
              await future;
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 56,
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      children: [
                        _SourceChip(
                          label: l10n.latestNews,
                          selected: _selectedSource == null,
                          onTap: () => setState(() => _selectedSource = null),
                        ),
                        for (final source in sources)
                          _SourceChip(
                            label: source,
                            selected: _selectedSource == source,
                            onTap:
                                () => setState(() => _selectedSource = source),
                          ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  sliver: SliverList.separated(
                    itemCount: visibleArticles.length,
                    itemBuilder: (context, index) {
                      final article = visibleArticles[index];
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _categoryName(Category category, AppLocalizations l10n) {
    return switch (category) {
      Category.general => l10n.general,
      Category.business => l10n.business,
      Category.sports => l10n.sports,
      Category.technology => l10n.technology,
      Category.health => l10n.health,
      Category.science => l10n.science,
      Category.entertainment => l10n.entertainment,
    };
  }
}

class _SourceChip extends StatelessWidget {
  const _SourceChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 8),
      child: Center(
        child: ChoiceChip(
          label: Text(label),
          selected: selected,
          onSelected: (_) => onTap(),
        ),
      ),
    );
  }
}

class _MessageView extends StatelessWidget {
  const _MessageView({
    required this.icon,
    required this.title,
    this.details,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String? details;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 44, color: colors.onSurfaceVariant),
            const SizedBox(height: 12),
            Text(title, textAlign: TextAlign.center),
            if (details != null) ...[
              const SizedBox(height: 8),
              Text(
                details!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
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
