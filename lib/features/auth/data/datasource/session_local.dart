import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_twitte_clone/features/auth/domain/entity/user_entity.dart';

abstract class SessionLocalDataSource {
  Future<void> saveToken({required String token});
  Future<String?> getToken();
  Future<void> deleteToken();

  // ✅ 新增的接口
  Future<void> saveUserInfo(UserEntity user);
  Future<UserEntity?> getUserInfo();
  Future<void> deleteUserInfo();
}

class SessionLocalDataSourceImpl implements SessionLocalDataSource {
  final FlutterSecureStorage secureStorage;

  static const String _keyToken = 'auth_token';
  static const String _keyUser = 'user_info'; // ✅ 新增

  SessionLocalDataSourceImpl({required this.secureStorage});

  // ====== Token 相关 ======
  @override
  Future<void> saveToken({required String token}) async {
    await secureStorage.write(key: _keyToken, value: token);
  }

  @override
  Future<String?> getToken() async {
    return await secureStorage.read(key: _keyToken);
  }

  @override
  Future<void> deleteToken() async {
    await secureStorage.delete(key: _keyToken);
  }

  // ====== 用户信息相关 ======
  @override
  Future<void> saveUserInfo(UserEntity user) async {
    final jsonString = jsonEncode(user.toJson());
    await secureStorage.write(key: _keyUser, value: jsonString);
  }

  @override
  Future<UserEntity?> getUserInfo() async {
    final jsonString = await secureStorage.read(key: _keyUser);
    if (jsonString == null) return null;
    return UserEntity.fromJson(jsonDecode(jsonString));
  }

  @override
  Future<void> deleteUserInfo() async {
    await secureStorage.delete(key: _keyUser);
  }
}
