import 'package:pocketbase/pocketbase.dart';
import 'package:faker/faker.dart';

Future<void> main() async {
  final pb = PocketBase('http://127.0.0.1:8090');

  // ✅ Login ด้วย admin
  await pb.admins.authWithPassword(
    'admin@gmail.com', // ปรับเป็น email admin จริง
    'admin12345',
  );

  final faker = Faker();
  final shopNames = List.generate(10, (_) => faker.company.name());

  for (int i = 0; i < 100; i++) {
    final name = faker.lorem.words(2).join(' ');
    final imageurl =
        'https://picsum.photos/seed/${faker.randomGenerator.integer(10000)}/200';
    final nameshop = faker.company.name();
    final price = faker.randomGenerator.integer(
      900,
      min: 99,
    ); // random price 99-999

    await pb
        .collection('products')
        .create(
          body: {
            'name': name,
            'nameshop': nameshop,
            'imageurl': imageurl,
            'price': price,
          },
        );

    print('Created product $i: $name, shop: $nameshop, price: $price');
  }
}
