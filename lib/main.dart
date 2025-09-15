import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'bindings/app_bindings.dart';
import 'views/pages/main_page.dart';
import 'package:pocketbase/pocketbase.dart';

final pb = PocketBase('http://127.0.0.1:8090');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Pokémon Team Builder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.redAccent, useMaterial3: true),
      initialBinding: AppBindings(),
      home: const MainPage(),
    );
  }
}
