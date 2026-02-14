import 'package:flutter/material.dart';
import 'package:skye_app/features/cfi/pilot_detail_screen.dart';
import 'package:skye_app/shared/models/pilot_model.dart';
import 'package:skye_app/shared/services/favorites_api_service.dart';

/// Safety Pilot detay ekranı – PilotDetailScreen ile GET /api/pilots/{id} kullanır.
class SafetyPilotDetailScreen extends StatelessWidget {
  const SafetyPilotDetailScreen({super.key});

  static const routeName = '/safety-pilot/detail';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final pilot = args?['pilot'] as PilotModel?;
    final pilotId = args?['pilotId'] ?? args?['applicationId'];
    final isFavorited = args?['isFavorited'] as bool? ?? false;
    const pilotType = FavoritesApiService.typeSafetyPilot;
    if (pilot != null) {
      return PilotDetailScreen(
        pilot: pilot,
        pilotType: pilotType,
        initialIsFavorited: isFavorited,
      );
    }
    final id = pilotId is int ? pilotId : int.tryParse(pilotId?.toString() ?? '');
    if (id != null && id > 0) {
      return PilotDetailScreen(
        pilotId: id,
        pilotType: pilotType,
        initialIsFavorited: isFavorited,
      );
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Safety Pilot'),
      ),
      body: const Center(child: Text('Invalid pilot ID')),
    );
  }
}
