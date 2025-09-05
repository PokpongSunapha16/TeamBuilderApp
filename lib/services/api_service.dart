import 'package:get/get.dart';
import '../models/pokemon.dart';

class ApiService extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = 'https://pokeapi.co/api/v2';
    super.onInit();
  }

  Future<List<Pokemon>> fetchPokemons({int limit = 151, int offset = 0}) async {
    final response = await get(
      '/pokemon',
      query: {'limit': '$limit', 'offset': '$offset'},
    );

    if (response.isOk) {
      final List results = response.body['results'];
      return results.map((item) {
        final String name = _capitalize(item['name']);
        final String url = item['url'];
        final int id = _extractId(url);
        final String image =
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
        return Pokemon(id: id, name: name, imageUrl: image);
      }).toList();
    }

    throw Exception('Failed to fetch Pokémons: ${response.statusText}');
  }

  int _extractId(String url) {
    final parts = url.split('/').where((e) => e.isNotEmpty).toList();
    return int.tryParse(parts.last) ?? 0;
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}
