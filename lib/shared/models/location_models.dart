/// Location-related models for State, City, Airport from API.

class StateModel {
  final int id;
  final String name;
  final String code;

  StateModel({
    required this.id,
    required this.name,
    required this.code,
  });

  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(
      id: (json['id'] as num).toInt(),
      name: (json['name'] as String?) ?? '',
      code: (json['code'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'code': code};
}

class CityModel {
  final int id;
  final String name;

  CityModel({
    required this.id,
    required this.name,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: (json['id'] as num).toInt(),
      name: (json['name'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class AirportModel {
  final int id;
  final String code;
  final String name;

  AirportModel({
    required this.id,
    required this.code,
    required this.name,
  });

  factory AirportModel.fromJson(Map<String, dynamic> json) {
    return AirportModel(
      id: (json['id'] as num).toInt(),
      code: (json['code'] as String?) ?? '',
      name: (json['name'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'code': code, 'name': name};

  String get displayLabel => code.isNotEmpty ? '$code - $name' : name;
}
