import 'dart:convert';

class Pokemon {
  final int id;
  final String name;
  final String imageUrl;

  const Pokemon({required this.id, required this.name, required this.imageUrl});

  factory Pokemon.fromJson(Map<String, dynamic> json) => Pokemon(
    id: json['id'] as int,
    name: json['name'] as String,
    imageUrl: json['imageUrl'] as String,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'imageUrl': imageUrl,
  };

  String toJsonString() => jsonEncode(toJson());

  factory Pokemon.fromJsonString(String s) => Pokemon.fromJson(jsonDecode(s));

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Pokemon && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
