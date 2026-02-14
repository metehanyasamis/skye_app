import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:skye_app/shared/models/aircraft_model.dart';
import 'package:skye_app/shared/models/pilot_model.dart';
import 'package:skye_app/shared/services/api_service.dart';

/// Favorites API - GET /api/favorites, POST /api/favorites/toggle
/// Categories: pilot (CFI), safety_pilot, aircraft
class FavoritesApiService {
  FavoritesApiService._();

  static final FavoritesApiService instance = FavoritesApiService._();

  /// Type for toggle: pilot | safety_pilot | aircraft
  static const String typePilot = 'pilot';
  static const String typeSafetyPilot = 'safety_pilot';
  static const String typeAircraft = 'aircraft';

  /// GET /api/favorites?category=pilot|safety_pilot|aircraft
  /// Returns list of favorited items (pilots or aircraft)
  Future<FavoritesResponse> getFavorites(String category) async {
    try {
      debugPrint('❤️ [FavoritesApiService] getFavorites: category=$category');

      final response = await ApiService.instance.dio.get(
        '/favorites',
        queryParameters: {'category': category},
      );

      debugPrint('✅ [FavoritesApiService] getFavorites success');

      final data = response.data;
      if (data is Map && data['data'] != null) {
        final list = data['data'] as List<dynamic>;
        if (category == typeAircraft) {
          final aircraft = list
              .map((e) => AircraftModel.fromJson(e as Map<String, dynamic>))
              .toList();
          return FavoritesResponse(aircraft: aircraft);
        }
        final pilots = list
            .map((e) => PilotModel.fromJson(e as Map<String, dynamic>))
            .toList();
        if (category == typeSafetyPilot) {
          return FavoritesResponse(safetyPilots: pilots);
        }
        return FavoritesResponse(pilots: pilots);
      }
      return FavoritesResponse();
    } on DioException catch (e) {
      debugPrint('❌ [FavoritesApiService] getFavorites error: ${e.message}');
      if (e.response?.statusCode == 404) {
        debugPrint('⚠️ [FavoritesApiService] Endpoint not found - backend may not have favorites yet');
        return FavoritesResponse();
      }
      rethrow;
    } catch (e, st) {
      debugPrint('❌ [FavoritesApiService] getFavorites unexpected: $e\n$st');
      rethrow;
    }
  }

  /// POST /api/favorites/toggle
  /// Body: { "type": "pilot"|"safety_pilot"|"aircraft", "id": int }
  /// Returns { "message": "...", "is_favorited": bool }
  Future<ToggleFavoriteResult> toggleFavorite(String type, int id) async {
    try {
      debugPrint('❤️ [FavoritesApiService] toggleFavorite: type=$type, id=$id');

      final response = await ApiService.instance.dio.post(
        '/favorites/toggle',
        data: {'type': type, 'id': id},
      );

      debugPrint('✅ [FavoritesApiService] toggleFavorite success');

      final data = response.data as Map<String, dynamic>?;
      final isFavorited = data?['is_favorited'] as bool? ?? true;
      final message = data?['message'] as String? ?? 'Updated';

      return ToggleFavoriteResult(isFavorited: isFavorited, message: message);
    } on DioException catch (e) {
      debugPrint('❌ [FavoritesApiService] toggleFavorite error: ${e.message}');
      rethrow;
    } catch (e, st) {
      debugPrint('❌ [FavoritesApiService] toggleFavorite unexpected: $e\n$st');
      rethrow;
    }
  }
}

class FavoritesResponse {
  FavoritesResponse({
    this.pilots = const [],
    this.safetyPilots = const [],
    this.aircraft = const [],
  });

  final List<PilotModel> pilots;
  final List<PilotModel> safetyPilots;
  final List<AircraftModel> aircraft;

  Set<int> get pilotIds => pilots.map((p) => p.id).toSet();
  Set<int> get safetyPilotIds => safetyPilots.map((p) => p.id).toSet();
  Set<int> get aircraftIds => aircraft.map((a) => a.id).toSet();
}

class ToggleFavoriteResult {
  ToggleFavoriteResult({required this.isFavorited, required this.message});
  final bool isFavorited;
  final String message;
}
