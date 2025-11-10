import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_twitte_clone/features/feed/domain/usecase/like_post_use_case.dart';

import '../data/repository/mock_post_repository.dart';

void main() {
  group('Like Post User Case', () {
    late MockPostRepository mockPostRepository;
    late LikePostUseCase likePostUserCase;

    setUp(() {
      mockPostRepository = MockPostRepository();
    });

    test('should like a post succ', () async {
      likePostUserCase = LikePostUseCase(postRepository: mockPostRepository);

      final result = await likePostUserCase.call('post_123', '1234');

      expect(result, isTrue);
    });

    // Act
  });
}
