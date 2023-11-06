import 'package:auto_size_text/auto_size_text.dart';
import 'package:demo1/core/widgets/product_provider.dart';
import 'package:demo1/ringtone_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../models/products_model.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final AppBar appBar;
  final BuildContext context;

  const MyAppBar({Key? key, required this.appBar, required this.context})
      : super(key: key);

  @override
  _MyAppBarState createState() => _MyAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}

class _MyAppBarState extends State<MyAppBar> {

  late final http.Client client;
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
  final MethodChannel _flashlightChannel = const MethodChannel('flashlight_channel');
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
            IconButton(
              onPressed: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const ringtoneList()));
              },
              icon: const Icon(Icons.notifications_active,
                  size: 30, color: Colors.black),
            ),
            IconButton(
              onPressed: () async {
                try {
                  final List<bool> arguments = [true];
                  await _flashlightChannel.invokeMethod('turnOnFlashlight', arguments);
                } on PlatformException catch (e) {
                  print("Failed to turn on flashlight: ${e.message}");
                }
              },
              icon: const Icon(Icons.flash_on, size: 30, color: Colors.black),
            ),
          ],
        ),
      ],
    );
  }
}
