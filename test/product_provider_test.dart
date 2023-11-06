import 'dart:convert';
import 'package:demo1/core/models/product_directory.dart';
import 'package:demo1/core/models/products_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';


class MockHTTPClient extends Mock implements Client {}

void main() {
  late productDirectory pdirectory;
  late MockHTTPClient mockHTTPClient;

  setUp(() {
    mockHTTPClient = MockHTTPClient();
    pdirectory = productDirectory(mockHTTPClient);
  });

  group('Product Directory - ', () {
    group('getProduct function', () {
      test(
        'given Product Directory class when getProduct function is called and status code is 200 then a Product model should be returned',
            () async {
          // Arrange
          when(
                () => mockHTTPClient.get(
              Uri.parse('https://fakestoreapi.com/products/1'),
            ),
          ).thenAnswer((invocation) async {
            return Response(
                json.encode({
                  "id": 1,
                  "title": "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops",
                  "price": 109.95,
                  "description": "Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday",
                  "category": "men's clothing",
                  "image":
                  "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg",
                  "rating": {"rate": 3.9, "count": 120}
                }),
                200);
          });
          // Act
          final product = await pdirectory.getProduct();
          // Assert
          expect(product, isA<Product>());
        },
      );

      test(
        'given Product Directory class when getProduct function is called and status code is not 200 then an exception should be thrown',
            () async {
          // arrange
          when(
                () => mockHTTPClient.get(
              Uri.parse('https://fakestoreapi.com/products/1'),
            ),
          ).thenAnswer((invocation) async => Response('{}', 500));
          // act
          final product = pdirectory.getProduct();
          // assert
          expect(product, throwsException);
        },
      );
    });
  });
}