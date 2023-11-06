import 'package:demo1/core/models/products_model.dart';
import 'package:flutter/cupertino.dart';

class selectedProduct_provider extends ChangeNotifier{
  Product? _selectedProduct;
  Product? get selectedProduct => _selectedProduct;

  void selected(Product product){
    _selectedProduct = product;
    notifyListeners();
  }
}