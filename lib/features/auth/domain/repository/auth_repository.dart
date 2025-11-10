import 'package:flutter_twitte_clone/features/auth/domain/model/auth_result.dart';
import 'package:flutter_twitte_clone/features/auth/domain/model/login_params.dart';
import 'package:flutter_twitte_clone/features/auth/domain/model/register_params.dart';

abstract class AuthRepository {
  Future<AuthResult> registerUser({required RegisterParams user});
  Future<AuthResult> loginUser({required LoginParams loginParams});
}
