class Weapon {
  final String category;
  final String name;
  final String description;
  final String image;

  Weapon({
    required this.category,
    required this.name,
    required this.description,
    required this.image,
  });

  factory Weapon.fromJson(Map<String, dynamic> json) {
    return Weapon(
      category: json['category'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
    );
  }
}