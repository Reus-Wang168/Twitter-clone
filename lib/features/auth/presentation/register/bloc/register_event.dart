abstract class RegisterEvent {}

class RegisterSubmitted extends RegisterEvent {
  final String email;
  final String password;
  final String username;

  RegisterSubmitted({
    required this.email,
    required this.password,
    required this.username,
  });

  @override
  List<Object> get props => [email, password, username];
}
