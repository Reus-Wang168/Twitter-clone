import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_twitte_clone/features/auth/domain/usecases/register_user_case.dart';
import 'package:flutter_twitte_clone/features/auth/presentation/register/bloc/register_bloc.dart';
import 'package:flutter_twitte_clone/features/auth/presentation/register/bloc/register_event.dart';
import 'package:flutter_twitte_clone/features/auth/presentation/register/bloc/register_state.dart';

import '../../data/repository/mock_auth_repository.dart';
import '../../domain/usercase/mock_user_session_service.dart';

//UI -> RegisetrEventFormSubmitted -> LoadingState || SuccessState || FailureState
void main() {
  group("LoginBloc  Test", () {
    late RegisterBloc registerBloc;
    late RegisterBloc registerBlocWithError;
    MockUserSessionService mockUserSessionService;

    setUp(() {
      registerBloc = RegisterBloc(
        registerUserCase: RegisterUserCase(
          authRepository: MockAuthRepository(),
        ),

        userSessionService: MockUserSessionService(),
      );

      registerBlocWithError = RegisterBloc(
        registerUserCase: RegisterUserCase(
          authRepository: MockAuthWithErrorRepository(),
        ), //TODO: Pass the RegisterUserCase instance
        userSessionService: MockUserSessionService(),
      );
    });

    blocTest<RegisterBloc, RegisterState>(
      'emits [RegisterLoading, RegisterSuccess] when RegisterSubmitted is called',
      build: () => registerBloc,
      act: (bloc) => bloc.add(
        RegisterSubmitted(
          email: 'test@gmail.com',
          password: '12345678',
          username: 'testuser',
        ),
      ),
      wait: const Duration(seconds: 2),
      expect: () => [isA<RegisterLoading>(), isA<RegisterSuccess>()],
    );

    blocTest<RegisterBloc, RegisterState>(
      'emits [RegisterLoading,RegisterFailure] when email is invalid',
      build: () => registerBloc,
      act: (bloc) => bloc.add(
        RegisterSubmitted(
          email: 'testmail.com',
          password: '12345678',
          username: 'testuser',
        ),
      ),
      wait: const Duration(seconds: 1),
      expect: () => [RegisterLoading(), isA<RegisterFailure>()],
    );

    blocTest<RegisterBloc, RegisterState>(
      'emits [RegisterLoading,RegisterFailure] when repository throws an error',
      build: () => registerBlocWithError,
      act: (bloc) => bloc.add(
        RegisterSubmitted(
          email: 'testmail@gmai.com',
          password: '12345678',
          username: 'testuser',
        ),
      ),
      wait: const Duration(seconds: 1),
      expect: () => [RegisterLoading(), isA<RegisterFailure>()],
    );
  });
}
