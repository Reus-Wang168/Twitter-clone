import 'package:flutter_twitte_clone/features/feed/domain/repository/post_repository.dart';

class LikePostUseCase {
  final PostRepository postRepository;

  LikePostUseCase({required this.postRepository});

  Future<bool> call({required String postId, required String userId}) async {
    return await postRepository.likePost(postId: postId, userId: userId);
  }
}
