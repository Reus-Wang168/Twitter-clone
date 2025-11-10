import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_twitte_clone/features/auth/domain/services/user_session_service.dart';
import 'package:flutter_twitte_clone/features/auth/domain/usecases/register_user_case.dart';
import 'package:flutter_twitte_clone/features/auth/presentation/register/bloc/register_event.dart';
import 'package:flutter_twitte_clone/features/auth/presentation/register/bloc/register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterUserCase registerUserCase;
  UserSessionService userSessionService;

  RegisterBloc({
    required this.registerUserCase,
    required this.userSessionService,
  }) : super(RegisterInitial()) {
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    try {
      emit(RegisterLoading());
      final result = await registerUserCase(
        email: event.email,
        password: event.password,
        username: event.username,
      );
      await userSessionService.persistSession(result.token);

      await userSessionService.saveUserInfo(result.user);
      emit(RegisterSuccess());
    } catch (e) {
      emit(RegisterFailure(e.toString()));
    }
  }
}
