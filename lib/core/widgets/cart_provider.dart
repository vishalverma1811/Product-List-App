import 'package:demo1/core/models/cart_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import '../models/products_model.dart';

class cartProvider extends ChangeNotifier {
  List<cartModel> cartItems = [];
  final Box<cartModel> storageBox;

  cartProvider() : storageBox = Hive.box<cartModel>('cart'){
    loadCartItems();
  }

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
    saveCartItems();
    notifyListeners();
  }
  // Load cart items from the Hive box
  void loadCartItems() {
    for (var key in storageBox.keys) {
      final item = storageBox.get(key);
      if (item != null) {
        cartItems.add(item);
      }
    }
  }

  // Save cart items to the Hive box
  void saveCartItems() {
    for (var item in cartItems) {
      storageBox.put(item.selectedProduct.id, item);
    }
  }
}