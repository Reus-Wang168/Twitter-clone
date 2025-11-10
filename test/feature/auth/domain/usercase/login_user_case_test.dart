import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_twitte_clone/features/auth/domain/usecases/login_user_case.dart';

import '../../data/repository/mock_auth_repository.dart';

void main() {
  group("loginUserCase test", () {
    late LoginUserCase loginUserCase;

    setUp(() {
      loginUserCase = LoginUserCase(authRepository: MockAuthRepository());
    });

    test("should register user successfully and retun a token", () async {
      final String tEmail = "wjj@gmail.com";
      final String tPassword = "xx11111";

      final String result = await loginUserCase.call(
        email: tEmail,
        password: tPassword,
      );

      expect(result, "mock_token_123");
      //arrange
      //act
      //assert
    });

    test("should retrun an  error when email is empty", () async {
      final String tEmail = "";
      final String tPassword = "xx11";

      expect(
        () async =>
            await loginUserCase.call(email: tEmail, password: tPassword),
        throwsA(isA<Exception>()),
      );
      //arrange
      //act
      //assert
    });

    test("should retrun an  error when password is empty", () async {
      final String tEmail = "fer@gmail.com";
      final String tPassword = "";

      expect(
        () async =>
            await loginUserCase.call(email: tEmail, password: tPassword),
        throwsA(isA<Exception>()),
      );
      //arrange
      //act
      //assert
    });

    test("password should be at least 6 characters", () async {
      final String tEmail = "fer@gmail.com";
      final String tPassword = "xx1112";

      //arrange
      //act
      //assert
    });
  });
}
