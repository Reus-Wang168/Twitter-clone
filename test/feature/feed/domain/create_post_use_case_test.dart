import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_twitte_clone/features/feed/domain/usecase/create_post_use_case.dart';

import '../data/repository/mock_post_repository.dart';

void main() {
  late MockPostRepository mockPostRepository;
  late MockPostWithErrorRepository mockPostWithErrorRepository;

  setUp(() {
    mockPostRepository = MockPostRepository();
    mockPostWithErrorRepository = MockPostWithErrorRepository();
  });

  group('CreatePostUseCase', () {
    test('should create a post successfully', () async {
      // Given
      const userId = '123';
      const userName = 'John';
      const content = 'Hello World';
      const imageUrl = 'https://example.com/image.jpg';
      final createPostUseCase = CreatePostUseCase(
        postRepository: mockPostRepository,
      );

      // When
      final result = await createPostUseCase.call(
        userId: userId,
        userName: userName,
        content: content,
        imageUrl: imageUrl,
      );

      // Then
      expect(result, isTrue);
    });

    test('should throw exception when username or  content is empty', () {
      // Given
      const userId = '';
      const userName = '';
      const content = '   '; // 空白内容
      const imageUrl = '';

      final createPostUseCase = CreatePostUseCase(
        postRepository: mockPostRepository,
      );

      final result = createPostUseCase.call(
        userId: userId,
        userName: userName,
        content: content,
        imageUrl: imageUrl,
      );
      // Then
      expect(result, throwsA(isA<Exception>()));
    });

    test('should propagate repository exception', () async {
      // Given
      const userId = '123';
      const userName = 'John';
      final content =
          'a' *
          281; // 281个字符 to ensure usecase validation (if any) passes or fails as expected

      const imageUrl = 'https://example.com/image.jpg';

      final createPostUseCase = CreatePostUseCase(
        postRepository: mockPostWithErrorRepository,
      );

      // Then: await the future and assert it throws the repository error
      await expectLater(
        createPostUseCase.call(
          userId: userId,
          userName: userName,
          content: content,
          imageUrl: imageUrl,
        ),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Something went wrong'),
          ),
        ),
      );
    });
  });
}
