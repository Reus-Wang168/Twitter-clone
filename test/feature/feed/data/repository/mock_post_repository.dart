import 'package:flutter_twitte_clone/features/feed/domain/entities/post_entity.dart';
import 'package:flutter_twitte_clone/features/feed/domain/repository/post_repository.dart';

class MockPostRepository implements PostRepository {
  @override
  Future<List<PostEntity>> fetchPosts() async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 800));

    return [
      PostEntity(
        userId: "user1",
        userName: "Tech Enthusiast",
        content: "Flutter 3.0 的性能提升太惊人了！#Flutter #开发",
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
        likesCount: 42,
        commentsCount: 7,
        respostsCount: 3,
        imageUrl: "https://picsum.photos/400/300?random=1",
      ),
      PostEntity(
        userId: "user2",
        userName: "Mobile Dev",
        content: "刚刚发布了新的 App，完全用 Flutter 开发，从设计到上线只用了两个月！链接在评论 🚀",
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        likesCount: 128,
        commentsCount: 23,
        respostsCount: 15,
      ),
      PostEntity(
        userId: "user3",
        userName: "代码咖啡师",
        content: "今天的早餐：咖啡 ☕️ + Bug 修复 🐛",
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
        likesCount: 75,
        commentsCount: 12,
        respostsCount: 5,
        imageUrl: "https://picsum.photos/400/300?random=2",
      ),
      PostEntity(
        userId: "user4",
        userName: "设计控",
        content: "分享一个超棒的 Flutter 自定义动画实现，左滑查看效果→",
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
        likesCount: 231,
        commentsCount: 42,
        respostsCount: 28,
        imageUrl: "https://picsum.photos/400/300?random=3",
      ),
      PostEntity(
        userId: "user5",
        userName: "开源爱好者",
        content: "为什么要使用 Domain Driven Design？这里有一份详细的实践总结...",
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        likesCount: 189,
        commentsCount: 34,
        respostsCount: 21,
      ),
    ];
  }

  @override
  Future<bool> createPost({required PostEntity post}) async {
    // TODO: implement createPost
    return true;
  }

  @override
  Future<bool> likePost({
    required String postId,
    required String userId,
  }) async {
    // TODO: implement likePost
    return true;
  }

  @override
  Future<bool> unlikePost({required String postId}) async {
    // TODO: implement unlikePost
    return true;
  }
}

class MockPostWithErrorRepository implements PostRepository {
  @override
  Future<List<PostEntity>> fetchPosts() async {
    throw Exception("Something went wrong");
  }

  @override
  Future<bool> createPost({required PostEntity post}) {
    // TODO: implement createPost
    throw Exception("Something went wrong");
  }

  @override
  Future<bool> likePost({required String postId, required String userId}) {
    // TODO: implement likePost
    throw Exception("Something went wrong");
  }

  @override
  Future<bool> unlikePost({required String postId}) {
    // TODO: implement unlikePost
    throw Exception("Something went wrong");
  }
}
