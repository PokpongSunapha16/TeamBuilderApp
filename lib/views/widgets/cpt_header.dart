import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/team_controller.dart';

class CptHeader extends GetView<TeamController> {
  const CptHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Team: ${controller.team.length}/3',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: -8,
              children: controller.team
                  .map(
                    (p) => Chip(
                      avatar: CircleAvatar(
                        backgroundImage: NetworkImage(p.imageUrl),
                      ),
                      label: Text(p.name),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      );
    });
  }
}
