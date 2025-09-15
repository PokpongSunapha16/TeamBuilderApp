import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/team_controller.dart';

class TeamListPage extends GetView<TeamController> {
  const TeamListPage({super.key});

  void _showEditNameDialog(BuildContext context, int index) {
    final team = controller.savedTeams[index];
    final textCtrl = TextEditingController(text: team.name);

    Get.dialog(
      AlertDialog(
        title: const Text("Edit Team Name"),
        content: TextField(
          controller: textCtrl,
          decoration: const InputDecoration(
            labelText: "Team Name",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () {
              final newName = textCtrl.text.trim();
              if (newName.isNotEmpty) {
                controller.updateTeamName(index, newName);
                Get.back();
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _showEditMembersDialog(BuildContext context, int index) {
    final team = controller.savedTeams[index];
    final selected = team.pokemons.toList().obs; // 👈 ใช้ RxList

    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: Container(
          width: double.maxFinite,
          height: 500,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                "Edit Team Members",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Obx(() {
                  final pokemons = controller.pokemons;
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 6, // 👈 แถวละ 6
                          mainAxisSpacing: 6,
                          crossAxisSpacing: 6,
                          childAspectRatio: 0.7,
                        ),
                    itemCount: pokemons.length,
                    itemBuilder: (_, i) {
                      final p = pokemons[i];

                      // 👇 ครอบการ์ดแต่ละใบด้วย Obx เพื่ออัปเดตเรียลไทม์
                      return Obx(() {
                        final isSelected = selected.contains(p);

                        return GestureDetector(
                          onTap: () {
                            if (isSelected) {
                              selected.remove(p);
                            } else {
                              if (selected.length < 3) {
                                selected.add(p);
                              } else {
                                Get.snackbar(
                                  "Limit Reached",
                                  "You can only select 3 Pokémon!",
                                  snackPosition: SnackPosition.TOP,
                                );
                              }
                            }
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.green
                                    : Colors.grey.shade300,
                                width: isSelected ? 3 : 1,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Image.network(
                                    p.imageUrl,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Text(
                                  p.name,
                                  style: const TextStyle(fontSize: 10),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Icon(
                                  isSelected
                                      ? Icons.check_circle
                                      : Icons.add_circle_outline,
                                  color: isSelected
                                      ? Colors.green
                                      : Colors.grey,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                    },
                  );
                }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text("Cancel"),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      if (selected.length == 3) {
                        controller.updateTeamMembers(index, selected.toList());
                        Get.back();
                      } else {
                        Get.snackbar(
                          "Invalid Team",
                          "A team must have exactly 3 Pokémon!",
                          snackPosition: SnackPosition.TOP,
                        );
                      }
                    },
                    child: const Text("Save"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pokemon Team List")),
      body: Obx(() {
        if (controller.savedTeams.isEmpty) {
          return const Center(
            child: Text("No teams yet. Create and save a team!"),
          );
        }

        return ListView.builder(
          itemCount: controller.savedTeams.length,
          itemBuilder: (_, i) {
            final team = controller.savedTeams[i];
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: team.pokemons
                      .map(
                        (p) => Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Image.network(p.imageUrl, width: 32),
                        ),
                      )
                      .toList(),
                ),
                title: Text(
                  team.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "Pokémon: ${team.pokemons.map((p) => p.name).join(', ')}",
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orange),
                      onPressed: () => _showEditNameDialog(context, i),
                    ),
                    IconButton(
                      icon: const Icon(Icons.group, color: Colors.green),
                      onPressed: () => _showEditMembersDialog(context, i),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => controller.deleteTeam(team),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
