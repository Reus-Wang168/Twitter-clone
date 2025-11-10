import 'package:flutter_twitte_clone/features/feed/domain/repository/post_repository.dart';

class UnLikePostUseCase {
  final PostRepository postRepository;

  UnLikePostUseCase({required this.postRepository});

  Future<bool> call({required String postId, required String userId}) async {
    return await postRepository.unlikePost(postId: postId, userId: userId);
  }
}
