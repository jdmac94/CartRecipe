import 'package:cartrecipe/data/dummy_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:cartrecipe/models/product.dart';
import 'package:cartrecipe/models/recipe.dart';

class ApiWrapper {
  final String endpoint = "158.109.74.46:55005";
  //final String endpoint = "a1ac68965a1d.ngrok.io";

  Future<List<Product>> getFridgeProducts() async {
    const String api = "api/v1/nevera/list";
    final response = await http.get(
      Uri.http(endpoint, api),
      headers: <String, String>{
        'x-auth-token':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MDhiZThlN2IyYjM3YTAwZjgwMTYyOTMiLCJhbGVyZ2lhcyI6W10sImRpZXRhIjpbXSwidGFncyI6W10sIm5pdmVsX2NvY2luYSI6bnVsbCwic2lzdGVtYV91bmlkYWRlcyI6InNpc3RfaW50IiwicmVjZXRhc19mYXZzIjpbXSwiaWF0IjoxNjE5NzgxODYzfQ.aSAmFeibWYrdDvNh9-kV1bCFtAiBMkp5MQJM4qi4zGk'
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
        'x-auth-token':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MDhiZThlN2IyYjM3YTAwZjgwMTYyOTMiLCJhbGVyZ2lhcyI6W10sImRpZXRhIjpbXSwidGFncyI6W10sIm5pdmVsX2NvY2luYSI6bnVsbCwic2lzdGVtYV91bmlkYWRlcyI6InNpc3RfaW50IiwicmVjZXRhc19mYXZzIjpbXSwiaWF0IjoxNjE5NzgxODYzfQ.aSAmFeibWYrdDvNh9-kV1bCFtAiBMkp5MQJM4qi4zGk'
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
        'x-auth-token':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MDhiZThlN2IyYjM3YTAwZjgwMTYyOTMiLCJhbGVyZ2lhcyI6W10sImRpZXRhIjpbXSwidGFncyI6W10sIm5pdmVsX2NvY2luYSI6bnVsbCwic2lzdGVtYV91bmlkYWRlcyI6InNpc3RfaW50IiwicmVjZXRhc19mYXZzIjpbXSwiaWF0IjoxNjE5NzgxODYzfQ.aSAmFeibWYrdDvNh9-kV1bCFtAiBMkp5MQJM4qi4zGk',
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

  Future<List<Recipe>> getRecipeList() async {
    const String api = "api/v1/receta/getAllRecetas";
    //Currently using  generated auth token
    final auth =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MDhiZThlN2IyYjM3YTAwZjgwMTYyOTMiLCJhbGVyZ2lhcyI6W10sImRpZXRhIjpbXSwidGFncyI6W10sIm5pdmVsX2NvY2luYSI6bnVsbCwic2lzdGVtYV91bmlkYWRlcyI6InNpc3RfaW50IiwicmVjZXRhc19mYXZzIjpbXSwiaWF0IjoxNjE5NzgxODYzfQ.aSAmFeibWYrdDvNh9-kV1bCFtAiBMkp5MQJM4qi4zGk";

    List<Recipe> recipeList = [];
    //TODO: Recipe filtering - later
    http.Response response =
        await http.get(Uri.http(endpoint, api), headers: <String, String>{
      'x-auth-token': auth,
    });

    if (response.statusCode == 200) {
      print("Received correctly recipe list.");
      print(response.body);
      recipeList = (json.decode(response.body) as List)
          .map((i) => Recipe.fromJson(i))
          .toList();

      //Iterable i = json.decode(response.body);
      //recipeList = List<Recipe>.from(i.map((model) => Recipe.fromJson(model)));
    } else {
      print("Did not receive correctly recipe list");
    }

    if (recipeList.isEmpty) {
      print('No he recibido nada');
      var r = Recipe(
        id: '0',
        user: 'Patata2000',
        recipeName: 'Patatas',
        difficulty: 4,
        ingredients: [
          IngredienteReceta(nombre: 'Patatas', cantidad: 2),
          IngredienteReceta(
            nombre: 'Huevos',
            cantidad: 6,
          ),
          IngredienteReceta(
            nombre: 'Cebolla',
            cantidad: 3,
          ),
          IngredienteReceta(
            nombre: 'Sal',
            cantidad: 1,
          ),
        ],
        //ingredients: ['Patatas':2, 'Huevos':3, 'Cebolla':6, 'Sal':7],
        time: '6:00',
        image:
            'https://media.sproutsocial.com/uploads/2017/02/10x-featured-social-media-image-size.png',
        steps: [
          'Coger patata',
          'Pelar patata',
          'Cocinar patata',
          'a',
          'a',
          'a'
        ],
        tips: ['No tirar la patata al suelo'],
      );

      recipeList = [r, r, r, r, r, r]; // Until we receive data
    }
    return recipeList;
  }
}
