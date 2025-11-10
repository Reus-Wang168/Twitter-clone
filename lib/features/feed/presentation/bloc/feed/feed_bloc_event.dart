part of 'feed_bloc.dart';

sealed class FeedBlocEvent extends Equatable {
  const FeedBlocEvent();

  @override
  List<Object> get props => [];
}

class FetchPostsRequested extends FeedBlocEvent {}

class LikePostRequested extends FeedBlocEvent {
  final String postId;
  final String userId;

  const LikePostRequested({required this.postId, required this.userId});
}

class UnLikePostRequested extends FeedBlocEvent {
  final String postId;
  final String userId;

  const UnLikePostRequested({required this.postId, required this.userId});
}
