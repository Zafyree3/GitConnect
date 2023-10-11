class User {
  final String id;
  final String profileId;
  final List<String> projectsId;
  final List<String> usersID;

  const User({
    required this.id,
    required this.profileId,
    required this.projectsId,
    required this.usersID,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      profileId: json['profile'] as String,
      projectsId: (json['interestedProjects'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      usersID: (json['interestedUsers'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );
  }
}
