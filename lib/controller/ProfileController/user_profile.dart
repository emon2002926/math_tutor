class UserProfile {
  final int id;
  final String username;
  final String email;

  const UserProfile({
    required this.id,
    required this.username,
    required this.email,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
  };

  @override
  String toString() =>
      'UserProfile(id: $id, username: $username, email: $email)';
}