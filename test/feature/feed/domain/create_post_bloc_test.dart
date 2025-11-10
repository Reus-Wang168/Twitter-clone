import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_twitte_clone/features/feed/domain/usecase/create_post_use_case.dart';
import 'package:flutter_twitte_clone/features/feed/presentation/bloc/post/create_post_bloc.dart';

import '../data/repository/mock_post_repository.dart';

void main() {
  late CreatePostBloc createPostBloc;
  late CreatePostBloc createPostBlocWithError;

  setUp(() {
    createPostBloc = CreatePostBloc(
      createPostUseCase: CreatePostUseCase(
        postRepository: MockPostRepository(),
      ),
    );

    createPostBlocWithError = CreatePostBloc(
      createPostUseCase: CreatePostUseCase(
        postRepository: MockPostWithErrorRepository(),
      ),
    );
  });

  group('CreatePostBloc test', () {
    const userId = 'userId';
    const userName = 'userName';
    const content = 'content';
    const imgUrl = '';

    blocTest<CreatePostBloc, CreatePostState>(
      'emit [createPostBlocLoading, createPostBlocSuccess] when CreatePostRequested is added',
      build: () => createPostBloc,
      act: (bloc) =>
          bloc.add(CreatePostRequested(content: content, imageUrl: imgUrl)),
      expect: () => [CreatePostLoading(), isA<CreatePostSuccess>()],
    );

    blocTest<CreatePostBloc, CreatePostState>(
      'emit [createPostLoading, createPostError] when CreatePostRequested is added',
      build: () => createPostBlocWithError,
      act: (bloc) => bloc.add(CreatePostRequested(content: content)),
      expect: () => [CreatePostLoading(), isA<CreatePostFailure>()],
    );
  });
}
