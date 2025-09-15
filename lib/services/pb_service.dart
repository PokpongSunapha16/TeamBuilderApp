import 'package:pocketbase/pocketbase.dart';

class PBService {
  final pb = PocketBase("http://127.0.0.1:8090");

  Future<List<Map<String, dynamic>>> getPokemons() async {
    final records = await pb.collection("pokemons").getFullList();
    return records.map((r) => r.data).toList();
  }
}
