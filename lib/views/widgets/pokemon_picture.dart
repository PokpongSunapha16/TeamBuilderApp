import 'package:flutter/material.dart';
import '../../models/pokemon.dart';

class PokemonPicture extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonPicture({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Center(
          child: Hero(
            tag: 'poke_${pokemon.id}',
            child: Image.network(
              pokemon.imageUrl,
              fit: BoxFit.contain,
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.7,
            ),
          ),
        ),
      ),
    );
  }
}
