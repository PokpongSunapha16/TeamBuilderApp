import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/pokemon.dart';
import '../models/saved_team.dart';
import '../services/api_service.dart';

class TeamController extends GetxController {
  final pokemons = <Pokemon>[].obs;
  final team = <Pokemon>[].obs;

  final isLoading = false.obs;
  final error = RxnString();
  final searchQuery = ''.obs;
  final teamName = ''.obs;
  final savedTeams = <SavedTeam>[].obs;

  final nameTextController = TextEditingController();

  final storage = GetStorage();
  final ApiService api = Get.find<ApiService>();

  static const _kTeamKey = 'team';
  static const _kTeamNameKey = 'teamName';
  static const _kSavedTeamsKey = 'savedTeams';

  @override
  void onInit() {
    super.onInit();
    _restorePersisted();
    _restoreSavedTeams(); // 👈 โหลด savedTeams กลับมาจาก storage

    everAll([team, teamName], (_) => _persist());

    nameTextController.text = teamName.value;
    nameTextController.addListener(
      () => teamName.value = nameTextController.text,
    );

    loadPokemons();
  }

  @override
  void onClose() {
    nameTextController.dispose();
    super.onClose();
  }

  Future<void> loadPokemons() async {
    try {
      isLoading.value = true;
      error.value = null;
      final list = await api.fetchPokemons(limit: 151);
      pokemons.assignAll(list);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  List<Pokemon> get filteredPokemons {
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return pokemons;
    return pokemons.where((p) => p.name.toLowerCase().contains(q)).toList();
  }

  bool isSelected(Pokemon p) => team.contains(p);

  void togglePokemon(Pokemon p) {
    if (isSelected(p)) {
      team.remove(p);
    } else if (team.length < 3) {
      team.add(p);
    } else {
      Get.snackbar('Limit Reached', 'You can only select 3 Pokémon!');
    }
  }

  void resetTeam() {
    team.clear();
    teamName.value = '';
    nameTextController.text = '';
    storage.remove(_kTeamKey);
    storage.remove(_kTeamNameKey);
  }

  // --------------------
  // Persist / Restore (team)
  // --------------------
  void _persist() {
    final list = team.map((p) => p.toJson()).toList();
    storage.write(_kTeamKey, list);
    storage.write(_kTeamNameKey, teamName.value);
  }

  void _restorePersisted() {
    try {
      final raw = storage.read<List<dynamic>>(_kTeamKey) ?? [];
      final savedTeam = raw
          .whereType<Map>()
          .map((m) => Pokemon.fromJson(Map<String, dynamic>.from(m)))
          .toList();
      team.assignAll(savedTeam);

      final savedName = storage.read<String>(_kTeamNameKey) ?? '';
      teamName.value = savedName;
    } catch (_) {
      team.clear();
      teamName.value = '';
    }
  }

  // --------------------
  // Persist / Restore (savedTeams)
  // --------------------
  void _restoreSavedTeams() {
    try {
      final raw = storage.read<List<dynamic>>(_kSavedTeamsKey) ?? [];
      final list = raw
          .map((e) => SavedTeam.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      savedTeams.assignAll(list);
    } catch (_) {
      savedTeams.clear();
    }
  }

  void saveTeam() {
    final teamCopy = team.toList();
    final newTeam = SavedTeam(name: teamName.value, pokemons: teamCopy);

    savedTeams.insert(0, newTeam); // insert บนสุด
    storage.write(
      _kSavedTeamsKey,
      savedTeams.map((t) => t.toJson()).toList(),
    ); // persist storage
  }

  void deleteTeam(SavedTeam teamToDelete) {
    savedTeams.remove(teamToDelete);
    storage.write(_kSavedTeamsKey, savedTeams.map((t) => t.toJson()).toList());
  }

  void updateTeamName(int index, String newName) {
    savedTeams[index] = SavedTeam(
      name: newName,
      pokemons: savedTeams[index].pokemons,
    );
    storage.write(_kSavedTeamsKey, savedTeams.map((t) => t.toJson()).toList());
  }

  void updateTeamMembers(int index, List<Pokemon> newMembers) {
    savedTeams[index] = SavedTeam(
      name: savedTeams[index].name,
      pokemons: newMembers,
    );
    storage.write(_kSavedTeamsKey, savedTeams.map((t) => t.toJson()).toList());
  }
}
