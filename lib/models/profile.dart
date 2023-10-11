import 'chip.dart';

class Profile {
  final String id;
  final String name;
  final String role;
  final String bio;
  final String icon;
  final List<String> pictures;
  final List<Chip> skills;
  final List<Chip> interests;

  const Profile({
    required this.id,
    required this.name,
    required this.role,
    required this.bio,
    required this.icon,
    required this.pictures,
    required this.skills,
    required this.interests,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    var imageURL =
        "https://8xzb3ljg-8090.asse.devtunnels.ms/api/files/profiles";
    var pfpid = json['id'] as String;
    var pfpicon = json['icon'] as String;

    return Profile(
      id: json['id'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      bio: json['bio'] as String,
      icon: ('$imageURL/$pfpid/$pfpicon'),
      pictures: (json['pictures'] as List<dynamic>)
          .map((e) => ('$imageURL/$pfpid/$e'))
          .toList(),
      skills: (json['expand']['skills'] as List<dynamic>)
          .map((e) => Chip.fromJson(e as Map<String, dynamic>))
          .toList(),
      interests: (json['expand']['interests'] as List<dynamic>)
          .map((e) => Chip.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
