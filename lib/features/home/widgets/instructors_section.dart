import 'package:flutter/material.dart';
import 'package:skye_app/features/cfi/cfi_detail_screen.dart';
import 'package:skye_app/features/cfi/cfi_listing_screen.dart';
import 'package:skye_app/features/home/widgets/instructor_card.dart';
import 'package:skye_app/shared/models/pilot_model.dart';
import 'package:skye_app/shared/theme/app_colors.dart';

/// Instructors section widget for home screen
class InstructorsSection extends StatelessWidget {
  const InstructorsSection({
    super.key,
    required this.pilots,
    required this.isLoading,
  });

  final List<PilotModel> pilots;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'INSTRUCTORS NEAR YOU',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textGrayLight,
                letterSpacing: 0.6,
              ),
            ),
            TextButton(
              onPressed: () {
                debugPrint('🧭 [InstructorsSection] See All -> CfiListingScreen');
                Navigator.of(context).pushNamed(CfiListingScreen.routeName);
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'See All',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textGrayLight,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 173,
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : pilots.isEmpty
                  ? const Center(
                      child: const Text(
                        'No instructors available',
                        style: TextStyle(
                          color: AppColors.textGrayLight,
                          fontSize: 14,
                        ),
                      ),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: pilots.length,
                      itemBuilder: (context, index) {
                        final pilot = pilots[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            right: index < pilots.length - 1 ? 12 : 0,
                          ),
                          child: InstructorCard(
                            pilot: pilot,
                            // TODO: Get distance from backend based on user's selected location
                            // For now, null means no location selected, so distance won't be shown
                            distanceInMiles: null,
                            onTap: () {
                              debugPrint('🧭 [InstructorsSection] Pilot tapped: ${pilot.displayName}');
                              Navigator.of(context).pushNamed(
                                CfiDetailScreen.routeName,
                                arguments: {'pilotId': pilot.id},
                              );
                            },
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}
