import 'package:get/get.dart';
import '../models/pokemon.dart';

class ApiService extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = 'https://pokeapi.co/api/v2';
    super.onInit();
  }

  /// ดึง Pokémon list (ชื่อ + id + image + stats)
  Future<List<Pokemon>> fetchPokemons({int limit = 15, int offset = 0}) async {
    try {
      final response = await get(
        '/pokemon',
        query: {'limit': '$limit', 'offset': '$offset'},
      );

      if (!response.isOk || response.body == null) {
        throw Exception('Failed to fetch Pokémon list');
      }

      final List results = response.body['results'];
      final List<Pokemon> pokemons = [];

      // ดึงรายละเอียดของแต่ละตัว (เพื่อเอา stats)
      for (var item in results) {
        final String name = _capitalize(item['name']);
        final String url = item['url'];

        final int id = _extractId(url);
        final String imageUrl =
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';

        // 👇 fetch detail ของ Pokémon (เพื่อดึง stats)
        final detailResponse = await get('/pokemon/$id');
        if (!detailResponse.isOk || detailResponse.body == null) {
          continue;
        }

        final stats = detailResponse.body['stats'] as List;

        String hp = "0";
        String attack = "0";
        String defense = "0";

        for (var stat in stats) {
          final statName = stat['stat']['name'];
          final baseStat = stat['base_stat'].toString();
          if (statName == "hp") hp = baseStat;
          if (statName == "attack") attack = baseStat;
          if (statName == "defense") defense = baseStat;
        }

        pokemons.add(
          Pokemon(
            id: id,
            name: name,
            imageUrl: imageUrl,
            hp: hp,
            attack: attack,
            defense: defense,
          ),
        );
      }

      return pokemons;
    } catch (e) {
      throw Exception("Error fetching Pokémon: $e");
    }
  }

  int _extractId(String url) {
    final parts = url.split('/').where((e) => e.isNotEmpty).toList();
    return int.tryParse(parts.last) ?? 0;
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}
