import 'package:flutter_twitte_clone/features/auth/domain/entity/user_entity.dart';

class AuthResult {
  final String token;
  final UserEntity user;

  AuthResult({required this.token, required this.user});
}
