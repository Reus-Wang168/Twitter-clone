// 专门用于注册的数据传输对象
class RegisterParams {
  final String username;
  final String email;
  final String password;

  RegisterParams({
    required this.username,
    required this.email,
    required this.password,
  }) {
    _validate();
  }

  void _validate() {
    if (email.trim().isEmpty || !email.contains("@")) {
      throw Exception("Invalid email");
    }
    if (username.trim().isEmpty) {
      throw Exception("Username cannot be empty");
    }
    if (password.trim().length < 6) {
      throw Exception("Password must be at least 6 characters");
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "email": email,
      "password": password, // 只在注册时传输
    };
  }
}
