class LoginParams {
  final String email;
  final String password;

  LoginParams({required this.email, required this.password}) {
    // Domain-level validation: keep consistent with RegisterUserCase
    if (email.trim().isEmpty || !email.contains('@')) {
      throw Exception('Invalid email');
    }

    if (password.trim().length < 6) {
      throw Exception('Password must be at least 6 characters');
    }
  }
}
