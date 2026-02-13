import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:skye_app/shared/services/api_service.dart';

/// Application settings from GET /api/settings
class SettingsApiService {
  SettingsApiService._();

  static final SettingsApiService instance = SettingsApiService._();

  /// GET /api/settings
  /// Response: { "success": true, "data": { "contact_address": "...", ... } }
  Future<Map<String, dynamic>> getSettings() async {
    try {
      debugPrint('⚙️ [SettingsApiService] getSettings');

      final response = await ApiService.instance.dio.get('/settings');

      debugPrint('✅ [SettingsApiService] getSettings success');

      final data = response.data as Map<String, dynamic>?;
      if (data?['success'] == true) {
        return data!['data'] as Map<String, dynamic>? ?? {};
      }
      return {};
    } on DioException catch (e) {
      debugPrint('❌ [SettingsApiService] getSettings error: ${e.message}');
      return {};
    } catch (e, st) {
      debugPrint('❌ [SettingsApiService] getSettings unexpected error: $e\n$st');
      return {};
    }
  }

  String? contactAddress(Map<String, dynamic> s) =>
      _str(s['contact_address']);
  String? contactEmail(Map<String, dynamic> s) =>
      _str(s['contact_email']);
  String? contactPhone(Map<String, dynamic> s) =>
      _str(s['contact_phone']);
  String? contactWhatsapp(Map<String, dynamic> s) =>
      _str(s['contact_whatsapp']);
  String? supportEmail(Map<String, dynamic> s) =>
      _str(s['support_email']);
  String? appVersion(Map<String, dynamic> s) =>
      _str(s['app_version']);
  String? footerText(Map<String, dynamic> s) =>
      _str(s['footer_text']);
  String? termsOfService(Map<String, dynamic> s) =>
      _str(s['terms_of_service']);
  String? privacyPolicy(Map<String, dynamic> s) =>
      _str(s['privacy_policy']);
  String? kvkkText(Map<String, dynamic> s) =>
      _str(s['kvkk_text']);

  static String? _str(dynamic v) {
    if (v == null) return null;
    final s = v.toString().trim();
    return s.isEmpty ? null : s;
  }
}
