import 'package:pocketbase/pocketbase.dart';

class PbService {
  static final PbService _instance = PbService._internal();
  factory PbService() => _instance;

  late final PocketBase client;

  PbService._internal() {
    client = PocketBase('http://127.0.0.1:8090');
  }
}
