import 'dart:convert';
import 'package:demo1/core/widgets/cart_provider.dart';
import 'package:demo1/core/widgets/selected_product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class productDetails extends StatefulWidget {
  const productDetails({Key? key}) : super(key: key);

  @override
  State<productDetails> createState() => _productDetailsState();
}

class _productDetailsState extends State<productDetails> {
  Map<String, dynamic>? paymentIntent;
  @override
  Widget build(BuildContext context) {
    final productDetailsProvider = Provider.of<selectedProduct_provider>(context);
    final selectedProduct = productDetailsProvider.selectedProduct;
    final CartProvider = Provider.of<cartProvider>(context);

    displayPaymentSheet() async {
      try {
        await Stripe.instance.presentPaymentSheet(

        ).then((newValue) {
          ScaffoldMessenger.of(context as BuildContext).showSnackBar(const SnackBar(content: Text("paid successfully")));

          paymentIntent = null;
        }).onError((error, stackTrace) {
          print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
        });
      } on StripeException catch (e) {
        print('Exception/DISPLAYPAYMENTSHEET==> $e');
        showDialog(
            context: context,
            builder: (_) => const AlertDialog(
              content: Text("Cancelled "),
            ));
      } catch (e) {
        print('$e');
      }
    }

    Future<Map<String, dynamic>> createPaymentIntent(String amount, String currency) async {
      try {
        final intAmountInCents = (double.parse(amount) * 100).toInt();
        final amountString = intAmountInCents.toString();

        Map<String, dynamic> body = {
          'amount': amountString,
          'currency': currency,
          'payment_method_types[]': 'card',
        };

        var response = await http.post(
            Uri.parse('https://api.stripe.com/v1/payment_intents'),
            body: body,
            headers: {
              'Authorization': 'Bearer ' + 'sk_test_51OA4W4SIsYMV4Kn2KmOiD8zUKodyqwgsKbMcBdXCsW3dDYOIhQFoOvhDUEFeY6DO3B0sn3FIDBzP3bc4x0pJwVp200kOy2uoZd',
              'Content-Type': 'application/x-www-form-urlencoded'
            });

        print('Create Intent response ===> ${response.body.toString()}');
        return jsonDecode(response.body);
      } catch (err) {
        print('Error charging user: $err');
        return Future.error('An error occurred while creating a payment intent');
      }
    }


    Future<void> makePayment() async {
      try {
        paymentIntent = await createPaymentIntent("${selectedProduct?.price.toStringAsFixed(2)}", 'USD');

        await Stripe.instance
            .initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
                setupIntentClientSecret: 'sk_test_51OA4W4SIsYMV4Kn2KmOiD8zUKodyqwgsKbMcBdXCsW3dDYOIhQFoOvhDUEFeY6DO3B0sn3FIDBzP3bc4x0pJwVp200kOy2uoZd',
                paymentIntentClientSecret: paymentIntent!['client_secret'],
                customFlow: true,
                style: ThemeMode.dark,
                merchantDisplayName: 'Payment'))
            .then((value) {});
        displayPaymentSheet();
      } catch (e, s) {
        print('Payment exception:$e$s');
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
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Added to cart'),));
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white,
                            blurRadius: 5.0,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextButton(
                        onPressed: ()async{
                          makePayment();
                        }, child: Text('Buy Now', style: TextStyle(fontSize: 16),),
                      ),
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
