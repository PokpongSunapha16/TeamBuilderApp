import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/team_controller.dart';
import 'team_list_page.dart';

class TeamPreviewPage extends StatefulWidget {
  const TeamPreviewPage({super.key});

  @override
  State<TeamPreviewPage> createState() => _TeamPreviewPageState();
}

class _TeamPreviewPageState extends State<TeamPreviewPage> {
  final TeamController controller = Get.find<TeamController>();

  // 👇 เก็บชื่อทีมที่ถูก SAVE แล้ว
  final savedTeamName = "".obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🔸 AppBar จะเปลี่ยนชื่อเฉพาะเมื่อ SAVE เท่านั้น
      appBar: AppBar(
        title: Obx(
          () => Text(
            savedTeamName.value.isEmpty
                ? 'Your Pokémon Team'
                : savedTeamName.value,
          ),
        ),
      ),
      body: Obx(() {
        final list = controller.team;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Team Name + SAVE + Team List ---
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
                  // ✅ SAVE: จะเปลี่ยน AppBar หลังจากกดบันทึก
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
                      final name = controller.teamName.value.trim();

                      if (name.isEmpty) {
                        Get.snackbar(
                          "Error",
                          "Please enter a team name!",
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.redAccent.withOpacity(0.85),
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
                          backgroundColor: Colors.redAccent.withOpacity(0.85),
                          colorText: Colors.white,
                          margin: const EdgeInsets.all(12),
                          borderRadius: 8,
                        );
                        return;
                      }

                      controller.saveTeam();
                      savedTeamName.value =
                          name; // 👈 เปลี่ยนชื่อ AppBar ตอนนี้

                      Get.snackbar(
                        "Saved",
                        "Team \"$name\" has been saved.",
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.green.withOpacity(0.85),
                        colorText: Colors.white,
                        margin: const EdgeInsets.all(12),
                        borderRadius: 8,
                      );
                    },
                    child: const Text("SAVE"),
                  ),
                  const SizedBox(width: 8),
                  // 🟠 Team List
                  ElevatedButton.icon(
                    icon: const Icon(Icons.list),
                    label: const Text("Team List"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 18,
                      ),
                    ),
                    onPressed: () => Get.to(() => const TeamListPage()),
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
