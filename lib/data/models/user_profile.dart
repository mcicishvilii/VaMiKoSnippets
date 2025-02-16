class UserProfile {
  final int id;
  final String email;

  UserProfile({
    required this.id,
    required this.email,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      email: json['email'],
    );
  }
}
