/// Model for spoken language with full name and ISO code.
class LanguageModel {
  const LanguageModel({
    required this.name,
    required this.code,
  });

  final String name;
  final String code;

  String get displayLabel => '$name ($code)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LanguageModel && name == other.name && code == other.code;

  @override
  int get hashCode => Object.hash(name, code);
}
