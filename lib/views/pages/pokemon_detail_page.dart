import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/team_controller.dart';
import '../../models/pokemon.dart';
import '../widgets/pokemon_picture.dart';

class PokemonDetailPage extends GetView<TeamController> {
  const PokemonDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pokémon Detail")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.error.value != null) {
          return Center(child: Text("Error: ${controller.error.value}"));
        }

        final List<Pokemon> items = controller.pokemons;
        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 8, // 👈 การ์ดต่อแถว
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.8,
          ),
          itemCount: items.length,
          itemBuilder: (ctx, i) {
            final p = items[i];
            return GestureDetector(
              onTap: () {
                Get.to(() => PokemonPicture(pokemon: p));
              },
              child: Hero(
                tag: 'poke_${p.id}',
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Image.network(p.imageUrl, fit: BoxFit.contain),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        p.name,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "#${p.id}",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 6),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
