import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/store.dart';
import '../utils/constants.dart';

class StoreRepository {
  static Future<List<Store>> getStores() async {
    var response = await http.get(Uri.parse('$APIURL/store'));
    var jsonData = jsonDecode(response.body);

    List<Store> stores = [];

    for (var storeData in jsonData['data']) {
      final store = Store(
        id: storeData['id'],
        name: storeData['name'],
        createdAt: DateTime.parse(storeData['created_at']),
        updatedAt: DateTime.parse(storeData['updated_at']),
      );
      stores.add(store);
    }

    return stores;
  }

  Future<Store> getStoreById(int id) async {
    var response = await http.get(Uri.parse('$APIURL/store/$id'));
    var jsonData = jsonDecode(response.body);

    final store = Store(
      id: jsonData['id'],
      name: jsonData['name'],
      createdAt: DateTime.parse(jsonData['created_at']),
      updatedAt: DateTime.parse(jsonData['updated_at']),
    );

    return store;
  }
}
