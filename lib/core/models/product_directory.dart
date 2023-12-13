import 'dart:convert';
import 'package:demo1/core/models/products_model.dart';
import 'package:http/http.dart' as http;

class productDirectory {
  final http.Client client;
  productDirectory(this.client);

  Future<Product> getProduct() async {
    final response = await client.get(
      Uri.parse('https://fakestoreapi.com/products/1'),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return Product.fromJson(jsonData);
    }
    throw Exception('Some Error Occurred');
  }
}