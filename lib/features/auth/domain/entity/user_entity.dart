class UserEntity {
  final String id;
  final String username;
  final String email;

  UserEntity({required this.id, required this.username, required this.email});

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'],
      username: json['username'],
      email: json['email'],
    );
  }
  Map<String, dynamic> toJson() {
    return {'id': id, 'username': username, 'email': email};
  }
} 
 

  // {
  //   "id": "1",
  //   "name": "John Doe",

