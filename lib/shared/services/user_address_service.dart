import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skye_app/shared/utils/debug_logger.dart';

const _keyAddress = 'skye_user_address';
const _keyStructured = 'skye_user_address_structured';

/// Truncate address for app bar display. E.g. "1 World Wyndam..." style.
String truncateAddressForAppBar(String? address, {int maxChars = 18}) {
  if (address == null || address.trim().isEmpty) return 'Select location';
  final trimmed = address.trim();
  if (trimmed.length <= maxChars) return trimmed;
  return '${trimmed.substring(0, maxChars)}...';
}

/// Persists user's selected address and notifies listeners for app bar display.
final class UserAddressService {
  UserAddressService._();

  static final UserAddressService instance = UserAddressService._();

  final ValueNotifier<String> addressNotifier = ValueNotifier<String>('');
  SharedPreferences? _prefs;

  Future<SharedPreferences?> _storage() async {
    try {
      _prefs ??= await SharedPreferences.getInstance();
      return _prefs;
    } catch (e) {
      debugPrint('⚠️ [UserAddressService] SharedPreferences error: $e');
      return null;
    }
  }

  /// Load saved address on app start.
  Future<void> load() async {
    try {
      final prefs = await _storage();
      final saved = prefs?.getString(_keyAddress);
      if (saved != null && saved.isNotEmpty) {
        addressNotifier.value = saved;
        DebugLogger.log('UserAddressService', 'load', {'address': truncateAddressForAppBar(saved)});
      }
    } catch (e) {
      debugPrint('⚠️ [UserAddressService] load error: $e');
    }
  }

  /// Set and persist address. Call when user selects address (map, GPS, profile).
  Future<void> setAddress(String address) async {
    final trimmed = address.trim();
    if (trimmed.isEmpty) return;
    try {
      final prefs = await _storage();
      await prefs?.setString(_keyAddress, trimmed);
      addressNotifier.value = trimmed;
      DebugLogger.log('UserAddressService', 'setAddress', {'address': truncateAddressForAppBar(trimmed)});
    } catch (e) {
      debugPrint('⚠️ [UserAddressService] setAddress error: $e');
    }
  }

  /// Set and persist structured address (for form pre-fill: State, City, Address).
  Future<void> setStructuredAddress({
    required String street,
    required String city,
    required String state,
    required String zip,
  }) async {
    final parts = [street, city, state, zip].where((s) => s.trim().isNotEmpty);
    final address = parts.join(', ');
    if (address.isEmpty) return;
    await setAddress(address);
    try {
      final prefs = await _storage();
      final json = jsonEncode({'street': street, 'city': city, 'state': state, 'zip': zip});
      await prefs?.setString(_keyStructured, json);
    } catch (e) {
      debugPrint('⚠️ [UserAddressService] setStructuredAddress error: $e');
    }
  }

  /// Get stored structured address components. Returns null if none saved.
  Future<({String street, String city, String state, String zip})?> getStructuredAddress() async {
    try {
      final prefs = await _storage();
      final struct = prefs?.getString(_keyStructured);
      if (struct != null && struct.isNotEmpty) {
        final map = jsonDecode(struct) as Map<String, dynamic>?;
        if (map != null) {
          return (
            street: (map['street'] as String?) ?? '',
            city: (map['city'] as String?) ?? '',
            state: (map['state'] as String?) ?? '',
            zip: (map['zip'] as String?) ?? '',
          );
        }
      }
      final full = prefs?.getString(_keyAddress);
      if (full == null || full.trim().isEmpty) return null;
      final p = full.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
      if (p.isEmpty) return null;
      return (
        street: p.length > 0 ? p[0] : '',
        city: p.length > 1 ? p[1] : '',
        state: p.length > 2 ? p[2] : '',
        zip: p.length > 3 ? p[3] : '',
      );
    } catch (_) {
      return null;
    }
  }

  String get address => addressNotifier.value;

  /// Display text for app bar (truncated).
  String get displayText => truncateAddressForAppBar(addressNotifier.value);
}
