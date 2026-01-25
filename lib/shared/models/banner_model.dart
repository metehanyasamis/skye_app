/// Banner model for home screen banners
class BannerModel {
  final int id;
  final String title;
  final String? subtitle;
  final String mediaUrl; // API returns 'media_url' not 'image_url'
  final String? linkUrl;
  final String? type; // 'image' or 'video'
  final int? sortOrder;

  BannerModel({
    required this.id,
    required this.title,
    this.subtitle,
    required this.mediaUrl,
    this.linkUrl,
    this.type,
    this.sortOrder,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] as int,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String?,
      mediaUrl: json['media_url'] as String, // API uses 'media_url'
      linkUrl: json['link_url'] as String?, // May be null
      type: json['type'] as String?,
      sortOrder: json['sort_order'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'media_url': mediaUrl,
      'link_url': linkUrl,
      'type': type,
      'sort_order': sortOrder,
    };
  }
}
