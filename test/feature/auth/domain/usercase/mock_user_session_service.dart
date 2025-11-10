import 'package:flutter_twitte_clone/features/auth/data/datasource/session_local.dart';
import 'package:flutter_twitte_clone/features/auth/domain/entity/user_entity.dart';
import 'package:flutter_twitte_clone/features/auth/domain/services/user_session_service.dart';

class MockUserSessionService implements UserSessionService {
  @override
  Future<void> persistSession(String token) async {}

  @override
  Future<String?> getUserSession() async {
    return "mock_token";
  }

  @override
  Future<bool> isLoggedIn() async {
    return true;
  }

  @override
  // TODO: implement sessionLocalDataSource
  SessionLocalDataSource get sessionLocalDataSource =>
      throw UnimplementedError();

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<UserEntity?> getUserInfo() {
    // TODO: implement getUserInfo
    throw UnimplementedError();
  }

  @override
  Future<void> saveUserInfo(UserEntity user) {
    // TODO: implement saveUserInfo
    throw UnimplementedError();
  }
}
