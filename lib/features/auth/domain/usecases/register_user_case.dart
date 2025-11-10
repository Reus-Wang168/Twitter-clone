import 'package:flutter_twitte_clone/features/auth/domain/model/auth_result.dart';
import 'package:flutter_twitte_clone/features/auth/domain/model/register_params.dart';
import 'package:flutter_twitte_clone/features/auth/domain/repository/auth_repository.dart';

class RegisterUserCase {
  final AuthRepository authRepository;

  RegisterUserCase({required this.authRepository});
  Future<AuthResult> call({
    required String email,
    required String password,
    required String username,
  }) async {
    final user = RegisterParams(
      email: email,
      password: password,
      username: username,
    );

    // Simulate a network call or database operation
    //await Future.delayed(Duration(seconds: 1));
    return await authRepository.registerUser(user: user);
  }
}
