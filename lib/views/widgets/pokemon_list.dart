import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/team_controller.dart';
import '../../models/pokemon.dart';
import 'empty_state.dart';

class PokemonList extends GetView<TeamController> {
  const PokemonList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.error.value != null) {
        return EmptyState(
          title: 'Failed to load Pokémon',
          subtitle: controller.error.value!,
        );
      }

      final List<Pokemon> items = controller.filteredPokemons;
      if (items.isEmpty) {
        return const EmptyState(
          title: 'No results',
          subtitle: 'Try a different name in the search bar.',
        );
      }

      return GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8, // 👈 การ์ดต่อแถว
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.8, // 👈 สัดส่วนสูง/กว้างของการ์ด
        ),
        itemCount: items.length,
        itemBuilder: (ctx, i) {
          final p = items[i];
          final selected = controller.isSelected(p);

          return GestureDetector(
            onTap: () => controller.togglePokemon(p),
            child: AnimatedContainer(
              key: ValueKey(p.id),
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected ? Colors.green : Colors.grey.shade300,
                  width: selected ? 3 : 1,
                ),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Hero(
                      tag: 'poke_${p.id}',
                      child: Image.network(p.imageUrl, fit: BoxFit.contain),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    p.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '#${p.id}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
