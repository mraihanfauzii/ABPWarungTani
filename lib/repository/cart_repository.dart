import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cart_detail.dart';
import '../utils/constants.dart';

class CartRepository {
  Future<List<CartDetail>> getCartDetailsForUser(int userId) async {
    var response = await http.get(Uri.parse('$APIURL/cartDetail'));
    var jsonData = jsonDecode(response.body);

    List<CartDetail> cartDetails = [];

    for (var cartData in jsonData['data']) {
      if (cartData['user_id'] == userId) {
        final cartDetail = CartDetail(
          id: cartData['id'],
          userId: cartData['user_id'],
          productId: cartData['product_id'],
          quantity: cartData['quantity'],
          createdAt: DateTime.parse(cartData['created_at']),
          updatedAt: DateTime.parse(cartData['updated_at']),
        );
        cartDetails.add(cartDetail);
      }
    }

    return cartDetails;
  }

  static Future<void> addToCart(int userId, int productId, int quantity) async {
    var url = Uri.parse('$APIURL/cartDetail');
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'user_id': userId,
      'product_id': productId,
      'quantity': quantity,
    });

    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print('Product added to cart successfully');
    } else {
      print('Failed to add product to cart. Error: ${response.statusCode}');
    }
  }

  Future<void> updateCartDetail(int cartDetailId, int quantity) async {
    var url = Uri.parse('$APIURL/cartDetail/$cartDetailId');
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({'quantity': quantity});

    var response = await http.put(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print('Cart detail updated successfully');
    } else {
      print('Failed to update cart detail. Error: ${response.statusCode}');
    }
  }

  Future<void> deleteCartDetail(int cartDetailId) async {
    var url = Uri.parse('$APIURL/cartDetail/$cartDetailId');
    var response = await http.delete(url);

    if (response.statusCode == 204) {
      print('Cart detail deleted successfully');
    } else {
      print('Failed to delete cart detail. Error: ${response.statusCode}');
    }
  }
}
