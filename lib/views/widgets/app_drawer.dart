import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_builder_app/views/pages/terms_page.dart';
import '../pages/create_pokemon_team.dart';
import '../pages/team_list_page.dart';
import '../pages/pokemon_detail_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            decoration: const BoxDecoration(color: Colors.redAccent),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min, // 👈 ป้องกัน Overflow
                children: const [
                  CircleAvatar(
                    radius: 50, // ใหญ่ขึ้น
                    backgroundImage: AssetImage("assets/images/profile.jpg"),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Winter Zilla",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Get.back();
              Get.offAllNamed('/');
            },
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Create Team'),
            onTap: () {
              Get.back();
              Get.to(() => const CreatePokemonTeam());
            },
          ),
          ListTile(
            leading: const Icon(Icons.visibility),
            title: const Text('Team List'),
            onTap: () {
              Get.back();
              Get.to(() => const TeamListPage());
            },
          ),
          ListTile(
            leading: const Icon(Icons.electric_bolt),
            title: const Text('Pokemon Detail'),
            onTap: () {
              Get.back();
              Get.to(() => const PokemonDetailPage());
            },
          ),
          ListTile(
            leading: const Icon(Icons.perm_device_info),
            title: const Text('Application Terms'),
            onTap: () {
              Get.back();
              Get.to(() => const TermsPage());
            },
          ),
        ],
      ),
    );
  }
}
