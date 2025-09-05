import 'pokemon.dart';

class SavedTeam {
  final String name;
  final List<Pokemon> pokemons;

  SavedTeam({required this.name, required this.pokemons});

  Map<String, dynamic> toJson() => {
    'name': name,
    'pokemons': pokemons.map((p) => p.toJson()).toList(),
  };

  factory SavedTeam.fromJson(Map<String, dynamic> json) => SavedTeam(
    name: json['name'],
    pokemons: (json['pokemons'] as List)
        .map((p) => Pokemon.fromJson(Map<String, dynamic>.from(p)))
        .toList(),
  );
}
