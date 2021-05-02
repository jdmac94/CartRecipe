import 'package:cartrecipe/data/dummy_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:cartrecipe/models/product.dart';

class ApiWrapper {
  final String endpoint = "158.109.74.46:55005";
  final String authToken =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MDhlYzR' +
          'jNTc5MWNjNDAwMmE5YzQwNzIiLCJjb3JyZW8iOiJhbmRyZXNAYml0dG8uY' +
          '29tIiwibm9tYnJlIjoiYWFhYSIsImFsZXJnaWFzIjpbXSwiZGlldGEiOltd' +
          'LCJ0YWdzIjpbXSwibml2ZWxfY29jaW5hIjpudWxsLCJzaXN0ZW1hX3VuaWRh' +
          'ZGVzIjoic2lzdF9pbnQiLCJyZWNldGFzX2ZhdnMiOltdLCJpYXQiOjE2MTk5Nj' +
          'kyMjF9.1QibofC5JV1krjcnWCc7rLYPFzfDLSukVPIetEvC0Aw';
  //final String endpoint = "a1ac68965a1d.ngrok.io";

  Future<List<Product>> getFridgeProducts() async {
    const String api = "api/v1/nevera/list";
    final response = await http.get(
      Uri.http(endpoint, api),
      headers: <String, String>{
        'x-auth-token': authToken
        //'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MDhiZTh
        //lN2IyYjM3YTAwZjgwMTYyOTMiLCJhbGVyZ2lhcyI6W10sImRpZXRhIjpb
        //XSwidGFncyI6W10sIm5pdmVsX2NvY2luYSI6bnVsbCwic2lzdGVtYV91b
        //mlkYWRlcyI6InNpc3RfaW50IiwicmVjZXRhc19mYXZzIjpbXSwiaWF0Ij
        //oxNjE5NzgxODYzfQ.aSAmFeibWYrdDvNh9-kV1bCFtAiBMkp5MQJM4qi4zGk'
      },
    );
    if (response.statusCode == 200) {
      print('StatusCode 200 - Todo OK');

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

  Future<Product> addProduct(String barcode) async {
    var api = '/api/v1/nevera/product/$barcode';

    print('Codigo es $barcode');
    print('Barcode es string $barcode' is String);
    //var uri = Uri.http(endpoint, api);

    http.Response response = await http.put(
      Uri.http(endpoint, api),
      headers: <String, String>{
        //'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': authToken
        //'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MDhiZThlN2IyYjM3YTAwZjgwMTYyOTMiLCJhbGVyZ2lhcyI6W10sImRpZXRhIjpbXSwidGFncyI6W10sIm5pdmVsX2NvY2luYSI6bnVsbCwic2lzdGVtYV91bmlkYWRlcyI6InNpc3RfaW50IiwicmVjZXRhc19mYXZzIjpbXSwiaWF0IjoxNjE5NzgxODYzfQ.aSAmFeibWYrdDvNh9-kV1bCFtAiBMkp5MQJM4qi4zGk'
      },
      // body: jsonEncode(<String, String>{
      //   'barcode': barcode,
      // },
    );

    // print('Esto obtengo al añadir');
    // print(json.decode(response.body));

    // print(jsonEncode(<String, String>{
    //   'barcode': barcode,
    // }));

    print('Body: ${response.body.toString()}');

    if (response.statusCode == 200) {
      print('Recibido bien al añadir');
      print('Esto obtengo al añadir');
      print(json.decode(response.body));

      Map<String, dynamic> map = json.decode(response.body);

      print("Imprimo MAP de añadir:  $map");

      Product prod = Product.fromJson(map);

      //Iterable l = json.decode(response.body);
      //prods = List<Product>.from(l.map((model) => Product.fromJson(model)));

      print('Producto generado es: ${prod}');

      return prod;
    } else
      print('F');
  }

  //TODO! TRY CATCH TO GUAPO
  void deleteAndreh(List<String> barcode) async {
    var api = 'api/v1/nevera/product';

    http.Response response = await http.delete(
      Uri.http(endpoint, api),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': authToken
        //'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MDhiZThlN2IyYjM3YTAwZjgwMTYyOTMiLCJhbGVyZ2lhcyI6W10sImRpZXRhIjpbXSwidGFncyI6W10sIm5pdmVsX2NvY2luYSI6bnVsbCwic2lzdGVtYV91bmlkYWRlcyI6InNpc3RfaW50IiwicmVjZXRhc19mYXZzIjpbXSwiaWF0IjoxNjE5NzgxODYzfQ.aSAmFeibWYrdDvNh9-kV1bCFtAiBMkp5MQJM4qi4zGk',
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
