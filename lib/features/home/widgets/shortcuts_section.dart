
import 'package:flutter/material.dart';
import 'package:skye_app/features/home/widgets/shortcut_card.dart';

import '../../../shared/theme/app_colors.dart';

class ShortcutsSection extends StatelessWidget {
  const ShortcutsSection({
    super.key,
    required this.onAircraftTap,
    required this.onTimeBuildingTap,
    required this.onCfiTap,
    this.onLogbookTap,
  });

  final VoidCallback onAircraftTap;
  final VoidCallback onTimeBuildingTap;
  final VoidCallback onCfiTap;
  final VoidCallback? onLogbookTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SHORTCUTS',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: AppColors.textGrayLight,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ShortcutCard(
                icon: Icons.flight_takeoff_rounded,
                title: 'AIRCRAFT \nRENTALS/SALES',
                subtitle: 'advertise your aircraft',
                onTap: onAircraftTap,
              ),
            ),
            const SizedBox(width: 10), // Aradaki boşluk figma'ya göre daraltıldı
            Expanded(
              child: ShortcutCard(
                icon: Icons.more_time_rounded,
                title: 'TIME BUILDING',
                subtitle: 'complete 1500 hours',
                onTap: onTimeBuildingTap,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ShortcutCard(
                icon: Icons.badge_rounded,
                title: 'GET LISTED \nAS A CFI',
                subtitle: "Be SKYE's top CFI",
                onTap: onCfiTap,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ShortcutCard(
                icon: Icons.menu_book_rounded,
                title: 'LOGBOOK',
                subtitle: 'coming soon',
                comingSoon: true,
                onTap: onLogbookTap ?? () {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}