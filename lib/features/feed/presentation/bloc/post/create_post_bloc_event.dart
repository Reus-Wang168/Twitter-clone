part of 'create_post_bloc.dart';

sealed class CreatePostEvent extends Equatable {
  const CreatePostEvent();
  @override
  List<Object> get props => [];
}

class CreatePostRequested extends CreatePostEvent {
  final String content;
  final String? imageUrl;

  const CreatePostRequested({required this.content, this.imageUrl});

  @override
  List<Object> get props => [content];
}
