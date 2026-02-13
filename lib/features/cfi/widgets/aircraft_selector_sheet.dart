import 'package:flutter/material.dart';
import 'package:skye_app/shared/theme/app_colors.dart';

/// Aircraft model for selector
class AircraftItem {
  final String name;
  final String code;

  const AircraftItem({required this.name, required this.code});
}

// Placeholder - TODO: load from backend
const _placeholderAircraft = [
  AircraftItem(name: 'Cessna 172 Skyhawk', code: 'C172'),
  AircraftItem(name: 'Cessna 152', code: 'C152'),
  AircraftItem(name: 'Piper PA-28 Cherokee', code: 'PA28'),
  AircraftItem(name: 'Piper PA-28 Arrow', code: 'PA28R'),
  AircraftItem(name: 'Diamond DA-40', code: 'DA40'),
  AircraftItem(name: 'Diamond DA-42', code: 'DA42'),
  AircraftItem(name: 'Cirrus SR20', code: 'SR20'),
  AircraftItem(name: 'Cirrus SR22', code: 'SR22'),
  AircraftItem(name: 'Beechcraft Bonanza', code: 'B36'),
  AircraftItem(name: 'Beechcraft Baron', code: 'B58'),
  AircraftItem(name: 'Mooney M20', code: 'M20'),
  AircraftItem(name: 'Robinson R22', code: 'R22'),
  AircraftItem(name: 'Robinson R44', code: 'R44'),
  AircraftItem(name: 'Cessna 206', code: 'C206'),
  AircraftItem(name: 'Cessna 182 Skylane', code: 'C182'),
];

/// Bottom sheet for selecting aircraft (name + code)
/// Search by name or code
/// excludeAircraft: already selected aircraft to filter out (avoid duplicates)
Future<AircraftItem?> showAircraftSelectorSheet(
  BuildContext context, {
  List<AircraftItem> excludeAircraft = const [],
}) async {
  return showModalBottomSheet<AircraftItem>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _AircraftSelectorSheet(
      excludeAircraft: excludeAircraft,
    ),
  );
}

class _AircraftSelectorSheet extends StatefulWidget {
  final List<AircraftItem> excludeAircraft;

  const _AircraftSelectorSheet({this.excludeAircraft = const []});

  @override
  State<_AircraftSelectorSheet> createState() => _AircraftSelectorSheetState();
}

class _AircraftSelectorSheetState extends State<_AircraftSelectorSheet> {
  final _searchController = TextEditingController();
  late List<AircraftItem> _filtered;

  List<AircraftItem> _getAvailableAircraft() {
    final excluded = widget.excludeAircraft.map((e) => '${e.name}|${e.code}').toSet();
    return _placeholderAircraft
        .where((a) => !excluded.contains('${a.name}|${a.code}'))
        .toList();
  }

  void _applyFilter() {
    final query = _searchController.text.trim().toLowerCase();
    final available = _getAvailableAircraft();
    if (query.isEmpty) {
      setState(() => _filtered = List<AircraftItem>.from(available));
      return;
    }
    setState(() {
      _filtered = List<AircraftItem>.from(
        available.where((a) =>
            a.name.toLowerCase().contains(query) ||
            a.code.toLowerCase().contains(query)),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _filtered = _getAvailableAircraft();
    _searchController.addListener(_applyFilter);
  }

  @override
  void didUpdateWidget(_AircraftSelectorSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.excludeAircraft != widget.excludeAircraft) {
      _applyFilter();
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_applyFilter);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, scrollController) => Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: AppColors.borderLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Select Aircraft',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.labelBlack,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Search
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by aircraft name or code',
                      hintStyle: TextStyle(
                        color: AppColors.textSecondary.withValues(alpha: 0.6),
                        fontSize: 14,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.textSecondary,
                        size: 22,
                      ),
                      filled: true,
                      fillColor: AppColors.cfiBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.labelBlack,
                    ),
                    onChanged: (_) => _applyFilter(),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            // List
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _filtered.length,
                itemBuilder: (context, index) {
                  final aircraft = _filtered[index];

                  return InkWell(
                    onTap: () => Navigator.of(context).pop(aircraft),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.borderLight,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  aircraft.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.labelBlack,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  aircraft.code,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textSecondary
                                        .withValues(alpha: 0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.add_circle_outline,
                            color: AppColors.selectedBlue,
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
