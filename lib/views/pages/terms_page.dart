import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'create_pokemon_team.dart';
import 'team_list_page.dart';
import 'pokemon_detail_page.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final terms = [
      "คุณต้องสร้างทีมโดยเลือกโปเกมอนจำนวน 3 ตัวเท่านั้น",
      "คุณสามารถดูตัวอย่างทีมของคุณได้ในหน้า Team Preview",
      "เมื่อบันทึกทีมแล้ว ทีมจะถูกเก็บไว้ใน Team List",
      "คุณสามารถแก้ไขชื่อทีม หรือแก้ไขสมาชิกในทีมได้ตลอดเวลา",
      "คุณสามารถดูรายละเอียดโปเกมอนเพิ่มเติมได้จากหน้า Pokémon Detail",
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("ข้อกำหนดการใช้งานแอป")),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: terms.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (_, i) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.redAccent,
              child: Text(
                "${i + 1}",
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(terms[i]),
            // 👇 เพิ่ม navigation ไปยังหน้าที่เกี่ยวข้อง
            trailing: _buildActionButton(i),
          );
        },
      ),
    );
  }

  Widget? _buildActionButton(int index) {
    switch (index) {
      case 0:
        return TextButton(
          onPressed: () => Get.to(() => const CreatePokemonTeam()),
          child: const Text("View"),
        );
      case 2:
        return TextButton(
          onPressed: () => Get.to(() => const TeamListPage()),
          child: const Text("View"),
        );
      case 4:
        return TextButton(
          onPressed: () => Get.to(() => const PokemonDetailPage()),
          child: const Text("View"),
        );
      default:
        return null;
    }
  }
}
