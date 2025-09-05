import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pokémon Team Builder')),
      drawer: const AppDrawer(), // 👈 เพิ่ม Drawer ที่เราแยกไฟล์ไว้
      body: Center(),
    );
  }
}
