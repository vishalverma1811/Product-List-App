import 'package:demo1/core/models/products_model.dart';
part 'cart_model.g.dart';
class cartModel{
  final Product selectedProduct;
  int count;

  cartModel(this.selectedProduct, this.count);
}