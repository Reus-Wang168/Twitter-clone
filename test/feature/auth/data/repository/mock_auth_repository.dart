import 'package:flutter_twitte_clone/features/auth/domain/entity/user_entity.dart';
import 'package:flutter_twitte_clone/features/auth/domain/model/login_params.dart';
import 'package:flutter_twitte_clone/features/auth/domain/repository/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  @override
  Future<String> registerUser({required UserEntity user}) async {
    // 模拟成功注册并返回token
    return 'mock_token_123';
  }

  @override
  Future<String> loginUser({required LoginParams loginParams}) async {
    // 模拟成功登录并返回token
    return 'mock_token_123';
  }
}

class MockAuthWithErrorRepository implements AuthRepository {
  @override
  Future<String> registerUser({required UserEntity user}) {
    throw Exception("Mock registration error");
  }

  @override
  Future<String> loginUser({required LoginParams loginParams}) {
    throw Exception("Mock login error");
  }
}
