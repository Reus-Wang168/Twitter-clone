import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_twitte_clone/core/utils.dart';
import 'package:flutter_twitte_clone/features/auth/domain/services/user_helper.dart';
import 'package:flutter_twitte_clone/features/auth/domain/services/user_session_service.dart';
import 'package:flutter_twitte_clone/features/feed/domain/usecase/create_post_use_case.dart';

part 'create_post_bloc_event.dart';
part 'create_post_bloc_state.dart';

class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  CreatePostUseCase createPostUseCase;
  UserSessionService userSessionService;

  CreatePostBloc({
    required this.createPostUseCase,
    required this.userSessionService,
  }) : super(CreatePostInitial()) {
    on<CreatePostRequested>(_createPostRequested);
  }

  Future<void> _createPostRequested(
    CreatePostRequested event,
    Emitter<CreatePostState> emit,
  ) async {
    emit(CreatePostLoading());
    try {
      final isLoggedIn = await userSessionService.isLoggedIn();
      final userInfo = await userSessionService.getUserInfo();
      if (userInfo == null) {
        emit(CreatePostFailure(message: '获取用户信息失败'));
        return;
      }

      await createPostUseCase.call(
        userId: userInfo.id,
        userName: userInfo.username,
        content: event.content,
        imageUrl: event.imageUrl,
      );
      emit(CreatePostSuccess());
    } catch (e) {
      // print(e);
      emit(CreatePostFailure(message: formatError(e)));
    }
  }
}
