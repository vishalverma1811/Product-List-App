import 'package:auto_size_text/auto_size_text.dart';
import 'package:demo1/core/widgets/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/products_model.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final AppBar appBar;
  final BuildContext context;

  const MyAppBar({Key? key, required this.appBar, required this.context})
      : super(key: key);

  @override
  _MyAppBarState createState() => _MyAppBarState();

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}

class _MyAppBarState extends State<MyAppBar> {

  Future<void> clearLocalDatabase() async {
    final productsBox = await Hive.openBox<Product>('productsBox');
    await productsBox.clear();
  }
  Future<void> _refreshData() async {
    await clearLocalDatabase();
    print('database cleared');
    ProductProvider();
    print('data fetched');
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leadingWidth: MediaQuery.of(context).size.width / 0.6, // Adjust the divisor as needed
      leading: const Padding(
        padding: EdgeInsets.all(10.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: AutoSizeText(
            "Product List",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: 'Billabong',
            ),
          ),
        ),
      ),
      actions: [
        Row(
          children: [
            IconButton(
              onPressed: () async {
                _refreshData();
              },
              icon: const Icon(Icons.refresh,
                  size: 30, color: Colors.black),
            ),
          ],
        ),
      ],
    );
  }
}
