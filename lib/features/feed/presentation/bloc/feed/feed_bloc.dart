import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_twitte_clone/core/utils.dart';
import 'package:flutter_twitte_clone/features/auth/domain/services/user_session_service.dart';
import 'package:flutter_twitte_clone/features/feed/domain/entities/post_entity.dart';
import 'package:flutter_twitte_clone/features/feed/domain/usecase/fetch_post_use_case.dart';
import 'package:flutter_twitte_clone/features/feed/domain/usecase/like_post_use_case.dart';
import 'package:flutter_twitte_clone/features/feed/domain/usecase/unlike_post_use_case.dart';

part 'feed_bloc_event.dart';
part 'feed_bloc_state.dart';

class FeedBloc extends Bloc<FeedBlocEvent, FeedBlocState> {
  FetchPostUseCase fetchPostUseCase;
  LikePostUseCase likePostUseCase;
  UnLikePostUseCase unlikePostUseCase;
  UserSessionService userSessionService;

  FeedBloc({
    required this.fetchPostUseCase,
    required this.likePostUseCase,
    required this.unlikePostUseCase,
    required this.userSessionService,
  }) : super(FeedBlocInitial()) {
    on<FetchPostsRequested>(_fetchPostsRequested);
    on<LikePostRequested>(_onLikePostRequested);
    on<UnLikePostRequested>(_onUnLikePostRequested);
  }

  void _fetchPostsRequested(
    FetchPostsRequested event,
    Emitter<FeedBlocState> emit,
  ) async {
    emit(FeedBlocLoading());
    try {
      final posts = await fetchPostUseCase();
      emit(FeedBlocLoaded(posts: posts));
    } catch (e) {
      emit(FeedBlocError(message: formatError(e.toString())));
    }
  }

  void _onLikePostRequested(
    LikePostRequested event,
    Emitter<FeedBlocState> emit,
  ) async {
    print('🎯 LikePostRequested: ${event.postId}');
    //emit(FeedBlocLoading());
    if (state is! FeedBlocLoaded) {
      print('❌ State is not FeedBlocLoaded, current state: $state');
      return;
    }

    final currentState = state as FeedBlocLoaded;

    // 1️⃣ 本地立即更新 - 乐观更新
    final updatedPosts = currentState.posts.map((p) {
      if (p.id == event.postId) {
        return p.copyWith(isLiked: true, likesCount: p.likesCount + 1);
      }
      return p;
    }).toList();
    emit(FeedBlocLoaded(posts: updatedPosts));

    try {
      final user = await userSessionService.getUserInfo();
      if (user == null) {
        emit(FeedBlocError(message: "Please login first"));
        return;
      }
      await likePostUseCase.call(userId: event.userId, postId: event.postId);
      //emit(FeedBlocLoaded(posts: posts));
    } catch (e) {
      // 3️⃣ 如果失败 -> 回滚
      final rollbackPosts = currentState.posts.map((p) {
        if (p.id == event.postId) {
          return p.copyWith(isLiked: false, likesCount: p.likesCount - 1);
        }
        return p;
      }).toList();
      emit(FeedBlocLoaded(posts: rollbackPosts));
    }

    // TODO: implement _likePostRequested
  }

  void _onUnLikePostRequested(
    UnLikePostRequested event,
    Emitter<FeedBlocState> emit,
  ) async {
    print('🎯 LikePostRequested: ${event.postId}');
    //emit(FeedBlocLoading());
    if (state is! FeedBlocLoaded) {
      print('❌ State is not FeedBlocLoaded, current state: $state');
      return;
    }

    final currentState = state as FeedBlocLoaded;

    // 1️⃣ 本地立即更新
    final updatedPosts = currentState.posts.map((p) {
      if (p.id == event.postId) {
        return p.copyWith(isLiked: false, likesCount: p.likesCount - 1);
      }
      return p;
    }).toList();
    emit(FeedBlocLoaded(posts: updatedPosts));

    try {
      final user = await userSessionService.getUserInfo();
      if (user == null) {
        emit(FeedBlocError(message: "Please login first"));
        return;
      }
      await unlikePostUseCase.call(userId: event.userId, postId: event.postId);
      //emit(FeedBlocLoaded(posts: posts));
    } catch (e) {
      // 3️⃣ 如果失败 -> 回滚
      final rollbackPosts = currentState.posts.map((p) {
        if (p.id == event.postId) {
          return p.copyWith(isLiked: false, likesCount: p.likesCount + 1);
        }
        return p;
      }).toList();
      emit(FeedBlocLoaded(posts: rollbackPosts));
    }
  }
}
