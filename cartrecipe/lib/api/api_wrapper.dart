import 'package:cartrecipe/data/dummy_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:cartrecipe/models/product.dart';

class ApiWrapper {
  final String endpoint = "158.109.74.46:55005";

  Future getFridgeProducts() async {
    const String api = "api/v1/nevera/getNeveraList";
    final response = await http.get(Uri.http(endpoint, api));
    if (response.statusCode == 200) {
      print('Recibida la respuesta de la petición');

      List<Product> prods = [];

      Iterable l = json.decode(response.body);
      prods = List<Product>.from(l.map((model) => Product.fromJson(model)));

      //print(prods);

      return prods;
    } else {
      print('Petición de respuesta');
      return DUMMY_PRODUCTS;
      //throw Exception('Failed to load product');
    }
  }

  void addProduct(String barcode) async {
    var api = '/api/v1/nevera/addToNevera';

    print('Codigo es $barcode');
    print('Barcode es string $barcode' is String);
    //var uri = Uri.http(endpoint, api);

    http.Response response = await http.put(
      Uri.http(endpoint, api),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'barcode': barcode,
      }),
    );

    print(jsonEncode(<String, String>{
      'barcode': barcode,
    }));

    print('Body: ${response.body.toString()}');

    if (response.statusCode == 200)
      print('Recibido bien');
    else
      print('F');
  }

  //TODO! TRY CATCH TO GUAPO
  void deleteAndreh(List<String> barcode) async {
    var api = 'api/v1/nevera/deleteNevera';

    http.Response response = await http.delete(
      Uri.http(endpoint, api),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, List<String>>{
        'toDeleteArr': barcode,
      }),
    );

    print('Body: ${response.statusCode}');

    if (response.statusCode == 200)
      print('Recibido bien');
    else
      print('F');
  }

  void clearNevera() async {
    const String api = "api/v1/nevera/clearNevera";

    http.Response response = await http.delete(Uri.http(endpoint, api));
    print(response.statusCode);
    if (response.statusCode == 200) {
      print("Se ha vaciado la nevera");
      print(response.body.toString());
    } else {
      throw Exception('Failed to empty fridge');
    }
  }
}
