import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:demo1/core/models/products_model.dart';
import 'package:demo1/core/widgets/product_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

class MockClient extends Mock implements http.Client {}

class MockConnectivity extends Mock implements Connectivity {}

class MockMethodChannel extends Mock implements MethodChannel {}

class MockPathProviderPlatform extends PathProviderPlatform {
  @override
  Future<String> getApplicationDocumentsDirectory() async {
    return '/mocked/documents/directory';
  }
}



Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(ProductAdapter());
  await Hive.openBox<Product>('Products');
  group('ProductProvider', () {
    late ProductProvider productProvider;
    late MockClient mockClient;
    late MockConnectivity mockConnectivity;
    late Box<Product> mockBox;

    setUp(() {
      mockClient = MockClient();
      mockConnectivity = MockConnectivity();
      mockBox = Hive.box<Product>('Products');
      productProvider = ProductProvider();
      productProvider.productsBox = mockBox;
      PathProviderPlatform.instance = MockPathProviderPlatform();

      test('fetchProducts with internet connection', () async {
        when(mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => ConnectivityResult.wifi);
        when(mockClient.get(Uri.parse("https://fakestoreapi.com/products")))
            .thenAnswer((_) async =>
            http.Response(
                json.encode([
                  {'title': 'Product 1'}
                ]),
                200));

        await productProvider.fetchProducts(mockClient);

        expect(productProvider.products.length, 1);
        expect(productProvider.isLoading, false);
      });

      test('fetchProducts without internet connection', () async {
        when(mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => ConnectivityResult.none);
        when(mockBox.isNotEmpty).thenReturn(true);
        when(mockBox.values.toList()).thenReturn([
          Product(
              id: 1,
              title: "Sample Product",
              description: "Product description",
              price: 10.99,
              category: "Electronics",
              image: "sample.jpg")
        ]);

        await productProvider.fetchProducts(mockClient);

        expect(productProvider.products.length, 1);
        expect(productProvider.isLoading, false);
      });
    });
  });
}