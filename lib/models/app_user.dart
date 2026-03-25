enum UserRole { admin, operator }

class AppUser {
  AppUser({
    required this.id,
    required this.username,
    required this.password,
    required this.role,
    required this.fullName,
    this.isActive = true,
  });

  final String id;
  final String username;
  final String password;
  final UserRole role;
  final String fullName;
  final bool isActive;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'password': password,
      'role': role.name,
      'fullName': fullName,
      'isActive': isActive,
    };
  }

  factory AppUser.fromMap(Map<dynamic, dynamic> map) {
    return AppUser(
      id: map['id'] as String,
      username: map['username'] as String,
      password: map['password'] as String,
      role: UserRole.values.firstWhere(
        (UserRole role) => role.name == map['role'],
        orElse: () => UserRole.operator,
      ),
      fullName: map['fullName'] as String,
      isActive: (map['isActive'] as bool?) ?? true,
    );
  }
}
