import 'package:flutter_twitte_clone/features/feed/domain/entities/post_entity.dart';
import 'package:flutter_twitte_clone/features/feed/domain/repository/post_repository.dart'
    show PostRepository;

class FetchPostUseCase {
  final PostRepository postRepository;

  FetchPostUseCase({required this.postRepository});

  Future<List<PostEntity>> call() async {
    final result = await postRepository.fetchPosts();
    return result;
  }
}
