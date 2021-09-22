import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:paypal_sdk/catalog_products.dart';
import 'package:paypal_sdk/core.dart';
import 'package:test/test.dart';

import 'mock_http_client.dart';

void main() {
  late PayPalHttpClient _payPalHttpClient;

  String _productDescription = 'test_description';

  setUp(() {
    var mockHttpClient = MockHttpClient(MockHttpClientHandler());
    mockHttpClient.addHandler(
        '/v1/catalogs/products',
        'GET',
        (request) async => Response(
            '{"products":[{"id":"PROD-41223692GT225981R","name":"test_product","'
            'description":"$_productDescription","create_time":"2021-09-21T17:13'
            ':54Z","links":[{"href":"https://api.sandbox.paypal.com/v1/catalogs/'
            'products/PROD-41223692GT225981R","rel":"self","method":"GET"}]}],"l'
            'inks":[{"href":"https://api.sandbox.paypal.com/v1/catalogs/products'
            '?page_size=10&page=1","rel":"self","method":"GET"}]}',
            HttpStatus.ok));

    mockHttpClient.addHandler(
        '/v1/catalogs/products',
        'POST',
        (request) async => Response(
            '{"id":"PROD-41223692GT225981R","name":"test_product","description":'
            '"test_description","create_time":"2021-09-21T17:13:54Z","links":[{"'
            'href":"https://api.sandbox.paypal.com/v1/catalogs/products/PROD-412'
            '23692GT225981R","rel":"self","method":"GET"}]}',
            HttpStatus.created));

    mockHttpClient.addHandler(
        '/v1/catalogs/products/PROD-41223692GT225981R',
        'GET',
        (request) async => Response(
            '{"id":"PROD-41223692GT225981R","name":"test_product","description":'
            '"$_productDescription","create_time":"2021-09-21T17:13:54Z","links"'
            ':[{"href":"https://api.sandbox.paypal.com/v1/catalogs/products/PROD'
            '-41223692GT225981R","rel":"self","method":"GET"}]}',
            HttpStatus.created));

    mockHttpClient
        .addHandler('/v1/catalogs/products/PROD-41223692GT225981R', 'PATCH',
            (request) async {
      var patches = jsonDecode(request.body);
      var patch = Patch.fromJson(patches.first);
      _productDescription = patch.value;
      return Response('', HttpStatus.noContent);
    });

    var paypalEnvironment = PayPalEnvironment.sandbox(
        clientId: 'clientId', clientSecret: 'clientSecret');
    _payPalHttpClient =
        PayPalHttpClient(paypalEnvironment, client: mockHttpClient);
  });

  test('Test list products', () async {
    var productsApi = CatalogProductsApi(_payPalHttpClient);
    var productsCollection = await productsApi.listProducts();
    expect(productsCollection is ProductCollection, true);
  });

  test('Test create product', () async {
    var productsApi = CatalogProductsApi(_payPalHttpClient);
    var product = await productsApi.createProduct(
        name: 'test_product',
        type: Product.typeDigital,
        description: 'test_description');

    expect(product is Product, true);
    expect(product.name, 'test_product');
    expect(product.description, 'test_description');
  });

  test('Test update product', () async {
    var productsApi = CatalogProductsApi(_payPalHttpClient);
    await productsApi.updateProduct('PROD-41223692GT225981R', [
      Patch(
          op: Patch.operationReplace,
          path: '/description',
          value: 'test_description_updated')
    ]);

    var product =
        await productsApi.showProductDetails('PROD-41223692GT225981R');
    expect(product.description, 'test_description_updated');

    await productsApi.updateProduct('PROD-41223692GT225981R', [
      Patch(
          op: Patch.operationReplace,
          path: '/description',
          value: 'test_description')
    ]);

    product = await productsApi.showProductDetails('PROD-41223692GT225981R');
    expect(product.description, 'test_description');
  });

  test('Test get product', () async {
    var productsApi = CatalogProductsApi(_payPalHttpClient);
    var product =
        await productsApi.showProductDetails('PROD-41223692GT225981R');
    expect(product.name, 'test_product');
    expect(product.description, 'test_description');
  });
}
