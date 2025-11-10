import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_twitte_clone/features/auth/domain/usecases/login_user_case.dart';
import 'package:flutter_twitte_clone/features/auth/presentation/login/bloc/login_bloc.dart';
import 'package:flutter_twitte_clone/features/auth/presentation/login/bloc/login_event.dart';
import 'package:flutter_twitte_clone/features/auth/presentation/login/bloc/login_state.dart';

import '../../data/repository/mock_auth_repository.dart';
import '../../domain/usercase/mock_user_session_service.dart';

//UI -> RegisetrEventFormSubmitted -> LoadingState || SuccessState || FailureState
void main() {
  group("LoginBloc  Test", () {
    late LoginBloc loginBloc;
    late LoginBloc loginBlocWithError;
    MockUserSessionService mockUserSessionService = MockUserSessionService();

    setUp(() {
      loginBloc = LoginBloc(
        loginUserCase: LoginUserCase(authRepository: MockAuthRepository()),
        userSessionService: mockUserSessionService,
      );
      loginBlocWithError = LoginBloc(
        loginUserCase: LoginUserCase(
          authRepository: MockAuthWithErrorRepository(),
        ),
        userSessionService: mockUserSessionService,
      );
    });

    blocTest<LoginBloc, LoginState>(
      'emits [RegisterLoading, RegisterSuccess] when RegisterSubmitted is called',
      build: () => loginBloc,
      act: (bloc) => bloc.add(
        LoginSubmitted(email: 'test@gmail.com', password: '12345678'),
      ),
      wait: const Duration(seconds: 2),
      expect: () => [LoginLoading(), isA<LoginSuccess>()],
    );

    blocTest<LoginBloc, LoginState>(
      'emits [RegisterLoading,RegisterFailure] when email is invalid',
      build: () => loginBloc,
      act: (bloc) =>
          bloc.add(LoginSubmitted(email: 'testmail.com', password: '12345678')),
      wait: const Duration(seconds: 1),
      expect: () => [LoginLoading(), isA<LoginFailure>()],
    );

    blocTest<LoginBloc, LoginState>(
      'emits [RegisterLoading,RegisterFailure] when password is invalid',
      build: () => loginBloc,
      act: (bloc) =>
          bloc.add(LoginSubmitted(email: 'test@gmail.com', password: '1234')),

      wait: const Duration(seconds: 1),
      expect: () => [LoginLoading(), isA<LoginFailure>()],
    );

    blocTest<LoginBloc, LoginState>(
      'emits [LoginrLoading,LoginFailure] when repository throws an error',
      build: () => loginBlocWithError,
      act: (bloc) => bloc.add(
        LoginSubmitted(email: 'testmail@gmai.com', password: '12345678'),
      ),
      wait: const Duration(seconds: 1),
      expect: () => [LoginLoading(), isA<LoginFailure>()],
    );
  });
}
