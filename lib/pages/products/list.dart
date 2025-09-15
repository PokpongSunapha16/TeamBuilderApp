import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class ProductsListPage extends StatefulWidget {
  @override
  State<ProductsListPage> createState() => _ProductsListPageState();
}

class _ProductsListPageState extends State<ProductsListPage> {
  final pb = PocketBase('http://127.0.0.1:8090');
  final List<Map<String, dynamic>> products = [];
  int page = 1;
  bool isLoading = false;
  bool hasMore = true;
  late Future<UnsubscribeFunc> subscription;

  @override
  void initState() {
    super.initState();
    fetchProducts();
    // Subscribe to realtime updates
    subscription = pb.collection('products').subscribe('*', (e) {
      // Only update affected product for realtime
      if (e.action == 'create' && e.record?.data != null) {
        setState(() {
          products.insert(0, e.record!.data);
        });
      } else if (e.action == 'update' && e.record?.data != null) {
        setState(() {
          final idx = products.indexWhere((p) => p['id'] == e.record?.id);
          if (idx != -1) products[idx] = e.record!.data;
        });
      } else if (e.action == 'delete' && e.record?.id != null) {
        setState(() {
          products.removeWhere((p) => p['id'] == e.record?.id);
        });
      }
    });
  }

  Future<void> fetchProducts() async {
    if (isLoading || !hasMore) return;
    setState(() => isLoading = true);
    final result = await pb
        .collection('products')
        .getList(page: page, perPage: 20);
    setState(() {
      products.addAll(result.items.map((e) => e.data));
      page++;
      hasMore = result.items.length == 20;
      isLoading = false;
    });
  }

  @override
  void dispose() {
    subscription.then((unsubscribe) => unsubscribe());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Products')),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add),
        label: Text('Create'),
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (context) => _ProductDialog(pb: pb),
          );
        },
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (scrollInfo.metrics.pixels >=
                  scrollInfo.metrics.maxScrollExtent - 200 &&
              hasMore &&
              !isLoading) {
            fetchProducts();
          }
          return false;
        },
        child: ListView.builder(
          itemCount: products.length + (hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < products.length) {
              final product = products[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading: product['imageurl'] != null
                      ? Image.network(
                          product['imageurl'],
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        )
                      : null,
                  title: Text(product['name'] ?? ''),
                  subtitle: Text(product['nameshop'] ?? ''),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('฿${product['price'] ?? ''}'),
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        tooltip: 'Update',
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (context) =>
                                _ProductDialog(pb: pb, product: product),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        tooltip: 'Delete',
                        onPressed: () async {
                          await pb.collection('products').delete(product['id']);
                        },
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class _ProductDialog extends StatefulWidget {
  final PocketBase pb;
  final Map<String, dynamic>? product;
  const _ProductDialog({required this.pb, this.product});

  @override
  State<_ProductDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends State<_ProductDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController shopController;
  late TextEditingController imageController;
  late TextEditingController priceController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product?['name'] ?? '');
    shopController = TextEditingController(
      text: widget.product?['nameshop'] ?? '',
    );
    imageController = TextEditingController(
      text: widget.product?['imageurl'] ?? '',
    );
    priceController = TextEditingController(
      text: widget.product?['price']?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    shopController.dispose();
    imageController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.product == null ? 'Create Product' : 'Update Product'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (v) => v == null || v.isEmpty ? 'Enter name' : null,
              ),
              TextFormField(
                controller: shopController,
                decoration: InputDecoration(labelText: 'Shop'),
                validator: (v) => v == null || v.isEmpty ? 'Enter shop' : null,
              ),
              TextFormField(
                controller: imageController,
                decoration: InputDecoration(labelText: 'Image URL'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter image URL' : null,
              ),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Enter price' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: Text(widget.product == null ? 'Create' : 'Update'),
          onPressed: () async {
            if (_formKey.currentState?.validate() ?? false) {
              final data = {
                'name': nameController.text,
                'nameshop': shopController.text,
                'imageurl': imageController.text,
                'price': int.tryParse(priceController.text) ?? 0,
              };
              if (widget.product == null) {
                await widget.pb.collection('products').create(body: data);
              } else {
                await widget.pb
                    .collection('products')
                    .update(widget.product!['id'], body: data);
              }
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
