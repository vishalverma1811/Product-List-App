import 'dart:math';
import 'package:demo1/core/widgets/app_bar.dart';
import 'package:demo1/core/widgets/selected_product_provider.dart';
import 'package:demo1/product_details.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'core/models/products_model.dart';
import 'core/widgets/product_provider.dart';

class productList extends StatefulWidget {
  const productList({super.key});

  @override
  State<productList> createState() => _productListState();
}

class _productListState extends State<productList> {
  late Box<Product> productsBox;
  void initState() {
    super.initState();
    productsBox = Hive.box<Product>('Products');
  }

  Color generateRandomColor() {
    final Random random = Random();
    final int r = random.nextInt(256);
    final int g = random.nextInt(256);
    final int b = random.nextInt(256);

    return Color.fromARGB(255, r, g, b);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(appBar: AppBar(), context: context),
      body: ValueListenableBuilder(valueListenable: productsBox.listenable(), builder: (context, box, _){
        final productProvider = Provider.of<ProductProvider>(context);
        final selectedPrduct = Provider.of<selectedProduct_provider>(context);
        if(productProvider.isLoading == true){
          return ShimmerList();
        }
        else{
          return ListView.builder(
              itemCount: productProvider.products.length,
              itemBuilder: (context, index){
                final product = productProvider.products[index];
                return Container(
                  width: double.infinity,
                  height: 200,
                  margin: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 20,
                  ),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: generateRandomColor(),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Hero(
                            tag: product.id,
                            child: Container(
                              width: 100,
                              child: ClipRect(
                                child: Image.network(
                                  product!.image,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Title: ${product?.title}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Price in \$: ${product?.price}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              Row(
                                children: [
                                  const Text('More details',style: TextStyle(color: Colors.white)),
                                  const Spacer(),
                                  IconButton(onPressed: (){
                                    selectedPrduct.selected(product);
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const productDetails()));
                                  }, icon: Icon(Icons.arrow_forward), color: Colors.white,)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
        }
      }),
    );
  }
}

class ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            title: Container(
              width: double.infinity,
              height: 200,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }
}