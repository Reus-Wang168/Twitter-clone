import 'package:flutter_twitte_clone/features/feed/domain/entities/post_entity.dart';

abstract class PostRepository {
  Future<List<PostEntity>> fetchPosts();

  Future<bool> createPost({required PostEntity post});

  // Future<bool> deletePost({required String postId});

  Future<bool> likePost({required String postId, required String userId});

  Future<bool> unlikePost({required String postId, required String userId});
}
