import 'chip.dart';

class Project {
  final String id;
  final String name;
  final String type;
  final String tagline;
  final String description;
  final String icon;
  final List<String> pictures;
  final List<Chip> tech;

  const Project({
    required this.id,
    required this.name,
    required this.type,
    required this.tagline,
    required this.description,
    required this.icon,
    required this.pictures,
    required this.tech,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    var imageURL =
        "https://8xzb3ljg-8090.asse.devtunnels.ms/api/files/projects";
    var pfpid = json['id'] as String;
    var icon = json['logo'] as String;

    return Project(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      tagline: json['tagline'] as String,
      description: json['description'] as String,
      icon: '$imageURL/$pfpid/$icon',
      pictures: (json['pictures'] as List<dynamic>)
          .map((e) => ('$imageURL/$pfpid/$e'))
          .toList(),
      tech: (json['expand']['tech'] as List<dynamic>)
          .map((e) => Chip.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
