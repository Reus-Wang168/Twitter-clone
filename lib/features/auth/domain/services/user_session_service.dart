import 'package:flutter_twitte_clone/features/auth/data/datasource/session_local.dart';
import 'package:flutter_twitte_clone/features/auth/domain/entity/user_entity.dart';

class UserSessionService {
  final SessionLocalDataSource sessionLocalDataSource;
  UserEntity? _cachedUser; // ✅ 内存缓存（避免频繁IO）

  UserSessionService({required this.sessionLocalDataSource});

  Future<void> persistSession(String token) async {
    await sessionLocalDataSource.saveToken(token: token);
  }

  Future<String?> getUserSession() async {
    return await sessionLocalDataSource.getToken();
  }

  Future<void> logout() async {
    await sessionLocalDataSource.deleteToken();
  }

  Future<bool> isLoggedIn() async {
    final token = await sessionLocalDataSource.getToken();
    return token != null && token.isNotEmpty;
  }

  // === 用户信息部分 ===
  Future<void> saveUserInfo(UserEntity user) async {
    await sessionLocalDataSource.saveUserInfo(user);
    _cachedUser = user;
  }

  Future<UserEntity?> getUserInfo() async {
    // 先读内存缓存，没的话再读本地
    if (_cachedUser != null) return _cachedUser;
    final user = await sessionLocalDataSource.getUserInfo();
    _cachedUser = user;
    return user;
  }
}
