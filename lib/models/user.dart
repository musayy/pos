enum UserRole { cashier, manager, admin }

class User {
  final int id;
  final String username;
  final String password;
  final UserRole role;

  User({
    required this.id,
    required this.username,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'role': role.toString().split('.').last,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
      role: UserRole.values
          .firstWhere((e) => e.toString() == 'UserRole.' + map['role']),
    );
  }
}
