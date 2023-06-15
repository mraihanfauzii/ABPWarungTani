import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class OrderRepository {
  static Future<void> checkoutOrder(int userId) async {
    var url = Uri.parse('$APIURL/order');
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'user_id': userId,
    });

    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print('Order Checkout successfull');
    } else {
      print('Failed to Checkout Order. Error: ${response.statusCode}');
    }
  }
}
