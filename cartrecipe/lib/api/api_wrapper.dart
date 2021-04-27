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
    const String api = "api/v1/nevera/deleteNeveraInt";

    // print("Estamos en el deleteProduct de la API");
    // productsToBeDeleted.forEach((element) {
    //   element = '\"' + element + '\"';
    //   print(element);
    // });
    //
    //String allProducts = productsToBeDeleted[0];

    //print('Todo en uno: $allProducts');

    // for (int i = 1; i < productsToBeDeleted.length; i++) {
    //   allProducts += ',' + productsToBeDeleted[i];
    // }

    //print('Todo en uno: $allProducts');

    //print('test con comillas $productsToBeDeleted');
    //
    //
    // List<int> integers = [];
    // productsToBeDeleted.forEach((element) {
    //   //element = '\"' + element + '\"';
    //   integers.add(int.parse(element));
    // });

    // Map<String, List<String>> parameters = Map<String, List<String>>();
    // parameters['toDeleteArr'] = productsToBeDeleted;
    //
    Map<String, List<String>> parameters = Map<String, List<String>>();
    parameters['toDeleteArr'] = productsToBeDeleted;

    print(parameters is Map<String, List<String>>);
    //print(parameters);
    print([productsToBeDeleted] is List<String>);

    print('Parámetros: $parameters');

    var encodedBody = json.encode(parameters);
    print('Encoded json: -- $encodedBody');

    http.Response request = await http.post(
      Uri.http(endpoint, api),
      body: encodedBody,
      encoding: Encoding.getByName("application/json"),
    );

    print(request.body);
    //print([barcode]);
    if (request.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      List<Product> prods = [];

      Iterable l = json.decode(request.body);
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
    var uri = Uri.http(endpoint, api);

    String parameters = barcode;

    print('URI: $uri');
    print('Parámetros añadir: $parameters');

    var encodedBody = json.encode(parameters);
    print('Encoded json: -- $encodedBody');

    http.Response response = await http.post(
      uri,
      body: encodedBody,
      encoding: Encoding.getByName('application/json'),
    );

    print('Response');

    print(response.body.toString());

    if (response.statusCode == 200) {
      print('Recibido bien');
    } else {
      print('Status code: ${response.statusCode}');
      print('Recibido mal');
    }
  }

  void deleteSingleProduct(String barcode) async {
    //TODO CAMBIAR
    var api = 'api/v1/nevera/deleteNeveraSingle';
    var uri = Uri.http(endpoint, api);
    Map<String, String> parameters = Map<String, String>();
    parameters["toDeleteArr"] = barcode;

    print('URI: $uri');
    print('Parámetros single: $parameters');

    var encodedBody = json.encode(parameters);

    print('Encoded json: -- $encodedBody');

    http.Response response = await http.post(
      uri,
      body: encodedBody,
      encoding: Encoding.getByName('application/json'),
    );

    print('TODO response');

    print(response.body.toString());

    if (response.statusCode == 200) {
      print('Recibido bien');
    } else {
      print('Status code: ${response.statusCode}');
      print('Recibido mal');
    }
  }

  void printJson(String input) {
    const JsonDecoder decoder = JsonDecoder();
    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    final dynamic object = decoder.convert(input);
    final dynamic prettyString = encoder.convert(object);
    prettyString.split('\n').forEach((dynamic element) => print(element));
  }
}
