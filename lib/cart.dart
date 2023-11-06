import 'package:demo1/core/models/cart_model.dart';
import 'package:demo1/core/widgets/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

class cart extends StatefulWidget {
  const cart({super.key});

  @override
  State<cart> createState() => _cartState();
}

class _cartState extends State<cart> {

  late Box<cartModel> cartBox;
  void initState() {
    super.initState();
    cartBox = Hive.box<cartModel>('cart');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: ValueListenableBuilder(
        valueListenable: cartBox.listenable(),builder: (context, box, _){
        final CartProvider = Provider.of<cartProvider>(context);
          return ListView.builder(
              itemCount: CartProvider.cartItems.length,
              itemBuilder: (context, index){
                final cartItem = CartProvider.cartItems[index];
                return ListTile(
                  leading: Image.network(cartItem.selectedProduct.image),
                  title: Text(cartItem.selectedProduct.title),
                  subtitle: Text('Count: ${cartItem.count}'),
                );
              }
          );
      },
      ),
    );
  }
}
