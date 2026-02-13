import 'package:skye_app/features/cfi/widgets/aircraft_selector_sheet.dart';

/// Holds CFI form data across navigation so back/forward preserves state.
class CfiFormDataHolder {
  CfiFormDataHolder._();

  static final Map<String, dynamic> _data = {};

  static Map<String, dynamic> get data => Map<String, dynamic>.from(_data);

  static void update(Map<String, dynamic> newData) {
    _data.addAll(newData);
  }

  static void clear() {
    _data.clear();
  }

  /// Merge route args with stored data - stored takes precedence for persistence
  static Map<String, dynamic> mergeWithArgs(Map<String, dynamic>? args) {
    final fromArgs = args ?? {};
    final merged = <String, dynamic>{...fromArgs};
    for (final k in _data.keys) {
      if (_data[k] != null) {
        merged[k] = _data[k];
      }
    }
    return merged;
  }

  /// Convert selected_aircrafts from stored format back to AircraftItem list
  static List<AircraftItem> getSelectedAircrafts(Map<String, dynamic> formData) {
    final list = formData['selected_aircrafts'];
    if (list is! List || list.isEmpty) return [];
    return list.map((a) {
      final name = a['name']?.toString() ?? '';
      final code = a['code']?.toString() ?? '';
      return AircraftItem(name: name, code: code);
    }).toList();
  }

  /// Convert aircraft_experiences from stored format
  static List<Map<String, dynamic>> getAircraftExperiences(Map<String, dynamic> formData) {
    final list = formData['aircraft_experiences'];
    if (list is! List) return [];
    return list.map((e) => Map<String, dynamic>.from(e)).toList();
  }
}
