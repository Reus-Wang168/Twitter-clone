import 'package:flutter_twitte_clone/features/auth/domain/entity/user_entity.dart';
import 'package:flutter_twitte_clone/features/auth/domain/model/auth_result.dart';
import 'package:flutter_twitte_clone/features/auth/domain/model/login_params.dart';
import 'package:flutter_twitte_clone/features/auth/domain/model/register_params.dart';
import 'package:flutter_twitte_clone/features/auth/domain/repository/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthRepository implements AuthRepository {
  final SupabaseClient client;

  SupabaseAuthRepository({required this.client});
  String tableName = 'profiles';

  @override
  Future<AuthResult> loginUser({required LoginParams loginParams}) async {
    try {
      final response = await client.auth.signInWithPassword(
        email: loginParams.email,
        password: loginParams.password,
      );

      final session = response.session;
      final user = response.user;

      // 转成你的实体类
      final userEntity = UserEntity(
        id: user?.id ?? '',
        email: user?.email ?? '',
        username: user?.userMetadata?['username'] ?? '',
      );

      if (session == null || session.accessToken.isEmpty) {
        throw Exception('Invalid session');
      }
      return AuthResult(token: session.accessToken, user: userEntity);
    } on AuthException catch (e) {
      // Handle authentication errors
      throw Exception('Failed to login: $e');
      // Handle authentication erro rs
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  @override
  Future<AuthResult> registerUser({required RegisterParams user}) async {
    try {
      // 1. 使用 Supabase Auth 注册
      final response = await client.auth.signUp(
        email: user.email,
        password: user.password,
        data: {'username': user.username}, // 这个只存在 Auth 的 metadata 中
      );

      final session = response.session;

      if (session == null || response.user == null) {
        throw Exception('注册失败');
      }
      // 检查 auth metadata

      // 2. 🟢 关键步骤：手动在 profiles 表创建记录
      try {
        await client.from(tableName).insert({
          'id': response.user!.id, // 使用 Auth 返回的用户ID
          'username': user.username,
          'email': user.email,
          'created_at': DateTime.now().toIso8601String(),
        });
        print('✅ Profile 创建成功: ${user.username}');
      } catch (e) {
        print('⚠️ Profile 创建警告: $e');
        // 即使 profile 创建失败，也不让整个注册失败
      }

      // 3️⃣ 转换为业务层实体
      final userEntity = UserEntity(
        id: response.user!.id,
        email: user.email,
        username: user.username,
      );
      return AuthResult(token: session.accessToken, user: userEntity);
    } on AuthException catch (e) {
      // Handle authentication errors
      throw Exception('Failed to register: $e');
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }

  // ✅ 获取当前用户完整信息
  Future<UserEntity?> getCurrentUser() async {
    final user = client.auth.currentUser;
    if (user == null) return null;

    try {
      final response = await client
          .from(tableName)
          .select()
          .eq('id', user.id)
          .single();

      return UserEntity(
        id: response['id'] as String,
        username: response['username'] as String,
        email: response['email'] as String,
      );
    } catch (e) {
      print('获取用户信息失败: $e');
      return null;
    }
  }

  // ✅ 通过用户名查找用户
  Future<UserEntity?> getUserByUsername(String username) async {
    try {
      final response = await client
          .from(tableName)
          .select()
          .eq('username', username)
          .single();

      return UserEntity(
        id: response['id'] as String,
        username: response[tableName] as String,
        email: response['email'] as String,
      );
    } catch (e) {
      return null;
    }
  }

  // ✅ 更新用户资料
  Future<void> updateProfile({
    required String userId,
    String? username,
    String? bio,
    String? avatarUrl,
  }) async {
    await client
        .from(tableName)
        .update({
          if (username != null) 'username': username,
          if (bio != null) 'bio': bio,
          if (avatarUrl != null) 'avatar_url': avatarUrl,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', userId);
  }
}
