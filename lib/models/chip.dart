class Chip {
  final String name;
  final String hex;

  const Chip({
    required this.name,
    required this.hex,
  });

  factory Chip.fromJson(Map<String, dynamic> json) {
    return Chip(
      name: json['name'] as String,
      hex: json['hex'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'hex': hex,
    };
  }
}
