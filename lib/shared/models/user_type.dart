/// Kullanıcı tipi: standart, CFI pilot veya safety pilot.
/// CFI ↔ safety pilot birbirini dışlar (onay sonrası tek rol).
enum UserType {
  /// Giriş yapan herkes başlangıçta standart. CFI / safety pilot başvurusu yapabilir.
  standard,

  /// CFI başvurusu onaylanmış. Time building listing'de Post gizlenir.
  cfi,

  /// Safety pilot başvurusu onaylanmış. CFI listing'de Post gizlenir.
  safetyPilot,
}
