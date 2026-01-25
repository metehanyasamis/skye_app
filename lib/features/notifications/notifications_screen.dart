import 'package:flutter/material.dart';

import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/system_ui_helper.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  static const routeName = '/notifications';

  @override
  Widget build(BuildContext context) {
    SystemUIHelper.setLightStatusBar();

    return Scaffold(
      backgroundColor: AppColors.cfiBackground,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.navy900,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.labelBlack, size: 22),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 8,
            bottom: 16 + MediaQuery.of(context).viewPadding.bottom,
          ),
          physics: const ClampingScrollPhysics(),
          children: [
            _SectionLabel(label: 'Today'),
            const SizedBox(height: 12),
            _NotificationTile(
              icon: Icons.send,
              iconBg: AppColors.navy800,
              iconColor: AppColors.white,
              title: 'Flight reminder',
              subtitle: 'Lorem Ipsum',
              time: 'Just now',
              timeHighlight: true,
            ),
            _NotificationTile(
              icon: Icons.access_time,
              iconBg: AppColors.cardLight,
              iconColor: AppColors.grayPrimary,
              title: 'Premium süresi doluyor',
              subtitle: 'Lorem ipsum',
              time: '2 min ago',
              timeHighlight: false,
            ),
            const SizedBox(height: 24),
            _SectionLabel(label: 'Yesterday'),
            const SizedBox(height: 12),
            _NotificationTile(
              icon: Icons.send,
              iconBg: AppColors.cardLight,
              iconColor: AppColors.grayPrimary,
              title: 'Flight reminder',
              subtitle: 'Lorem ipsum',
              time: '10:30 pm',
              timeHighlight: false,
            ),
            _NotificationTile(
              icon: Icons.access_time,
              iconBg: AppColors.cardLight,
              iconColor: AppColors.grayPrimary,
              title: 'Citilink R937T to Lost Angeles',
              subtitle: 'Lorem ipsum',
              time: '09:00 am',
              timeHighlight: false,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: label == 'Today' ? AppColors.navy900 : AppColors.grayPrimary,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.timeHighlight,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String time;
  final bool timeHighlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.labelBlack.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: timeHighlight ? FontWeight.w700 : FontWeight.w500,
                    color: timeHighlight ? AppColors.navy900 : AppColors.grayPrimary,
                    height: 1.25,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.grayPrimary,
                          height: 1.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: timeHighlight ? AppColors.blue500 : AppColors.grayPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
