import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/categories_data.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../providers/app_settings_provider.dart';
import '../../news/views/category_news_view.dart';
import '../../news/views/search_news_view.dart';
import '../widgets/primary_container.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder:
              (context) => IconButton(
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                onPressed: Scaffold.of(context).openDrawer,
                icon: const Icon(Icons.menu),
              ),
        ),
        centerTitle: true,
        title: Text(l10n.home, style: AppTextStyles.s20w500),
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
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Text(
            l10n.goodMorning,
            style: AppTextStyles.s24w700.copyWith(color: colors.onSurface),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.newsForYou,
            style: AppTextStyles.s16w700.copyWith(
              color: colors.onSurface.withValues(alpha: 0.62),
            ),
          ),
          const SizedBox(height: 18),
          InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap:
                () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder:
                        (_) =>
                            const CategoryNewsView(category: Category.general),
                  ),
                ),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Icon(Icons.public, color: colors.onPrimary, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.uaeNews,
                          style: AppTextStyles.s16w700.copyWith(
                            color: colors.onPrimary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          l10n.browseUaeNews,
                          style: AppTextStyles.s12w500.copyWith(
                            color: colors.onPrimary.withValues(alpha: 0.75),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: colors.onPrimary,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ...categories.map(
            (category) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: PrimaryContainer(
                categoryModel: category,
                onPressed:
                    () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder:
                            (_) =>
                                CategoryNewsView(category: category.category),
                      ),
                    ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.newsDisclaimer,
            textAlign: TextAlign.center,
            style: AppTextStyles.s12w500.copyWith(
              color: colors.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: colors.primary,
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                height: 145,
                color: colors.onPrimary,
                child: Center(
                  child: Text(
                    l10n.newsApp,
                    style: AppTextStyles.s24w700.copyWith(
                      color: colors.primary,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home_outlined, color: colors.onPrimary),
                title: Text(
                  l10n.goToHome,
                  style: TextStyle(color: colors.onPrimary),
                ),
                onTap: () => Navigator.of(context).pop(),
              ),
              Divider(color: colors.onPrimary.withValues(alpha: 0.4)),
              ListTile(
                leading: SvgPicture.asset(
                  'assets/icons/theme_icon.svg',
                  colorFilter: ColorFilter.mode(
                    colors.onPrimary,
                    BlendMode.srcIn,
                  ),
                ),
                title: Text(
                  l10n.theme,
                  style: TextStyle(color: colors.onPrimary),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Consumer<AppSettingsProvider>(
                  builder: (context, settings, child) {
                    return DropdownButtonFormField<String>(
                      borderRadius: BorderRadius.circular(16),
                      dropdownColor: colors.primary,
                      value: settings.isDark ? 'dark' : 'light',
                      style: TextStyle(color: colors.onPrimary),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: colors.onPrimary),
                        ),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'light',
                          child: Text(l10n.light),
                        ),
                        DropdownMenuItem(value: 'dark', child: Text(l10n.dark)),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          settings.changeTheme(value == 'dark');
                        }
                      },
                    );
                  },
                ),
              ),
              Divider(color: colors.onPrimary.withValues(alpha: 0.4)),
              ListTile(
                leading: Icon(Icons.language_outlined, color: colors.onPrimary),
                title: Text(
                  l10n.language,
                  style: TextStyle(color: colors.onPrimary),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Consumer<AppSettingsProvider>(
                  builder: (context, settings, child) {
                    return DropdownButtonFormField<String>(
                      borderRadius: BorderRadius.circular(16),
                      dropdownColor: colors.primary,
                      value: settings.selectedLanguage,
                      style: TextStyle(color: colors.onPrimary),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: colors.onPrimary),
                        ),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'English',
                          child: Text(l10n.english),
                        ),
                        DropdownMenuItem(
                          value: 'Arabic',
                          child: Text(l10n.arabic),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) settings.changeLanguage(value);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
