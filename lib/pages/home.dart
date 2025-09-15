import 'package:flutter/material.dart';
import 'products/list.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DSSI SHOPPER', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.orange,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 80),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.store, color: Colors.orange),
                        SizedBox(width: 8),
                        Text(
                          'Top Shops',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(color: Colors.orange),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    TopShopsWidget(),
                    SizedBox(height: 32),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.orange),
                        SizedBox(width: 8),
                        Text(
                          'Top Products',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(color: Colors.orange),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    TopProductsWidget(),
                    SizedBox(height: 32),
                    Row(
                      children: [
                        Icon(Icons.comment, color: Colors.blueAccent),
                        SizedBox(width: 8),
                        Text(
                          'Popular Comments',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(color: Colors.blueAccent),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    PopularReviewsWidget(),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 180,
                  child: ElevatedButton.icon(
                    icon: Icon(
                      Icons.shopping_bag,
                      color: Colors.white,
                      size: 20,
                    ),
                    label: Text(
                      'ดูสินค้าทั้งหมด',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      minimumSize: Size(120, 40),
                      textStyle: TextStyle(fontSize: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => ProductsListPage()),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TopShopsWidget extends StatelessWidget {
  final List<Map<String, String>> shops = [
    {'name': 'Shop A', 'image': 'https://picsum.photos/seed/shopA/120/80'},
    {'name': 'Shop B', 'image': 'https://picsum.photos/seed/shopB/120/80'},
    {'name': 'Shop C', 'image': 'https://picsum.photos/seed/shopC/120/80'},
    {'name': 'Shop D', 'image': 'https://picsum.photos/seed/shopD/120/80'},
    {'name': 'Shop E', 'image': 'https://picsum.photos/seed/shopE/120/80'},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: shops.length,
        separatorBuilder: (_, __) => SizedBox(width: 16),
        itemBuilder: (context, index) {
          final shop = shops[index];
          return Card(
            color: Colors.orange.shade100,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              width: 120,
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      shop['image']!,
                      height: 50,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    shop['name']!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.orange.shade900,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class TopProductsWidget extends StatefulWidget {
  @override
  State<TopProductsWidget> createState() => _TopProductsWidgetState();
}

class _TopProductsWidgetState extends State<TopProductsWidget> {
  final List<Map<String, String>> products = List.generate(
    20,
    (i) => {
      'name': 'Product ${i + 1}',
      'image': 'https://picsum.photos/seed/product${i + 1}/400/300',
      'price': '฿${(i + 1) * 10 + 89}',
    },
  );

  int page = 0;
  static const int itemsPerPage = 8;

  void _changePage(int delta) {
    setState(() {
      page = (page + delta).clamp(
        0,
        (products.length / itemsPerPage).ceil() - 1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final start = page * itemsPerPage;
    final end = (start + itemsPerPage).clamp(0, products.length);
    final pageProducts = products.sublist(start, end);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: page > 0 ? () => _changePage(-1) : null,
            ),
            Text(
              'Page ${page + 1} / ${(products.length / itemsPerPage).ceil()}',
              style: const TextStyle(color: Colors.orange),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: end < products.length ? () => _changePage(1) : null,
            ),
          ],
        ),
        SizedBox(
          height: 220, // 🔹 ลดความสูงรวมของ GridView
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8, // 🔹 แสดง 8 สินค้าต่อแถว
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.85, // 🔹 ปรับสัดส่วนการ์ดให้เล็กลง
            ),
            itemCount: pageProducts.length,
            itemBuilder: (context, index) {
              final product = pageProducts[index];
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 🔹 ลดขนาดรูป
                    SizedBox(
                      height: 90, // กำหนดความสูงรูป (เล็กลง)
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: Image.network(
                          product['image']!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.broken_image, size: 30),
                              ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['name']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            product['price']!,
                            style: const TextStyle(
                              color: Colors.orange,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class PopularReviewsWidget extends StatelessWidget {
  final List<Map<String, String>> reviews = [
    {'user': 'Alice', 'review': 'Great product!'},
    {'user': 'Bob', 'review': 'Fast delivery and good quality.'},
    {'user': 'Charlie', 'review': 'Highly recommend this shop.'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: reviews
          .map(
            (review) => Card(
              color: Colors.blue.shade50,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                title: Text(
                  review['user']!,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(review['review']!),
              ),
            ),
          )
          .toList(),
    );
  }
}
