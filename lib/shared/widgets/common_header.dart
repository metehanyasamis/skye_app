import 'package:flutter/material.dart';

import 'package:skye_app/app/routes/app_routes.dart';
import 'package:skye_app/features/map/map_picker_screen.dart';
import 'package:skye_app/shared/services/location_service.dart';
import 'package:skye_app/shared/services/user_address_service.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/debug_logger.dart';
import 'package:skye_app/shared/utils/geocoding_helper.dart' as geocoding;
import 'package:skye_app/shared/widgets/address_selection_sheet.dart';
import 'package:skye_app/shared/widgets/location_permission_dialog.dart';
import 'package:skye_app/shared/widgets/skye_logo.dart';

class CommonHeader extends StatelessWidget {
  const CommonHeader({
    super.key,
    this.onNotificationTap,
    this.showNotificationDot = false,
    this.logoHeight = 58,
    this.padding,
  });

  final VoidCallback? onNotificationTap;
  final bool showNotificationDot;
  final double logoHeight;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;

    return SafeArea(
      bottom: false,
      child: Padding(
        // ✅ status bar’a yapışmayı engeller
        padding: padding ??
            EdgeInsets.fromLTRB(16, topInset > 0 ? 6 : 14, 16, 12),
        child: Row(
          children: [
            SizedBox(
              width: 70,
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.home,
                      (route) => false,
                    );
                  },
                  child: SkyeLogo(type: 'logo', color: 'blue', height: logoHeight),
                ),
              ),
            ),

            Flexible(
              child: Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () => _onLocationTap(context),
                  child: Container(
                    constraints: const BoxConstraints(
                      minHeight: 32,
                      maxWidth: 320,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ValueListenableBuilder<String>(
                      valueListenable: UserAddressService.instance.addressNotifier,
                      builder: (context, address, _) {
                        final display = truncateAddressForAppBar(address);

                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.place,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                display,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(
              width: 52,
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: onNotificationTap,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: AppColors.cardLight,
                      shape: BoxShape.circle,
                    ),
                    child: Stack(
                      children: [
                        const Center(
                          child: Icon(Icons.notifications_none, size: 24, color: AppColors.navy900),
                        ),
                        if (showNotificationDot)
                          const Positioned(
                            right: 8,
                            top: 8,
                            child: CircleAvatar(radius: 4, backgroundColor: Colors.red),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onLocationTap(BuildContext context) async {
    DebugLogger.log('CommonHeader', 'location tapped');
    final hasPermission = await LocationService.instance.hasPermission();
    if (hasPermission) {
      final choice = await showAddressSelectionSheet(
        context,
        onUseMyLocation: () async {
          final pos = await LocationService.instance.getCurrentPosition();
          if (pos == null || !context.mounted) return;
          final p = await geocoding.reverseGeocodeToPlacemark(pos.latitude, pos.longitude);
          if (p != null && context.mounted) {
            final street = p.street ?? '';
            final city = p.locality ?? '';
            final state = p.administrativeArea ?? '';
            final zip = p.postalCode ?? '';
            await UserAddressService.instance.setStructuredAddress(
              street: street,
              city: city,
              state: state,
              zip: zip,
            );
          }
        },
      );
      if (choice == 'pick_on_map' && context.mounted) {
        final address = await Navigator.of(context).push<String?>(
          MaterialPageRoute<String?>(
            builder: (ctx) => MapPickerScreen(
              savedAddress: UserAddressService.instance.address.isNotEmpty
                  ? UserAddressService.instance.address
                  : null,
            ),
          ),
        );
        if (address != null) {
          await UserAddressService.instance.setAddress(address);
        }
      }
    } else {
      LocationPermissionDialog.show(
        context,
        onGoToSettings: () async {
          Navigator.of(context).pop();
          await LocationService.instance.openAppSettings();
        },
        onNoThanks: () async {
          Navigator.of(context).pop();
          if (!context.mounted) return;
          final address = await Navigator.of(context).push<String?>(
            MaterialPageRoute<String?>(
              builder: (ctx) => MapPickerScreen(
                savedAddress: UserAddressService.instance.address.isNotEmpty
                    ? UserAddressService.instance.address
                    : null,
              ),
            ),
          );
          if (address != null) {
            await UserAddressService.instance.setAddress(address);
          }
        },
      );
    }
  }
}
