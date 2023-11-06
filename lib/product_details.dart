import 'package:demo1/core/models/cart_model.dart';
import 'package:demo1/core/widgets/cart_provider.dart';
import 'package:demo1/core/widgets/selected_product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class productDetails extends StatelessWidget {
  const productDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productDetailsProvider = Provider.of<selectedProduct_provider>(context);
    final selectedProduct = productDetailsProvider.selectedProduct;
    final CartProvider = Provider.of<cartProvider>(context);

    void addTo_Cart(){
      if(selectedProduct != null){
        CartProvider.cartItems;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Added to cart'),));
      }
    }


    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: selectedProduct != null ?
      SingleChildScrollView(
        child: Column( crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Hero(
                tag: selectedProduct.id,
                child: Container(
                  width: double.infinity,
                  height:500,
                  child: ClipRect(
                    child: Image.network(
                      selectedProduct.image,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0,8.0, 8.0,0.0),
                    child: Text(
                      'ID: ${selectedProduct.id}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0,0.0, 8.0,0.0),
                    child: Text(
                      'Category: ${selectedProduct.category}',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0,0.0, 8.0,8.0),
                    child: Text(
                      '${selectedProduct.title}',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.blueAccent,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            'Price in \$: ${selectedProduct.price}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      IconButton(onPressed: (){
                        CartProvider.addToCart(selectedProduct);
                      }, icon: const Icon(Icons.add_shopping_cart_sharp))
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Description: ${selectedProduct.description}',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),


                ],
              ),
            ),
          ],
        ),
      )
          : Center(
        child: Text('No product selected'),
      ),
    );
  }
}