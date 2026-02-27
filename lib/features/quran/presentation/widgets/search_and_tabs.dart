import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import 'tab_pill.dart';

class SearchAndTabs extends StatelessWidget {
  const SearchAndTabs({
    super.key,
    required this.tabController,
    required this.activeTab,
    required this.searchController,
    required this.searchQuery,
    required this.l10n,
    required this.onSearch,
    required this.onTabTap,
  });

  final TabController tabController;
  final int activeTab;
  final TextEditingController searchController;
  final String searchQuery;
  final AppLocalizations l10n;
  final ValueChanged<String> onSearch;
  final ValueChanged<int> onTabTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkCard : Colors.white;
    final borderColor =
        isDark ? AppColors.darkBackground : AppColors.greyLight;

    return Container(
      color: cardBg,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 38,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    TabPill(
                      label: l10n.translate('surah'),
                      active: activeTab == 0,
                      onTap: () => onTabTap(0),
                    ),
                    TabPill(
                      label: l10n.translate('juz'),
                      active: activeTab == 1,
                      onTap: () => onTabTap(1),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Container(
                  height: 38,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: searchController,
                    onChanged: onSearch,
                    style: TextStyle(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      fontSize: 13,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      hintText: activeTab == 0
                          ? l10n.translate('searchSurahs')
                          : l10n.translate('searchJuz'),
                      hintStyle: TextStyle(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.grey,
                        fontSize: 13,
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        size: 18,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.grey,
                      ),
                      suffixIcon: searchQuery.isNotEmpty
                          ? GestureDetector(
                              onTap: () => onSearch(''),
                              child: Icon(Icons.close_rounded,
                                  size: 16,
                                  color: isDark ? AppColors.textSecondaryDark : AppColors.grey),
                            )
                          : null,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(height: 1, color: borderColor),
        ],
      ),
    );
  }
}
