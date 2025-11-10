import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_twitte_clone/core/utils.dart';

import 'package:flutter_twitte_clone/features/auth/domain/services/user_session_service.dart';
import 'package:flutter_twitte_clone/features/auth/domain/usecases/login_user_case.dart';
import 'package:flutter_twitte_clone/features/auth/presentation/login/bloc/login_event.dart';
import 'package:flutter_twitte_clone/features/auth/presentation/login/bloc/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  late LoginUserCase loginUserCase;

  UserSessionService userSessionService;

  LoginBloc({required this.loginUserCase, required this.userSessionService})
    : super(LoginInitial()) {
    print("✅ LoginBloc created: $loginUserCase");
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  void _onLoginSubmitted(LoginSubmitted event, emit) async {
    emit(LoginLoading());
    try {
      final authResult = await loginUserCase.call(
        email: event.email,
        password: event.password,
      );
      await userSessionService.persistSession(authResult.token);

      await userSessionService.saveUserInfo(authResult.user);

      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailure(message: formatError(e)));
    }
  }
}
