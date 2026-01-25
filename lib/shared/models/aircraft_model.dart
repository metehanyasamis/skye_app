/// Aircraft listing model
class AircraftModel {
  final int id;
  final String title;
  final String model;
  final int? year;
  final int? seatCount;
  final int? flightHours;
  final String? location;
  final String availabilityStatus;
  final String listingType; // 'sale' or 'rental'
  final double? price;
  final double? wetPrice;
  final double? dryPrice;
  final String? description;
  final bool isActive;
  final bool isApproved;
  final AircraftUser? user;
  final List<AircraftImage> images;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AircraftModel({
    required this.id,
    required this.title,
    required this.model,
    this.year,
    this.seatCount,
    this.flightHours,
    this.location,
    required this.availabilityStatus,
    required this.listingType,
    this.price,
    this.wetPrice,
    this.dryPrice,
    this.description,
    required this.isActive,
    required this.isApproved,
    this.user,
    required this.images,
    this.createdAt,
    this.updatedAt,
  });

  factory AircraftModel.fromJson(Map<String, dynamic> json) {
    return AircraftModel(
      id: json['id'] as int,
      title: json['title'] as String,
      model: json['model'] as String,
      year: json['year'] as int?,
      seatCount: json['seat_count'] as int?,
      flightHours: json['flight_hours'] as int?,
      location: json['location'] as String?,
      availabilityStatus: json['availability_status'] as String,
      listingType: json['listing_type'] as String,
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      wetPrice: json['wet_price'] != null
          ? (json['wet_price'] as num).toDouble()
          : null,
      dryPrice: json['dry_price'] != null
          ? (json['dry_price'] as num).toDouble()
          : null,
      description: json['description'] as String?,
      isActive: json['is_active'] as bool? ?? false,
      isApproved: json['is_approved'] as bool? ?? false,
      user: json['user'] != null
          ? AircraftUser.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      images: (json['images'] as List<dynamic>?)
              ?.map((item) =>
                  AircraftImage.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'model': model,
      'year': year,
      'seat_count': seatCount,
      'flight_hours': flightHours,
      'location': location,
      'availability_status': availabilityStatus,
      'listing_type': listingType,
      'price': price,
      'wet_price': wetPrice,
      'dry_price': dryPrice,
      'description': description,
      'is_active': isActive,
      'is_approved': isApproved,
      'user': user?.toJson(),
      'images': images.map((img) => img.toJson()).toList(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Get cover image URL (first image with is_cover=true, or first image)
  String? get coverImageUrl {
    if (images.isEmpty) return null;
    
    try {
      final coverImage = images.firstWhere((img) => img.isCover);
      return coverImage.url;
    } catch (e) {
      // No cover image found, return first image
      return images.first.url;
    }
  }
}

/// Aircraft user model
class AircraftUser {
  final int id;
  final String name;
  final String email;
  final String? profilePhotoPath;

  AircraftUser({
    required this.id,
    required this.name,
    required this.email,
    this.profilePhotoPath,
  });

  factory AircraftUser.fromJson(Map<String, dynamic> json) {
    return AircraftUser(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      profilePhotoPath: json['profile_photo_path'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profile_photo_path': profilePhotoPath,
    };
  }
}

/// Aircraft image model
class AircraftImage {
  final int id;
  final String url;
  final bool isCover;
  final int sortOrder;

  AircraftImage({
    required this.id,
    required this.url,
    required this.isCover,
    required this.sortOrder,
  });

  factory AircraftImage.fromJson(Map<String, dynamic> json) {
    return AircraftImage(
      id: json['id'] as int,
      url: json['url'] as String,
      isCover: json['is_cover'] as bool? ?? false,
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'is_cover': isCover,
      'sort_order': sortOrder,
    };
  }
}

/// Aircraft list response with pagination
class AircraftListResponse {
  final List<AircraftModel> data;
  final AircraftMeta meta;

  AircraftListResponse({
    required this.data,
    required this.meta,
  });

  factory AircraftListResponse.fromJson(Map<String, dynamic> json) {
    return AircraftListResponse(
      data: (json['data'] as List<dynamic>?)
              ?.map((item) =>
                  AircraftModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      meta: AircraftMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );
  }
}

/// Aircraft pagination meta
class AircraftMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  AircraftMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory AircraftMeta.fromJson(Map<String, dynamic> json) {
    return AircraftMeta(
      currentPage: json['current_page'] as int,
      lastPage: json['last_page'] as int,
      perPage: json['per_page'] as int,
      total: json['total'] as int,
    );
  }
}
