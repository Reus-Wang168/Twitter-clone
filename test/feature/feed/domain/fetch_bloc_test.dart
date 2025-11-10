import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_twitte_clone/features/feed/domain/usecase/fetch_post_use_case.dart';
import 'package:flutter_twitte_clone/features/feed/presentation/bloc/feed/feed_bloc.dart';

import '../data/repository/mock_post_repository.dart';

void main() {
  late FeedBloc feedBloc;
  late FeedBloc feedBlocWithError;

  setUp(() {
    feedBloc = FeedBloc(
      fetchPostUseCase: FetchPostUseCase(postRepository: MockPostRepository()),
    );

    feedBlocWithError = FeedBloc(
      fetchPostUseCase: FetchPostUseCase(
        postRepository: MockPostWithErrorRepository(),
      ),
    );
  });

  group('FetchBloc test', () {
    blocTest<FeedBloc, FeedBlocState>(
      'emit [feedBlocLoading, feedBlocLoaded] when FetchPostsRequest is added',
      build: () => feedBloc,
      act: (bloc) => bloc.add(FetchPostsRequested()),
      wait: const Duration(seconds: 1),
      expect: () => [FeedBlocLoading(), isA<FeedBlocLoaded>()],
    );

    blocTest<FeedBloc, FeedBlocState>(
      'emit [feedBlocLoading, feedBlocError] when FetchPostsRequest is added and error occurs',
      build: () => feedBlocWithError,
      act: (bloc) => bloc.add(FetchPostsRequested()),
      wait: const Duration(seconds: 1),
      expect: () => [FeedBlocLoading(), isA<FeedBlocError>()],
    );
  });
}
