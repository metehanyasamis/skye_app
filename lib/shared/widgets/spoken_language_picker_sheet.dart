import 'package:flutter/material.dart';
import 'package:skye_app/shared/data/spoken_languages_data.dart';
import 'package:skye_app/shared/models/language_model.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/debug_logger.dart';

const _sheetTextStyle = TextStyle(fontSize: 14, color: AppColors.grayPrimary);
const _sheetSubtitleStyle = TextStyle(fontSize: 12, color: AppColors.grayDark);

/// Multi-select spoken language bottom sheet – Clear/Apply, search.
/// Returns List<LanguageModel> on Apply, null on Cancel.
Future<List<LanguageModel>?> showSpokenLanguagePickerSheet(
  BuildContext context, {
  List<LanguageModel> initialSelected = const [],
}) async {
  return await showModalBottomSheet<List<LanguageModel>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _SpokenLanguagePickerSheet(
      initialSelected: List.from(initialSelected),
    ),
  );
}

class _SpokenLanguagePickerSheet extends StatefulWidget {
  const _SpokenLanguagePickerSheet({required this.initialSelected});

  final List<LanguageModel> initialSelected;

  @override
  State<_SpokenLanguagePickerSheet> createState() =>
      _SpokenLanguagePickerSheetState();
}

class _SpokenLanguagePickerSheetState extends State<_SpokenLanguagePickerSheet> {
  late List<LanguageModel> _pending;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    DebugLogger.log('SpokenLanguagePickerSheet', 'initState()');
    _pending = List.from(widget.initialSelected);
  }

  @override
  void dispose() {
    DebugLogger.log('SpokenLanguagePickerSheet', 'dispose()');
    _searchController.dispose();
    super.dispose();
  }

  void _toggle(LanguageModel lang) {
    setState(() {
      if (_pending.any((l) => l.code == lang.code)) {
        _pending.removeWhere((l) => l.code == lang.code);
        DebugLogger.log('SpokenLanguagePickerSheet', 'onTap unselect', {'code': lang.code});
      } else {
        _pending.add(lang);
        DebugLogger.log('SpokenLanguagePickerSheet', 'onTap select', {'code': lang.code});
      }
    });
  }

  bool _isSelected(LanguageModel lang) =>
      _pending.any((l) => l.code == lang.code);

  Widget _buildFrame(Widget child) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: AppColors.borderLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Text(
                'Select Languages',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.labelBlack,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search by name or code',
                  hintStyle: _sheetSubtitleStyle,
                  filled: true,
                  fillColor: AppColors.white,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.grayPrimary,
                    size: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.borderLight),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                style: _sheetTextStyle,
              ),
            ),
            const SizedBox(height: 12),
            Flexible(child: child),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        DebugLogger.log(
                          'SpokenLanguagePickerSheet',
                          'Clear tapped',
                        );
                        setState(() => _pending = []);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.labelBlack,
                        side: const BorderSide(color: AppColors.borderLight),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Clear'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        DebugLogger.log(
                          'SpokenLanguagePickerSheet',
                          'Apply tapped',
                          {'count': _pending.length},
                        );
                        Navigator.of(context).pop(_pending);
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.navy800,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Apply'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DebugLogger.log('SpokenLanguagePickerSheet', 'build()');
    final q = _searchController.text.toLowerCase().trim();
    final filtered = q.isEmpty
        ? spokenLanguagesList
        : spokenLanguagesList
            .where(
              (l) =>
                  l.name.toLowerCase().contains(q) ||
                  l.code.toLowerCase().contains(q),
            )
            .toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return _buildFrame(
          ListView.builder(
            controller: scrollController,
            shrinkWrap: true,
            itemCount: filtered.length,
            itemBuilder: (context, i) {
              final lang = filtered[i];
              final isSelected = _isSelected(lang);
              return InkWell(
                onTap: () => _toggle(lang),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.navy800.withValues(alpha: 0.08)
                        : null,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppColors.navy800 : AppColors.borderLight,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(lang.name, style: _sheetTextStyle),
                            Text(lang.code, style: _sheetSubtitleStyle),
                          ],
                        ),
                      ),
                      if (isSelected)
                        const Icon(
                          Icons.check_circle,
                          color: AppColors.navy800,
                          size: 22,
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
