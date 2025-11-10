import 'package:flutter_twitte_clone/features/feed/domain/entities/post_entity.dart';
import 'package:flutter_twitte_clone/features/feed/domain/repository/post_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabasePostRespository implements PostRepository {
  final SupabaseClient client;

  SupabasePostRespository({required this.client});
  String tablePosts = 'posts';
  String tableLikes = 'likes';

  @override
  Future<bool> createPost({required PostEntity post}) async {
    try {
      final data = post.toJson();
      await client.from(tablePosts).insert(data);
      return true;
    } catch (e) {
      print('❌ Failed to create post: $e');
      throw Exception('Failed to create post: $e');
    }
  }

  @override
  Future<List<PostEntity>> fetchPosts() async {
    try {
      final response = await client
          .from(tablePosts)
          .select('*')
          .order('created_at', ascending: false);

      return response.map((json) => PostEntity.fromJson(json)).toList();
    } catch (e) {
      print('❌ Failed to fetch posts: $e');
      throw Exception('Failed to fetch posts: $e');
      return [];
    }
  }

  @override
  Future<bool> likePost({
    required String postId,
    required String userId,
  }) async {
    try {
      final data = {'user_id': userId, 'post_id': postId};
      await client.from(tableLikes).upsert(data); // 防止重复插入
      return true;
    } on PostgrestException catch (e) {
      // 如果已经点过赞，不让整个流程中断
      if (e.message.contains('duplicate key value')) {
        print('⚠️ Already liked, ignoring duplicate like');
        return true;
      }
      print('❌ Postgrest error: ${e.message}');
      throw Exception('Failed to like post: ${e.message}');
    } catch (e) {
      print('❌ Unexpected error in likePost: $e');
      throw Exception('Failed to like post: $e');
    }
  }

  @override
  Future<bool> unlikePost({
    required String postId,
    required String userId,
  }) async {
    try {
      final response = await client
          .from(tableLikes)
          .delete()
          .eq('post_id', postId)
          .eq('user_id', userId);

      // 返回 true 表示成功删除，response 可能为空不用强制判断
      return true;
    } catch (e) {
      print('❌ Failed to unlike post: $e');
      throw Exception('Failed to unlike post: $e');
    }
  }
}
