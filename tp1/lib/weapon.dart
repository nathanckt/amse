class Weapon {
  final String category;
  final String name;
  final String description;
  final String image;
  final String apparition;
  final String utilisateur;

  Weapon({
    required this.category,
    required this.name,
    required this.description,
    required this.image,
    required this.apparition,
    required this.utilisateur,
  });

  factory Weapon.fromJson(Map<String, dynamic> json) {
    return Weapon(
      category: json['category'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      apparition: json['apparition'],
      utilisateur: json['utilisateur'],
    );
  }
}
