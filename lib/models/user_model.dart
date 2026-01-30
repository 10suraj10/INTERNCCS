class User {
  final String id;
  final String name;
  final String email;
  final String role; // student/admin

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['name'],
      role: json['role'],
    );
  }
}
