class PostEntity {
  final String? id;
  final String userId;
  final String userName;
  final String content;
  final DateTime createdAt;
  final int likesCount;
  final int commentsCount;
  final int respostsCount;
  final String? imageUrl;
  final bool isLiked;
  PostEntity({
    this.id,

    required this.userId,
    required this.userName,
    required this.content,
    required this.createdAt,
    required this.isLiked,

    this.likesCount = 0,
    this.commentsCount = 0,
    this.respostsCount = 0,
    this.imageUrl,
  });

  factory PostEntity.fromJson(Map<String, dynamic> json) {
    return PostEntity(
      id: json['id']?.toString(),
      userId: json['user_id']?.toString() ?? '',
      userName: json['username']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
      imageUrl: json['image_url']?.toString(),
      likesCount: (json['likes_count'] as num?)?.toInt() ?? 0,
      commentsCount: (json['comments_count'] as num?)?.toInt() ?? 0,
      respostsCount: (json['resposts_count'] as num?)?.toInt() ?? 0,
      isLiked: (json['is_liked'] as bool?) ?? false, // 处理 null 情况
    );
  }

  // 提供一个更新喜欢状态的方法
  PostEntity copyWith({int? likesCount, bool? isLiked}) {
    return PostEntity(
      id: id,
      userId: userId,
      userName: userName,
      content: content,
      imageUrl: imageUrl,
      createdAt: createdAt,
      likesCount: likesCount ?? this.likesCount,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'username': userName,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'image_url': imageUrl,
      'likes_count': likesCount,
      'comments_count': commentsCount,
      'resposts_count': respostsCount,
    };
  }

  bool hasImage() => imageUrl != null && imageUrl!.isNotEmpty;
}
