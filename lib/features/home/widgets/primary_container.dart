import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/categories_data.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../models/category_model.dart';

class PrimaryContainer extends StatelessWidget {
  final CategoryModel categoryModel;
  final VoidCallback onPressed;

  const PrimaryContainer({
    super.key,
    required this.categoryModel,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final l10n = AppLocalizations.of(context)!;
    final categoryName = _localizedCategoryName(categoryModel.category, l10n);

    return Container(
      width: double.infinity,
      height: size.height * 0.18,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(
            context,
          ).colorScheme.onSurface.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        textDirection:
            categoryModel.isEven ? TextDirection.ltr : TextDirection.rtl,
        children: [
          Expanded(
            flex: 4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(categoryModel.image, fit: BoxFit.cover),
            ),
          ),
          Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  categoryName,
                  style: AppTextStyles.s20w700.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    width: double.infinity,
                    height: 42,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 9),
                            child: Text(
                              l10n.viewAll,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.s14w500.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
                        CircleAvatar(
                          radius: 20,
                          backgroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          child: IconButton(
                            onPressed: onPressed,
                            icon: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 15,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _localizedCategoryName(Category category, AppLocalizations l10n) {
    switch (category) {
      case Category.general:
        return l10n.general;
      case Category.business:
        return l10n.business;
      case Category.sports:
        return l10n.sports;
      case Category.technology:
        return l10n.technology;
      case Category.health:
        return l10n.health;
      case Category.science:
        return l10n.science;
      case Category.entertainment:
        return l10n.entertainment;
    }
  }
}
