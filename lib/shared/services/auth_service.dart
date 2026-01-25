import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:skye_app/shared/models/user_type.dart';
import 'package:skye_app/shared/services/user_type_service.dart';

const _keyLoggedIn = 'skye_auth_logged_in';

/// Giriş durumunu SharedPreferences ile saklar.
/// Login / Signup sonrası [setLoggedIn](true), logout / delete sonrası [logout].
final class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  SharedPreferences? _prefs;

  Future<SharedPreferences?> _storage() async {
    try {
      _prefs ??= await SharedPreferences.getInstance();
      return _prefs;
    } catch (e, st) {
      debugPrint('⚠️ [AuthService] SharedPreferences error: $e\n$st');
      return null;
    }
  }

  /// Uygulama açılışında kontrol için. Login/signup tamamlanınca true yapılır.
  /// Hata durumunda false döner (Welcome gösterilir).
  Future<bool> isLoggedIn() async {
    try {
      final prefs = await _storage();
      return prefs?.getBool(_keyLoggedIn) ?? false;
    } catch (e, st) {
      debugPrint('⚠️ [AuthService] isLoggedIn error: $e\n$st');
      return false;
    }
  }

  /// Login veya signup başarılı olduğunda çağrılır.
  Future<void> setLoggedIn(bool value) async {
    try {
      final prefs = await _storage();
      await prefs?.setBool(_keyLoggedIn, value);
    } catch (e, st) {
      debugPrint('⚠️ [AuthService] setLoggedIn error: $e\n$st');
    }
  }

  /// Logout: durumu temizle, [UserType]'ı standard'a al. Hata olsa bile throw etmez.
  Future<void> logout() async {
    try {
      await setLoggedIn(false);
    } catch (e, st) {
      debugPrint('⚠️ [AuthService] logout setLoggedIn error: $e\n$st');
    }
    UserTypeService.instance.setUserType(UserType.standard);
  }

  /// Hesap silme: logout ile aynı temizlik. İleride API çağrısı eklenebilir.
  Future<void> deleteAccount() async {
    try {
      await setLoggedIn(false);
    } catch (e, st) {
      debugPrint('⚠️ [AuthService] deleteAccount setLoggedIn error: $e\n$st');
    }
    UserTypeService.instance.setUserType(UserType.standard);
  }
}
