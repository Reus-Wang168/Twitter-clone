part of 'feed_bloc.dart';

sealed class FeedBlocState extends Equatable {
  const FeedBlocState();

  @override
  List<Object> get props => [];
}

final class FeedBlocInitial extends FeedBlocState {}

final class FeedBlocLoading extends FeedBlocState {}

final class FeedBlocLoaded extends FeedBlocState {
  final List<PostEntity> posts;

  const FeedBlocLoaded({required this.posts});

  FeedBlocLoaded copyWith({List<PostEntity>? posts}) {
    return FeedBlocLoaded(posts: posts ?? this.posts);
  }

  @override
  List<Object> get props => [posts];
}

final class FeedBlocError extends FeedBlocState {
  final String message;

  const FeedBlocError({required this.message});

  @override
  List<Object> get props => [message];
}

final class FeedBlocEmpty extends FeedBlocState {}

final class FeedBlocNoInternet extends FeedBlocState {}
