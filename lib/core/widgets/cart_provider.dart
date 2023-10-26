import 'package:demo1/core/models/products_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import '../models/cart_model.dart';

class cartProvider extends ChangeNotifier{
  late Box<cartModel> cartBox;
  List<cartModel> items = [];

  cartProvider(){
    cartBox = Hive.box<cartModel>('cart');
    items = cartBox.values.toList();
  }

  void addProduct(Product product) {
    final index = items.indexWhere((item) => item.selectedProduct.id == product.id);

    if (index != -1) {
      items[index].count++;
    } else {
      items.add(cartModel(product, 1));
    }
    // Save the updated cart in Hive
    cartBox.put('cart', items as cartModel);
    notifyListeners();
  }

}