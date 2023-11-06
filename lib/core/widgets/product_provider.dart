import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/products_model.dart';

class ProductProvider with ChangeNotifier {
  late Box<Product> productsBox;

  ProductProvider() {
    productsBox = Hive.box<Product>('Products');
    fetchProducts();
  }

  List<Product> _products = [];
  List<Product> get products => _products;

  bool _isLoading = true;
  bool get isLoading => _isLoading;


  Future<bool> _hasInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> fetchProducts() async {

    if(await _hasInternetConnection() == true){
      print('Internet connection available');
      final response = await http.get(Uri.parse("https://fakestoreapi.com/products"));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<Product> productList = data.map((item) => Product.fromJson(item)).toList();
        _products = productList;
        await productsBox.addAll(productList);
        _isLoading = false;
        print('products fetched');
      }
    }else {
      print('Internet not available');
      final storageBox = await Hive.openBox<Product>('Products');
      if(storageBox.isNotEmpty){
        _products = storageBox.values.toList();
        _isLoading = false;
        print('offline list fetched');
      }
    }
    notifyListeners();
  }

}
