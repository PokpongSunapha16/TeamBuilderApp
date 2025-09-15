import 'dart:convert';

class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final String hp;
  final String attack;
  final String defense;

  const Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.hp,
    required this.attack,
    required this.defense,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) => Pokemon(
    id: json['id'] as int,
    name: json['name'] as String,
    imageUrl: json['imageUrl'] as String,
    hp: json['hp'] as String? ?? '0',
    attack: json['attack'] as String? ?? '0',
    defense: json['defense'] as String? ?? '0',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'imageUrl': imageUrl,
    'hp': hp,
    'attack': attack,
    'defense': defense,
  };

  String toJsonString() => jsonEncode(toJson());

  factory Pokemon.fromJsonString(String s) => Pokemon.fromJson(jsonDecode(s));

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Pokemon && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
