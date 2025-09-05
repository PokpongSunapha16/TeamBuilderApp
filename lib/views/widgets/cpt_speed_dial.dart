import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../../controllers/team_controller.dart';
import '../pages/team_preview_page.dart';

class CptSpeedDial extends GetView<TeamController> {
  const CptSpeedDial({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // If no Pokémon selected → hide FAB
      if (controller.team.isEmpty) {
        return const SizedBox.shrink();
      }

      return SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.redAccent,
        overlayColor: Colors.black,
        overlayOpacity: 0.4,
        spacing: 12,
        spaceBetweenChildren: 8,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.visibility),
            label: 'Preview Team',
            onTap: () {
              if (controller.team.length < 3) {
                Get.snackbar(
                  'Team Incomplete',
                  'You must select exactly 3 Pokémon before previewing!',
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.redAccent.withOpacity(0.8),
                  colorText: Colors.white,
                  margin: const EdgeInsets.all(12),
                  borderRadius: 8,
                );
              } else {
                Get.to(() => const TeamPreviewPage());
              }
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.restart_alt),
            label: 'Reset Team',
            onTap: controller.resetTeam,
          ),
        ],
      );
    });
  }
}
