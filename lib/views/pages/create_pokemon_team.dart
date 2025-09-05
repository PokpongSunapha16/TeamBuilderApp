import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/team_controller.dart';
import '../widgets/pokemon_list.dart';
import '../widgets/cpt_header.dart';
import '../widgets/cpt_speed_dial.dart'; // 👈 import SpeedDial

class CreatePokemonTeam extends GetView<TeamController> {
  const CreatePokemonTeam({super.key});

  @override
  Widget build(BuildContext context) {
    Future.microtask(() => controller.resetTeam());

    return Scaffold(
      appBar: AppBar(title: const Text('Select Your Pokemon')),
      body: Column(
        children: [
          // 🔍 search bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Pokémon by name...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                isDense: true,
              ),
              onChanged: (val) => controller.searchQuery.value = val,
            ),
          ),

          // 👥 team header
          const CptHeader(),

          // 📋 Pokémon list
          const Expanded(child: PokemonList()),
        ],
      ),

      // ⚡ speed dial (แทน preview button ล่าง)
      floatingActionButton: const CptSpeedDial(),
    );
  }
}
