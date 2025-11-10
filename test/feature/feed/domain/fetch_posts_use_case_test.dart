import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_twitte_clone/features/feed/domain/entities/post_entity.dart';
import 'package:flutter_twitte_clone/features/feed/domain/usecase/fetch_post_use_case.dart';

import '../data/repository/mock_post_repository.dart';

void main() {
  group('FetchFeedUserCase Test', () {
    late MockPostRepository mockPostRepository;
    late MockPostWithErrorRepository mockPostWithErrorRepository;

    setUp(() {
      mockPostRepository = MockPostRepository();
      mockPostWithErrorRepository = MockPostWithErrorRepository();
    });
    test('Should return list of posts', () async {
      FetchPostUseCase fetchPostUseCase = FetchPostUseCase(
        postRepository: mockPostRepository,
      );

      final result = await fetchPostUseCase.call();
      expect(result, isA<List<PostEntity>>());

      expect(result.length, greaterThan(0));
    });

    test('Should throw exception when repository fails', () async {
      final fetchPostUseCase = FetchPostUseCase(
        postRepository: mockPostWithErrorRepository,
      );

      // 使用 throwsException 或 throwsA 来测试异步方法抛出的异常
      expect(() => fetchPostUseCase.call(), throwsA(isA<Exception>()));
    });
  });
}
