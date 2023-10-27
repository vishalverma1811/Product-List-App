import 'package:demo1/core/models/cart_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import '../models/products_model.dart';

class cartProvider extends ChangeNotifier {
  List<cartModel> cartItems = [];

  Future<void> addToCart(Product product) async {
    bool found = false;
    for (var item in cartItems) {
      if (item.selectedProduct.id == product.id) {
        item.count++;
        found = true;
        break;
      }
    }

    if (!found) {
      cartItems.add(cartModel(product, 1));
    }
    final storageBox = await Hive.openBox<Product>('cart');
    cartItems = storageBox.values.toList() as List<cartModel>;
    notifyListeners();
  }
}