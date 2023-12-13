import 'package:demo1/core/models/products_model.dart';
import 'package:hive/hive.dart';
part 'cart_model.g.dart';

@HiveType(typeId: 1)
class cartModel{
  @HiveField(0)
  final Product selectedProduct;
  @HiveField(1)
  int count;
  cartModel(this.selectedProduct, this.count);
}