import 'package:flutter/material.dart';
import 'package:skye_app/shared/theme/app_colors.dart';

/// Filter bottom sheets for aircraft listing. Stay on same screen; no navigation.

// Placeholder until GET /aircraft-types exists.
const _aircraftTypes = [
  (id: 1, name: 'C172'),
  (id: 2, name: 'PA-28'),
  (id: 3, name: 'DA-40'),
  (id: 4, name: 'C152'),
  (id: 5, name: 'SR20'),
  (id: 6, name: 'SR22'),
];

const _sheetTitleStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w700,
  color: AppColors.labelBlack,
);

const _sheetPadding = EdgeInsets.symmetric(horizontal: 24, vertical: 20);

Widget _sheetFrame({
  required String title,
  required Widget child,
  required VoidCallback onApply,
  VoidCallback? onClear,
}) {
  return Container(
    decoration: const BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    child: SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
            padding: _sheetPadding.copyWith(bottom: 16),
            child: Text(title, style: _sheetTitleStyle),
          ),
          Flexible(child: SingleChildScrollView(child: child)),
          Padding(
            padding: _sheetPadding,
            child: Row(
              children: [
                if (onClear != null)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onClear,
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
                if (onClear != null) const SizedBox(width: 12),
                Expanded(
                  flex: onClear != null ? 1 : 1,
                  child: FilledButton(
                    onPressed: onApply,
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

/// Rent/Buy: All, Rental, Sale
void showRentBuySheet(
  BuildContext context, {
  required String? currentType,
  required void Function(String? type) onApply,
}) {
  String? selected = currentType;

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setModal) {
        return DraggableScrollableSheet(
          initialChildSize: 0.36,
          minChildSize: 0.2,
          maxChildSize: 0.5,
          expand: false,
          builder: (_, scroll) => _sheetFrame(
            title: 'Rent / Buy',
            onApply: () {
              Navigator.of(ctx).pop();
              onApply(selected);
            },
            onClear: () {
              selected = null;
              setModal(() {});
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _choiceTile(ctx, setModal, 'All', null, selected, (v) => selected = v),
                  _choiceTile(ctx, setModal, 'Rental', 'rental', selected, (v) => selected = v),
                  _choiceTile(ctx, setModal, 'Sale', 'sale', selected, (v) => selected = v),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}

Widget _choiceTile(
  BuildContext context,
  void Function(void Function()) setModal,
  String label,
  String? value,
  String? selected,
  void Function(String?) onSelect,
) {
  final isSelected = selected == value;
  return InkWell(
    onTap: () => setModal(() => onSelect(value)),
    borderRadius: BorderRadius.circular(12),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.navy800.withValues(alpha: 0.08) : null,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.navy800 : AppColors.borderLight,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 16, color: AppColors.labelBlack))),
          if (isSelected) const Icon(Icons.check_circle, color: AppColors.navy800, size: 22),
        ],
      ),
    ),
  );
}

/// Aircraft Type: list (placeholder ids)
void showAircraftTypeSheet(
  BuildContext context, {
  required int? currentId,
  required void Function(int?) onApply,
}) {
  int? selected = currentId;

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setModal) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.2,
          maxChildSize: 0.7,
          expand: false,
          builder: (_, scroll) => _sheetFrame(
            title: 'Aircraft Type',
            onApply: () {
              Navigator.of(ctx).pop();
              onApply(selected);
            },
            onClear: () {
              selected = null;
              setModal(() {});
            },
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: _aircraftTypes.length,
              itemBuilder: (_, i) {
                final t = _aircraftTypes[i];
                final isSelected = selected == t.id;
                return InkWell(
                  onTap: () => setModal(() => selected = isSelected ? null : t.id),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.navy800.withValues(alpha: 0.08) : null,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? AppColors.navy800 : AppColors.borderLight,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(child: Text(t.name, style: const TextStyle(fontSize: 16, color: AppColors.labelBlack))),
                        if (isSelected) const Icon(Icons.check_circle, color: AppColors.navy800, size: 22),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    ),
  );
}

void _showLocationFieldSheet(
  BuildContext context, {
  required String title,
  required String hint,
  required String? currentValue,
  required void Function(String?) onApply,
}) {
  final controller = TextEditingController(text: currentValue ?? '');

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => DraggableScrollableSheet(
      initialChildSize: 0.36,
      minChildSize: 0.2,
      maxChildSize: 0.5,
      expand: false,
      builder: (_, __) => _sheetFrame(
        title: title,
        onApply: () {
          Navigator.of(ctx).pop();
          final v = controller.text.trim();
          onApply(v.isEmpty ? null : v);
        },
        onClear: () => controller.clear(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.6)),
              filled: true,
              fillColor: AppColors.cfiBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            style: const TextStyle(fontSize: 16, color: AppColors.labelBlack),
            textInputAction: TextInputAction.done,
          ),
        ),
      ),
    ),
  );
}

