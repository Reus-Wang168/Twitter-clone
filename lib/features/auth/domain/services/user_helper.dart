import 'package:flutter_twitte_clone/features/auth/domain/entity/user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserHelper {
  static Future<UserEntity> getCurrentUserInfo() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      throw Exception('用户未登录，请先登录');
    }

    final metadata = user.userMetadata;
    String? username = metadata?['username'] as String?;

    // 如果 userMetadata 中没有 username，则从 profiles 表查询
    if (username == null || username.isEmpty) {
      final profile = await Supabase.instance.client
          .from('profiles')
          .select('username, email')
          .eq('id', user.id)
          .single();

      username = profile['username'] as String?;
      final email = profile['email'] as String? ?? user.email ?? "";

      if (username == null || username.isEmpty) {
        throw Exception('用户资料不完整');
      }

      return UserEntity(id: user.id, username: username, email: email);
    }

    return UserEntity(id: user.id, username: username, email: user.email ?? "");
  }
}
