import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../models/article.dart';

class NewsDetailView extends StatelessWidget {
  const NewsDetailView({super.key, required this.article});

  final Article article;

  Future<void> _openArticle(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final uri = Uri.tryParse(article.url);
    if (uri == null ||
        (uri.scheme != 'https' && uri.scheme != 'http') ||
        uri.host.isEmpty) {
      _showOpenError(context, l10n);
      return;
    }

    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!opened && context.mounted) _showOpenError(context, l10n);
    } on PlatformException {
      if (context.mounted) _showOpenError(context, l10n);
    }
  }

  void _showOpenError(BuildContext context, AppLocalizations l10n) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.openArticleError)));
  }

  Future<void> _shareToFacebook(BuildContext context) async {
    final uri = Uri.parse(
      'https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(article.url)}',
    );
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) _showOpenError(context, AppLocalizations.of(context)!);
    }
  }

  Future<void> _shareToTwitter(BuildContext context) async {
    final uri = Uri.parse(
      'https://x.com/intent/tweet?url=${Uri.encodeComponent(article.url)}&text=${Uri.encodeComponent(article.title)}',
    );
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) _showOpenError(context, AppLocalizations.of(context)!);
    }
  }

  Future<void> _copyLink(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: article.url));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Link copied to clipboard'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context).toLanguageTag();

    return Scaffold(
      appBar: AppBar(
        title: Text(article.source ?? l10n.newsApp),
        actions: [
          IconButton(
            tooltip: l10n.readFullArticle,
            onPressed: () => _openArticle(context),
            icon: const Icon(Icons.open_in_new),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          children: [
            if (article.source != null)
              Text(
                article.source!.toUpperCase(),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                ),
              ),
            const SizedBox(height: 12),
            Text(
              article.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                height: 1.22,
              ),
            ),
            const SizedBox(height: 12),
            if (article.author != null || article.publishedAt != null)
              Text(
                [
                  if (article.author != null) article.author!,
                  if (article.publishedAt != null)
                    DateFormat.yMMMd(
                      locale,
                    ).add_jm().format(article.publishedAt!),
                ].join(' · '),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
              ),
            const SizedBox(height: 14),
            Row(
              children: [
                _SocialIconButton(
                  icon: Icons.facebook,
                  color: const Color(0xFF1877F2),
                  tooltip: 'Share on Facebook',
                  onTap: () => _shareToFacebook(context),
                ),
                const SizedBox(width: 10),
                _SocialIconButton(
                  label: 'X',
                  color: Colors.black,
                  tooltip: 'Share on X (Twitter)',
                  onTap: () => _shareToTwitter(context),
                ),
                const SizedBox(width: 10),
                _SocialIconButton(
                  icon: Icons.link_rounded,
                  color: colors.onSurfaceVariant,
                  tooltip: 'Copy link',
                  onTap: () => _copyLink(context),
                ),
                const SizedBox(width: 10),
                _SocialIconButton(
                  icon: Icons.ios_share_rounded,
                  color: colors.onSurfaceVariant,
                  tooltip: 'Open article',
                  onTap: () => _openArticle(context),
                ),
              ],
            ),
            if (article.imageUrl != null) ...[
              const SizedBox(height: 18),
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: AspectRatio(
                  aspectRatio: 16 / 10,
                  child: Image.network(
                    article.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => ColoredBox(
                          color: colors.surfaceContainerHighest,
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                  ),
                ),
              ),
            ],
            if (article.summary != null) ...[
              const SizedBox(height: 20),
              Text(
                article.summary!,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),
            ],
            if (article.content != null &&
                article.content != article.summary) ...[
              const SizedBox(height: 16),
              Text(
                article.content!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.7,
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => _openArticle(context),
              icon: const Icon(Icons.open_in_new),
              label: Text(l10n.readFullArticle),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.newsDisclaimer,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialIconButton extends StatelessWidget {
  const _SocialIconButton({
    this.icon,
    this.label,
    required this.color,
    required this.tooltip,
    required this.onTap,
  }) : assert(icon != null || label != null, 'Provide icon or label');

  final IconData? icon;
  final String? label;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: icon != null
                ? Icon(icon, color: Colors.white, size: 20)
                : Text(
                    label!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
