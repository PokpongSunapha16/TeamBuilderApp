import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/team_controller.dart';
import 'team_list_page.dart';

class TeamPreviewPage extends GetView<TeamController> {
  const TeamPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Pokémon Team')),
      body: Obx(() {
        final list = controller.team;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Team Name + SAVE Button ---
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: controller.nameTextController,
                      decoration: InputDecoration(
                        hintText: 'Enter team name...',
                        prefixIcon: const Icon(Icons.edit),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 24,
                      ),
                    ),
                    onPressed: () {
                      if (controller.teamName.value.trim().isEmpty) {
                        Get.snackbar(
                          "Error",
                          "Please enter a team name!",
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.redAccent.withOpacity(0.8),
                          colorText: Colors.white,
                          margin: const EdgeInsets.all(12),
                          borderRadius: 8,
                        );
                        return;
                      }
                      if (controller.team.length != 3) {
                        Get.snackbar(
                          "Error",
                          "Team must have exactly 3 Pokémon!",
                          snackPosition: SnackPosition.TOP,
                        );
                        return;
                      }

                      controller.saveTeam();
                      Get.off(() => const TeamListPage());
                    },
                    child: const Text("SAVE"),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // --- Team Members ---
              Text(
                'Team Members (${list.length}/3)',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),

              if (list.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.orange.withOpacity(0.06),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: const Text('No Pokémon selected yet.'),
                )
              else
                ...list.map(
                  (p) => Card(
                    child: ListTile(
                      leading: Hero(
                        tag: 'poke_${p.id}',
                        child: Image.network(p.imageUrl, width: 56, height: 56),
                      ),
                      title: Text(
                        p.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        '#${p.id}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () => controller.togglePokemon(p),
                        tooltip: 'Remove from team',
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
