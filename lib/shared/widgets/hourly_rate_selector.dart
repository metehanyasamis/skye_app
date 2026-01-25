import 'package:flutter/material.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/debug_logger.dart';

/// Reusable hourly rate selector widget
/// Allows selection of hourly rate (8-24 range)
/// Uses circular chips design with dynamic font sizes
class HourlyRateSelector extends StatelessWidget {
  const HourlyRateSelector({
    super.key,
    required this.selectedRate,
    required this.onRateSelected,
  });

  final int selectedRate;
  final ValueChanged<int> onRateSelected;

  double _getFontSize(int rate) {
    if (rate < 9) return 8;
    if (rate == 9) return 10;
    if (rate == 10) return 14;
    if (rate >= 11 && rate <= 13) return 16;
    if (rate == 14) return 14;
    if (rate == 15) return 10;
    return 8;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 17, // 8 to 24
        itemBuilder: (context, index) {
          final rate = 8 + index;
          final isSelected = rate == selectedRate;

          return GestureDetector(
            onTap: () {
              DebugLogger.log('HourlyRateSelector', 'rate tapped', {'rate': rate});
              onRateSelected(rate);
            },
            child: Container(
              width: 44,
              height: 44,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.white : Colors.transparent,
                border: isSelected
                    ? Border.all(color: AppColors.labelBlack, width: 1)
                    : null,
              ),
              child: Center(
                child: Text(
                  rate < 10 ? rate.toString() : rate.toString().padLeft(2, '0'),
                  style: TextStyle(
                    fontSize: _getFontSize(rate),
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                    color: isSelected ? AppColors.labelBlack : AppColors.textGray,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
