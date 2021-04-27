import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:cartrecipe/models/product.dart';

class ApiWrapper {
  final String endpoint = "158.109.74.46:55005";

  Future<List<Product>> getFridgeProducts() async {
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
      //throw Exception('Failed to load product');
    }
  }

  //TODO! REVISAR PORQUE PETA MUY FUERTE (undefined al recibirlo en back)
  void deleteProduct(List<String> productsToBeDeleted) async {
    const String api = "api/v1/nevera/deleteNevera";

    Map<String, List<String>> parameters = Map<String, List<String>>();
    parameters['toDeleteArr'] = productsToBeDeleted;

    print(parameters is Map<String, List<String>>);
    //print(parameters);
    print([productsToBeDeleted] is List<String>);

    print('Parámetros: $parameters');

    http.Response response =
        await http.post(Uri.http(endpoint, api), body: jsonEncode(parameters));

    print(response.body);
    //print([barcode]);
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      List<Product> prods = [];

      Iterable l = json.decode(response.body);
      prods = List<Product>.from(l.map((model) => Product.fromJson(model)));

      print('Entro aquí si es bien $prods');
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      //throw Exception('Failed to load product');
    }
  }

  void addProduct(String barcode) async {
    const String api = "api/v1/nevera/addToNevera";
  }

  ///addToNevera
}
