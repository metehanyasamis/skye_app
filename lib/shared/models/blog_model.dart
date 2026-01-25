/// Blog post model
class BlogModel {
  final int id;
  final String title;
  final String slug;
  final String content;
  final String excerpt;
  final String? featuredImage;
  final DateTime? publishedAt;
  final BlogAuthor? author;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BlogModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.content,
    required this.excerpt,
    this.featuredImage,
    this.publishedAt,
    this.author,
    this.createdAt,
    this.updatedAt,
  });

  factory BlogModel.fromJson(Map<String, dynamic> json) {
    return BlogModel(
      id: json['id'] as int,
      title: json['title'] as String,
      slug: json['slug'] as String,
      content: json['content'] as String,
      excerpt: json['excerpt'] as String,
      featuredImage: json['featured_image'] as String?,
      publishedAt: json['published_at'] != null
          ? DateTime.parse(json['published_at'] as String)
          : null,
      author: json['author'] != null
          ? BlogAuthor.fromJson(json['author'] as Map<String, dynamic>)
          : null,
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
      'slug': slug,
      'content': content,
      'excerpt': excerpt,
      'featured_image': featuredImage,
      'published_at': publishedAt?.toIso8601String(),
      'author': author?.toJson(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

/// Blog author model
class BlogAuthor {
  final int id;
  final String name;

  BlogAuthor({
    required this.id,
    required this.name,
  });

  factory BlogAuthor.fromJson(Map<String, dynamic> json) {
    return BlogAuthor(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

/// Blog list response with pagination
class BlogListResponse {
  final List<BlogModel> data;
  final BlogMeta meta;

  BlogListResponse({
    required this.data,
    required this.meta,
  });

  factory BlogListResponse.fromJson(Map<String, dynamic> json) {
    return BlogListResponse(
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => BlogModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      meta: BlogMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );
  }
}

/// Blog pagination meta
class BlogMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  BlogMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory BlogMeta.fromJson(Map<String, dynamic> json) {
    return BlogMeta(
      currentPage: json['current_page'] as int,
      lastPage: json['last_page'] as int,
      perPage: json['per_page'] as int,
      total: json['total'] as int,
    );
  }
}
