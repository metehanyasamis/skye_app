import 'dart:io';

import 'package:flutter/foundation.dart';

/// Oturum boyunca seçilen profil fotoğrafını tutar.
/// Edit Profile'dan kaydedilen veya Profile'a dönen avatar burada saklanır,
/// böylece sayfa geçişlerinde kaybolmaz.
class ProfileAvatarCache {
  ProfileAvatarCache._();

  static final ProfileAvatarCache instance = ProfileAvatarCache._();

  File? _file;

  File? get file => _file;

  void set(File? f) {
    _file = f;
    debugPrint('📷 [ProfileAvatarCache] set: ${f?.path ?? "null"}');
  }

  void clear() {
    _file = null;
    debugPrint('📷 [ProfileAvatarCache] cleared');
  }
}
