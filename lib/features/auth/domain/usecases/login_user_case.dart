import 'package:flutter_twitte_clone/features/auth/domain/model/auth_result.dart';
import 'package:flutter_twitte_clone/features/auth/domain/model/login_params.dart';
import 'package:flutter_twitte_clone/features/auth/domain/repository/auth_repository.dart';

class LoginUserCase {
  final AuthRepository authRepository;

  LoginUserCase({required this.authRepository});

  Future<AuthResult> call({
    required String email,
    required String password,
  }) async {
    final loginParams = LoginParams(email: email, password: password);
    final result = await authRepository.loginUser(loginParams: loginParams);

    return result;
  }
}