void showStateSheet(
  BuildContext context, {
  required String? currentValue,
  required void Function(String?) onApply,
}) {
  _showLocationFieldSheet(
    context,
    title: 'State',
    hint: 'e.g. California, Texas',
    currentValue: currentValue,
    onApply: onApply,
  );
}

void showCitySheet(
  BuildContext context, {
  required String? currentValue,
  required void Function(String?) onApply,
}) {
  _showLocationFieldSheet(
    context,
    title: 'City',
    hint: 'e.g. Istanbul, Miami',
    currentValue: currentValue,
    onApply: onApply,
  );
}

void showAirportSheet(
  BuildContext context, {
  required String? currentValue,
  required void Function(String?) onApply,
}) {
  _showLocationFieldSheet(
    context,
    title: 'Airport',
    hint: 'e.g. KBNA, LTFM',
    currentValue: currentValue,
    onApply: onApply,
  );
}

/// Price: min / max + sort arrow (↑ ucuzdan pahalıya, ↓ pahalıdan ucuza)
void showPriceSheet(
  BuildContext context, {
  required double? minPrice,
  required double? maxPrice,
  required String? currentSort,
  required void Function(double? min, double? max, String? sort) onApply,
}) {
  final minCtrl = TextEditingController(text: minPrice != null ? minPrice.toInt().toString() : '');
  final maxCtrl = TextEditingController(text: maxPrice != null ? maxPrice.toInt().toString() : '');
  // ↑ price_asc (ucuzdan pahalıya), ↓ price_desc (pahalıdan ucuza). Tıklayınca toggle.
  String sort = currentSort == 'price_desc' ? 'price_desc' : 'price_asc';

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setModal) {
        return DraggableScrollableSheet(
          initialChildSize: 0.4,
          minChildSize: 0.2,
          maxChildSize: 0.55,
          expand: false,
          builder: (_, __) => _sheetFrame(
            title: 'Price Range',
            onApply: () {
              Navigator.of(ctx).pop();
              final min = double.tryParse(minCtrl.text.trim());
              final max = double.tryParse(maxCtrl.text.trim());
              onApply(min, max, sort);
            },
            onClear: () {
              minCtrl.clear();
              maxCtrl.clear();
              setModal(() {});
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: minCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Min (\$)',
                        filled: true,
                        fillColor: AppColors.cfiBackground,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                      style: const TextStyle(fontSize: 16, color: AppColors.labelBlack),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: maxCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Max (\$)',
                        filled: true,
                        fillColor: AppColors.cfiBackground,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                      style: const TextStyle(fontSize: 16, color: AppColors.labelBlack),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => setModal(() {
                        sort = sort == 'price_desc' ? 'price_asc' : 'price_desc';
                      }),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.cfiBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          sort == 'price_desc' ? Icons.arrow_downward : Icons.arrow_upward,
                          size: 24,
                          color: AppColors.navy800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}
