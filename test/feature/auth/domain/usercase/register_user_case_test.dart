import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_twitte_clone/features/auth/domain/usecases/register_user_case.dart';

import '../../data/repository/mock_auth_repository.dart';

void main() {
  group("registerUserCase test", () {
    late RegisterUserCase registerUserCase;
    late RegisterUserCase registerWithErrorUserCase;

    setUp(() {
      registerUserCase = RegisterUserCase(authRepository: MockAuthRepository());

      registerWithErrorUserCase = RegisterUserCase(
        authRepository: MockAuthWithErrorRepository(),
      );
    });

    test("should register user success and retun a token", () async {
      final String tEmail = "wjj@gmail.com";
      final String tPassword = "xx1111";
      final String tUsername = "Tom Hanks";

      final result = await registerUserCase.call(
        email: tEmail,
        password: tPassword,
        username: tUsername,
      );

      expect(result, "mock_token_123");
      //arrange
      //act
      //assert
    });

    test("should retrun an  error when email is empty", () async {
      final String tEmail = "";
      final String tPassword = "xx11";
      final String tUsername = "Tom Hanks";

      expect(
        () async => await registerUserCase.call(
          email: tEmail,
          password: tPassword,
          username: tUsername,
        ),
        throwsA(isA<Exception>()),
      );
      //arrange
      //act
      //assert
    });

    test("password should be at least 6 characters", () async {
      final String tEmail = "fer@gmail.com";
      final String tPassword = "xx1112";
      final String tUsername = "";

      expect(
        () async => await registerUserCase.call(
          email: tEmail,
          password: tPassword,
          username: tUsername,
        ),
        throwsA(isA<Exception>()),
      );
      //arrange
      //act
      //assert
    });

    test("Should return an erro if username is empty", () async {
      final String tEmail = "fer@gmail.com";
      final String tPassword = "xx1112";
      final String tUsername = "";

      expect(
        () async => await registerWithErrorUserCase.call(
          email: tEmail,
          password: tPassword,
          username: tUsername,
        ),
        throwsA(isA<Exception>()),
      );
      //arrange
      //act
      //assert
    });
  });
}
