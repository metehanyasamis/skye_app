import 'package:flutter/material.dart';
import 'package:skye_app/utils/system_ui_helper.dart';
import 'package:skye_app/theme/app_colors.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  static const routeName = '/notifications';

  @override
  Widget build(BuildContext context) {
    debugPrint('🔔 [NotificationsScreen] build');

    SystemUIHelper.setLightStatusBar();

    return Scaffold(
      backgroundColor: AppColors.cfiBackground,
      body: Column(
        children: [
          // Header
          Container(
            height: 80,
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFFE9ECEF),
                  width: 1,
                ),
              ),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1B2A41),
                    ),
                  ),
                ),

                // Back/Close button
                Positioned(
                  left: 25,
                  top: 20,
                  child: GestureDetector(
                    onTap: () {
                      debugPrint('❌ [NotificationsScreen] close pressed');
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.cfiBackground,
                        border: Border.all(
                          color: const Color(0xFFE9ECEF),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1F2937).withValues(alpha: 0.08),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: AppColors.labelBlack,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Notifications list
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Today section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xFFE9ECEF),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Today',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF222222),
                          ),
                        ),
                        const SizedBox(height: 16),

                        _NotificationItem(
                          icon: Icons.send,
                          iconBackgroundColor: const Color(0xFF1B2A41),
                          iconColor: Colors.white,
                          title: 'Flight reminder',
                          subtitle: 'Lorem Ipsum',
                          timestamp: 'Just now',
                          timestampColor: const Color(0xFF007BA7),
                          titleColor: const Color(0xFF31384A),
                        ),

                        const SizedBox(height: 16),

                        _NotificationItem(
                          icon: Icons.access_time,
                          iconBackgroundColor: const Color(0xFFF8F9FA),
                          iconColor: const Color(0xFF838383),
                          title: 'Premium süresi doluyor',
                          subtitle: 'Lorem ipsum',
                          timestamp: '2 min ago',
                          timestampColor: const Color(0xFF222222),
                          titleColor: const Color(0xFF838383),
                        ),
                      ],
                    ),
                  ),

                  // Yesterday section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Yesterday',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF838383),
                          ),
                        ),
                        const SizedBox(height: 16),

                        _NotificationItem(
                          icon: Icons.send,
                          iconBackgroundColor: const Color(0xFFF8F9FA),
                          iconColor: const Color(0xFF838383),
                          title: 'Flight reminder',
                          subtitle: 'Lorem ipsum',
                          timestamp: '10:30 pm',
                          timestampColor: const Color(0xFF222222),
                          titleColor: const Color(0xFF838383),
                        ),

                        const SizedBox(height: 16),

                        _NotificationItem(
                          icon: Icons.access_time,
                          iconBackgroundColor: const Color(0xFFF8F9FA),
                          iconColor: const Color(0xFF838383),
                          title: 'Citilink R937T to Lost Angeles',
                          subtitle: 'Lorem ipsum',
                          timestamp: '09:00 am',
                          timestampColor: const Color(0xFF222222),
                          titleColor: const Color(0xFF838383),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  const _NotificationItem({
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.timestampColor,
    required this.titleColor,
  });

  final IconData icon;
  final Color iconBackgroundColor;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String timestamp;
  final Color timestampColor;
  final Color titleColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon
        Container(
          width: 40,
          height: 40,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconBackgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: iconColor,
          ),
        ),

        const SizedBox(width: 16),

        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: titleColor == const Color(0xFF31384A)
                      ? FontWeight.bold
                      : FontWeight.w500,
                  color: titleColor,
                  height: 24 / 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Color(0xFF838383),
                  height: 18 / 12,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                timestamp,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.normal,
                  color: timestampColor,
                  height: 14 / 10,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
