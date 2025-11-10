import 'package:flutter_twitte_clone/features/feed/domain/entities/post_entity.dart';
import 'package:flutter_twitte_clone/features/feed/domain/repository/post_repository.dart';

class CreatePostUseCase {
  final PostRepository postRepository;

  CreatePostUseCase({required this.postRepository});

  Future<bool> call({
    required String userId,
    required String userName,
    required String content,
    String? imageUrl,
  }) async {
    final post = PostEntity(
      userId: userId,
      userName: userName,
      content: content.trim(),
      createdAt: DateTime.now(),
      imageUrl: imageUrl,
      likesCount: 0,
      commentsCount: 0,
      respostsCount: 0,
      isLiked: false,
    );
    // TODO: implement call
    return postRepository.createPost(post: post);
  }
}
