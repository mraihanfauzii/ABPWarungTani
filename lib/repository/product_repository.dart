import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../utils/constants.dart';

class ProductRepository {
  static Future<List<Product>> getProducts() async {
    var response = await http.get(Uri.parse('$APIURL/product'));
    var jsonData = jsonDecode(response.body);

    List<Product> products = [];

    for (var eachProduct in jsonData['data']) {
      final product = Product(
        id: eachProduct['id'],
        storeId: eachProduct['store_id'],
        name: eachProduct['name'],
        price: eachProduct['price'],
        stockQuantity: eachProduct['stock_quantity'],
        soldQuantity: eachProduct['sold_quantity'],
        imageLink: eachProduct['image_link'],
        description: eachProduct['description'],
        createdAt: DateTime.parse(eachProduct['created_at']),
        updatedAt: DateTime.parse(eachProduct['updated_at']),
      );
      products.add(product);
    }

    return products;
  }

  Future<Product> getProductById(int id) async {
    var response = await http.get(Uri.parse('$APIURL/product/$id'));
    var jsonData = jsonDecode(response.body);

    final product = Product(
      id: jsonData['id'],
      storeId: jsonData['store_id'],
      name: jsonData['name'],
      price: jsonData['price'],
      stockQuantity: jsonData['stock_quantity'],
      soldQuantity: jsonData['sold_quantity'],
      imageLink: jsonData['image_link'],
      description: jsonData['description'],
      createdAt: DateTime.parse(jsonData['created_at']),
      updatedAt: DateTime.parse(jsonData['updated_at']),
    );

    return product;
  }
}
