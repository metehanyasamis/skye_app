/// Pilot model for instructor/pilot listings
class PilotModel {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? about;
  final String? profilePhotoPath;
  final PilotProfile? pilotProfile;

  PilotModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.about,
    this.profilePhotoPath,
    this.pilotProfile,
  });

  factory PilotModel.fromJson(Map<String, dynamic> json) {
    return PilotModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: (json['name'] as String?) ?? '',
      email: (json['email'] as String?) ?? '',
      phone: json['phone'] as String?,
      about: json['about'] as String?,
      profilePhotoPath: json['profile_photo_path'] as String?,
      pilotProfile: json['pilot_profile'] != null
          ? PilotProfile.fromJson(json['pilot_profile'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'about': about,
      'profile_photo_path': profilePhotoPath,
      'pilot_profile': pilotProfile?.toJson(),
    };
  }

  /// Get display name (full_name from pilot_profile or name)
  String get displayName => pilotProfile?.fullName ?? name;

  /// Get distance string (for now, placeholder - will need location data)
  String get distanceDisplay => 'Near you'; // TODO: Calculate actual distance

  /// Check if pilot is an instructor (has instructor_ratings)
  bool get isInstructor => pilotProfile?.instructorRatings.isNotEmpty ?? false;
}

/// Pilot profile details
class PilotProfile {
  final int id;
  final String fullName;
  final int? age;
  final String? address;
  final String? licenseNumber;
  final String? location;
  final int? experienceYears;
  final int? totalFlightHours;
  final double? hourlyRate;
  final double? rating; // Average rating score (e.g., 4.9)
  final String? level;
  final List<Language> languages;
  final List<InstructorRating> instructorRatings;
  final List<OtherLicense> otherLicenses;
  final List<AircraftExperience> aircraftExperiences;

  PilotProfile({
    required this.id,
    required this.fullName,
    this.age,
    this.address,
    this.licenseNumber,
    this.location,
    this.experienceYears,
    this.totalFlightHours,
    this.hourlyRate,
    this.rating,
    this.level,
    this.languages = const [],
    this.instructorRatings = const [],
    this.otherLicenses = const [],
    this.aircraftExperiences = const [],
  });

  factory PilotProfile.fromJson(Map<String, dynamic> json) {
    return PilotProfile(
      id: (json['id'] as num?)?.toInt() ?? 0,
      fullName: (json['full_name'] as String?) ?? '',
      age: (json['age'] as num?)?.toInt(),
      address: json['address'] as String?,
      licenseNumber: json['license_number'] as String?,
      location: json['location'] as String?,
      experienceYears: (json['experience_years'] as num?)?.toInt(),
      totalFlightHours: (json['total_flight_hours'] as num?)?.toInt(),
      hourlyRate: (json['hourly_rate'] as num?)?.toDouble(),
      rating: (json['rating'] as num?)?.toDouble(),
      level: json['level'] as String?,
      languages: (json['languages'] as List<dynamic>?)
              ?.map((e) => Language.fromJson(e is Map ? e as Map<String, dynamic> : <String, dynamic>{}))
              .toList() ??
          [],
      instructorRatings: (json['instructor_ratings'] as List<dynamic>?)
              ?.map((e) => InstructorRating.fromJson(e is Map ? e as Map<String, dynamic> : <String, dynamic>{}))
              .toList() ??
          [],
      otherLicenses: (json['other_licenses'] as List<dynamic>?)
              ?.map((e) => OtherLicense.fromJson(e is Map ? e as Map<String, dynamic> : <String, dynamic>{}))
              .toList() ??
          [],
      aircraftExperiences: (json['aircraft_experiences'] as List<dynamic>?)
              ?.map((e) => AircraftExperience.fromJson(e is Map ? e as Map<String, dynamic> : <String, dynamic>{}))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'age': age,
      'address': address,
      'license_number': licenseNumber,
      'location': location,
      'experience_years': experienceYears,
      'total_flight_hours': totalFlightHours,
      'hourly_rate': hourlyRate,
      'rating': rating,
      'level': level,
      'languages': languages.map((e) => e.toJson()).toList(),
      'instructor_ratings': instructorRatings.map((e) => e.toJson()).toList(),
      'other_licenses': otherLicenses.map((e) => e.toJson()).toList(),
      'aircraft_experiences': aircraftExperiences.map((e) => e.toJson()).toList(),
    };
  }
}

class Language {
  final int id;
  final String languageCode;

  Language({
    required this.id,
    required this.languageCode,
  });

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      id: (json['id'] as num?)?.toInt() ?? 0,
      languageCode: (json['language_code'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'language_code': languageCode,
    };
  }
}

class InstructorRating {
  final int id;
  final String ratingCode;

  InstructorRating({
    required this.id,
    required this.ratingCode,
  });

  factory InstructorRating.fromJson(Map<String, dynamic> json) {
    return InstructorRating(
      id: (json['id'] as num?)?.toInt() ?? 0,
      ratingCode: (json['rating_code'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rating_code': ratingCode,
    };
  }
}

class OtherLicense {
  final int id;
  final String licenseCode;

  OtherLicense({
    required this.id,
    required this.licenseCode,
  });

  factory OtherLicense.fromJson(Map<String, dynamic> json) {
    return OtherLicense(
      id: (json['id'] as num?)?.toInt() ?? 0,
      licenseCode: (json['license_code'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'license_code': licenseCode,
    };
  }
}

class AircraftExperience {
  final int id;
  final String aircraftType;
  final int hours;
  final bool ownsAircraft;

  AircraftExperience({
    required this.id,
    required this.aircraftType,
    required this.hours,
    required this.ownsAircraft,
  });

  factory AircraftExperience.fromJson(Map<String, dynamic> json) {
    final aircraftType = json['aircraft_type'] as String?;
    final aircraftTypeCode = json['aircraft_type_code'] as String?;
    return AircraftExperience(
      id: (json['id'] as num?)?.toInt() ?? 0,
      aircraftType: (aircraftType ?? aircraftTypeCode ?? '').toString(),
      hours: (json['hours'] as num?)?.toInt() ?? 0,
      ownsAircraft: json['owns_aircraft'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'aircraft_type': aircraftType,
      'hours': hours,
      'owns_aircraft': ownsAircraft,
    };
  }
}

/// Response wrapper for pilot list
class PilotListResponse {
  final List<PilotModel> data;
  final Map<String, dynamic>? meta;
  final Map<String, dynamic>? links;

  PilotListResponse({
    required this.data,
    this.meta,
    this.links,
  });

  factory PilotListResponse.fromJson(Map<String, dynamic> json) {
    return PilotListResponse(
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => PilotModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      meta: json['meta'] as Map<String, dynamic>?,
      links: json['links'] as Map<String, dynamic>?,
    );
  }
}
