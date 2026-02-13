import 'package:flutter/material.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/debug_logger.dart';

/// Bottom sheet to choose address source: Use current location or Pick on map.
Future<String?> showAddressSelectionSheet(
  BuildContext context, {
  VoidCallback? onUseMyLocation,
}) async {
  DebugLogger.log('AddressSelectionSheet', 'show()');
  return await showModalBottomSheet<String>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: AppColors.borderLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Text(
                'Select Address',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.labelBlack,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.my_location, color: AppColors.navy800),
                title: const Text(
                  'Use my location',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.labelBlack,
                  ),
                ),
                subtitle: const Text(
                  'Use your current GPS position',
                  style: TextStyle(fontSize: 12, color: AppColors.grayDark),
                ),
                onTap: () {
                  DebugLogger.log('AddressSelectionSheet', 'Use my location tapped');
                  Navigator.of(context).pop();
                  onUseMyLocation?.call();
                },
              ),
              ListTile(
                leading: const Icon(Icons.map_outlined, color: AppColors.navy800),
                title: const Text(
                  'Pick on map',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.labelBlack,
                  ),
                ),
                subtitle: const Text(
                  'Select a location on the map',
                  style: TextStyle(fontSize: 12, color: AppColors.grayDark),
                ),
                onTap: () {
                  DebugLogger.log('AddressSelectionSheet', 'Pick on map tapped');
                  Navigator.of(context).pop('pick_on_map');
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    ),
  );
}
