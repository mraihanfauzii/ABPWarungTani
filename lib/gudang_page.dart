import 'package:flutter/material.dart';
import 'package:warungtani/detail_product_page.dart';
import 'models/store.dart';
import 'models/product.dart';
import 'repository/product_repository.dart';
import 'repository/store_repository.dart';

class GudangPage extends StatelessWidget {
  final Store gudang;

  const GudangPage({Key? key, required this.gudang}) : super(key: key);

  Future<List<Product>> fetchProductsForStore(int storeId) async {
    try {
      List<Product> products = await ProductRepository.getProducts();
      List<Store> stores = await StoreRepository.getStores();

      // Find the specific store by ID
      Store store = stores.firstWhere((store) => store.id == storeId);

      // Filter the products by store ID
      List<Product> filteredProducts =
          products.where((product) => product.storeId == storeId).toList();

      print(filteredProducts);
      return filteredProducts;
    } catch (error) {
      print('Error fetching products: $error');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Gudang Page'), backgroundColor: Colors.green),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Banner paling atas
              Image.asset(
                'images/cover_gudang.png',
                width: 430.0,
                height: 180.0,
              ),
              Container(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'images/logo_gudang.png',
                          width: 80.0,
                          height: 80.0,
                        ),
                        const SizedBox(width: 4.0),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                gudang.name,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                    size: 24.0,
                                  ),
                                  const Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                    size: 24.0,
                                  ),
                                  const Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                    size: 24.0,
                                  ),
                                  const Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                    size: 24.0,
                                  ),
                                  const Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                    size: 24.0,
                                  ),
                                  Text(
                                    5.toString(),
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ],
                              ),
                              const Text(
                                'Jarak: ${100}',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey,
                                ),
                              ),
                            ]),
                      ],
                    ),
                    // Jarak gudang
                    const SizedBox(height: 16.0),
                    // Daftar produk
                    const Text(
                      'Produk',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    FutureBuilder<List<Product>>(
                      future: fetchProductsForStore(gudang.id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          List<Product> products = snapshot.data ?? [];
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16.0,
                              mainAxisSpacing: 16.0,
                            ),
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              Product product = products[index];
                              return Card(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailScreen(
                                          item: product,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      Image.network(
                                        product.imageLink,
                                        width: 175.0,
                                        height: 100.0,
                                      ),
                                      ListTile(
                                        title: Text(
                                          product.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          product.price.toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.brown,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              )
              // Nama gudang, rating, dan icon bintang
            ],
          ),
        ),
      ),
    );
  }
}
