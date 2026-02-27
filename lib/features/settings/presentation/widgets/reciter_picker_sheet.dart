import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_with_tafsir/quran_with_tafsir.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/settings_cubit.dart';
import 'reciter_tile.dart';
import 'sheet_handle.dart';

class ReciterPickerSheet extends StatefulWidget {
  final String current;
  final bool isAr;
  final bool isDark;

  const ReciterPickerSheet({
    super.key,
    required this.current,
    required this.isAr,
    required this.isDark,
  });

  @override
  State<ReciterPickerSheet> createState() => _ReciterPickerSheetState();
}

class _ReciterPickerSheetState extends State<ReciterPickerSheet> {
  String _query = '';
  late final TextEditingController _searchCtrl;

  @override
  void initState() {
    super.initState();
    _searchCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final allReciters = widget.isAr
        ? Reciters.displayNamesAr
        : Reciters.displayNames;

    final filtered = _query.isEmpty
        ? allReciters.entries.toList()
        : allReciters.entries
            .where((e) =>
                e.value.toLowerCase().contains(_query.toLowerCase()) ||
                e.key.toLowerCase().contains(_query.toLowerCase()))
            .toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (ctx, controller) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SheetHandle(isDark: widget.isDark),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.teal.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.record_voice_over_rounded,
                        color: AppColors.teal,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      l10n.translate('chooseReciter'),
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color:
                            widget.isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      l10n.translate('recitersCount', [allReciters.length]),
                      style: TextStyle(
                        fontSize: 12,
                        color: widget.isDark
                            ? Colors.white38
                            : Colors.black38,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => setState(() => _query = v),
                  style: TextStyle(
                    color: widget.isDark ? Colors.white : Colors.black87,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: l10n.translate('searchReciters'),
                    hintStyle: TextStyle(
                      color: widget.isDark
                          ? Colors.white38
                          : Colors.black38,
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: AppColors.teal,
                      size: 20,
                    ),
                    suffixIcon: _query.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.close_rounded,
                              size: 18,
                              color: widget.isDark
                                  ? Colors.white38
                                  : Colors.black38,
                            ),
                            onPressed: () {
                              _searchCtrl.clear();
                              setState(() => _query = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: widget.isDark
                        ? Colors.white.withOpacity(0.07)
                        : Colors.grey.withOpacity(0.08),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text(
                      l10n.translate('noRecitersFound'),
                      style: TextStyle(
                        color: widget.isDark
                            ? Colors.white38
                            : Colors.black38,
                      ),
                    ),
                  )
                : ListView.separated(
                    controller: controller,
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    itemCount: filtered.length,
                    separatorBuilder: (_, index) => Divider(
                      height: 1,
                      color: widget.isDark
                          ? Colors.white.withOpacity(0.05)
                          : Colors.grey.withOpacity(0.1),
                    ),
                    itemBuilder: (_, i) {
                      final entry = filtered[i];
                      final isSelected = entry.key == widget.current;
                      final enName =
                          widget.isAr ? Reciters.displayNames[entry.key] : null;
                      return ReciterTile(
                        id: entry.key,
                        displayName: entry.value,
                        subName: enName,
                        isSelected: isSelected,
                        isDark: widget.isDark,
                        onTap: () {
                          context
                              .read<SettingsCubit>()
                              .setSelectedReciter(entry.key);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
