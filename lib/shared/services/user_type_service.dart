import 'package:flutter/foundation.dart';

import 'package:skye_app/shared/models/user_type.dart';

/// Uygulama genelinde kullanıcı tipini tutar.
/// Başvuru onaylandığında [setUserType] ile güncellenir.
/// [userTypeNotifier] ile dinlenerek Post FAB görünürlüğü güncellenir.
final class UserTypeService {
  UserTypeService._();

  static final UserTypeService instance = UserTypeService._();

  final ValueNotifier<UserType> _userType = ValueNotifier<UserType>(UserType.standard);

  ValueListenable<UserType> get userTypeNotifier => _userType;

  UserType get userType => _userType.value;

  void setUserType(UserType type) {
    if (_userType.value == type) return;
    _userType.value = type;
  }
}
