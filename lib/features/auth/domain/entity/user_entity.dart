class UserEntity {
  final String? id;
  final String name;
  final String email;
  final String password;
  final bool isAdmin;
  final String? token; // ✅ Add this line

  UserEntity({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.isAdmin = false,
    this.token, // ✅ Add this line
  });
}
