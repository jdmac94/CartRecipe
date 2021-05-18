import 'package:cartrecipe/data/dummy_data.dart';
import 'package:cartrecipe/main.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:async';

import 'package:cartrecipe/models/product.dart';
import 'package:cartrecipe/models/recipe.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiWrapper {
  static ApiWrapper _instance;

  ApiWrapper._internal() {
    _instance = this;
  }

  factory ApiWrapper() => _instance ?? ApiWrapper._internal();

  final String endpoint = '9616b67d4dbf.ngrok.io'; //"158.109.74.46:55005";
  String authToken;

  //'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MGEyN2NjN2E0NDM0ZjAwMmZlOWRjYzAiLCJjb3JyZW8iOiJwZXBvQHBlcG8uZXMiLCJub21icmUiOiJQZXBlIiwiYWxlcmdpYXMiOltdLCJ0YWdzIjpbXSwibml2ZWxfY29jaW5hIjpudWxsLCJzaXN0ZW1hX3VuaWRhZGVzIjoic2lzdF9pbnQiLCJyZWNldGFzX2ZhdnMiOltdLCJpYXQiOjE2MjEyNjkyOTd9.2gG--BpwBRVhjcvtZeF32XK-Ikb7ghrydIetJXQLRqQ';
  //'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MGEyNzdlN2E0NDM0ZjAwMmZlOWRjYmUiLCJjb3JyZW8iOiJhQGdtYWlsLmNvbSIsIm5vbWJyZSI6IlRFU1QiLCJhbGVyZ2lhcyI6W10sInRhZ3MiOltdLCJuaXZlbF9jb2NpbmEiOm51bGwsInNpc3RlbWFfdW5pZGFkZXMiOiJzaXN0X2ludCIsInJlY2V0YXNfZmF2cyI6W10sImlhdCI6MTYyMTI2MDI2M30.32O2L1ODNUf0szphfcOz_EshqTWhAOPS-CANjzxttbk';
  // 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MDhlYzR' +
  //     'jNTc5MWNjNDAwMmE5YzQwNzIiLCJjb3JyZW8iOiJhbmRyZXNAYml0dG8uY' +
  //     '29tIiwibm9tYnJlIjoiYWFhYSIsImFsZXJnaWFzIjpbXSwiZGlldGEiOltd' +
  //     'LCJ0YWdzIjpbXSwibml2ZWxfY29jaW5hIjpudWxsLCJzaXN0ZW1hX3VuaWRh' +
  //     'ZGVzIjoic2lzdF9pbnQiLCJyZWNldGFzX2ZhdnMiOltdLCJpYXQiOjE2MTk5Nj' +
  //     'kyMjF9.1QibofC5JV1krjcnWCc7rLYPFzfDLSukVPIetEvC0Aw';
  //final String endpoint = "a1ac68965a1d.ngrok.io";

  Future<List<Product>> getFridgeProducts() async {
    const String api = "api/v1/nevera";
    final response = await http.get(
      Uri.http(endpoint, api),
      headers: <String, String>{
        'x-auth-token': authToken,
      },
    );

    String temp = getAuthToken();

    print('El token recuperdao con el get en la API es $temp');

    print("Pido por nevera y miramos si el token está bien: $authToken");

    if (response.statusCode == 200) {
      print('StatusCode 200 - Todo OK');

      List<Product> prods = [];

      Iterable l = json.decode(response.body);
      prods = List<Product>.from(l.map((model) => Product.fromJson(model)));

      print('Esto lleva el primer producto Juanda: ');
      print(prods.toString());

      return prods;
    } else {
      print('La petición de los productos la nevera ha sido rechazada');
      //TODO CONTROLAR DUMMY
      //return DUMMY_PRODUCTS;
      //throw Exception('Failed to load product');
    }
  }

  void setAuthToken(token) {
    authToken = token;
    print('Token creado el api wrapper:  $authToken');
  }

  String getAuthToken() {
    return authToken;
  }

  Future<String> logInUsuario(String email, String password) async {
    var api = '/api/v1/auth/login';
    var bytes = utf8.encode(password);
    var hashpassword = sha256.convert(bytes);

    print('Email $email');
    print('Password Hash $hashpassword');
    print('Password  $password');
    http.Response response = await http.post(
      Uri.http(endpoint, api),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'correo': email,
        'password': hashpassword.toString(),
      }),
    );

    if (response.statusCode == 200) {
      print("todo bien");
      print(response.body.toString());
      var token = response.body.toString();
      print('token:$token');
      return token;
    } else if (response.statusCode == 404) {
      print('Error 404 No existe Usuario');
      return "404";
    } else if (response.statusCode == 460) {
      print('Error 460 Contraseña mal');
      return "460";
    } else {
      print(response.statusCode.toString());
      print(response.body.toString());
      return "Error";
    }
  }

  Future<String> registrarUsuario(
      String nombre, String apellido, String email, String password) async {
    var api = '/api/v1/auth/register';
    var bytes = utf8.encode(password);
    var hashpassword = sha256.convert(bytes);
    print('Name + App $nombre$apellido');
    print('Email $email');
    print('Password Hash $hashpassword');
    print('Password  $password');
    http.Response response = await http.post(
      Uri.http(endpoint, api),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'nombre': nombre,
        'apellido': apellido,
        'correo': email,
        'password': hashpassword.toString(),
      }),
    );

    if (response.statusCode == 200) {
      print("usuario registrado");
      print(response.body.toString());
      var token = response.body.toString();
      print('token:$token');
      return token;
    } else if (response.statusCode == 461) {
      print('Error 461 email ya existe');
      return "461";
    } else if (response.statusCode == 462) {
      print('Error 462 email mal formateado');
      return "462";
    } else if (response.statusCode == 463) {
      print('Error 463 password mal formateado');
      return "463";
    } else if (response.statusCode == 464) {
      print('Error 464 enombre y apellido mal formateado');
      return "464";
    } else {
      print(response.statusCode.toString());
      print(response.body.toString());
      return "Error";
    }
  }

  Future<Product> addProduct(String barcode) async {
    var api = '/api/v1/nevera/product/$barcode';

    print('Codigo es $barcode');
    print('Barcode es string $barcode' is String);

    print("Token al añadir producto $authToken");
    //var uri = Uri.http(endpoint, api);

    http.Response response = await http.put(
      Uri.http(endpoint, api),
      headers: <String, String>{
        //'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': authToken,
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

  Future<String> deleteUser(String reason) async {
    var api = "/api/v1/accSettings/$reason/";

    http.Response response = await http.put(Uri.http(endpoint, api),
        headers: <String, String>{
          //'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': authToken,
        },
        body: jsonEncode(
          <String, String>{
            'reason': reason,
          },
        ));
  }

  //TODO! TRY CATCH TO GUAPO
  Future<void> deleteAndreh(List<String> barcode) async {
    var api = 'api/v1/nevera/product';

    http.Response response = await http.delete(
      Uri.http(endpoint, api),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': authToken,
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

  Future<void> clearNevera() async {
    const String api = "api/v1/nevera";

    http.Response response = await http.delete(
      Uri.http(endpoint, api),
      headers: <String, String>{
        'x-auth-token': authToken,
      },
    );

    print(response.statusCode);
    if (response.statusCode == 200) {
      print("Se ha vaciado la nevera");
      print(response.body.toString());
    } else {
      print('Peta borrar todo ${response.statusCode}');
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
      /*
      recipeList = (json.decode(response.body) as List)
          .map((i) => Recipe.fromJson(i))
          .toList();
*/
      recipeList = List<Recipe>.from(
          json.decode(response.body).map((x) => Recipe.fromJson(x)));
      //Iterable i = json.decode(response.body);
      //recipeList = List<Recipe>.from(i.map((model) => Recipe.fromJson(model)));
    } else {
      print("Did not receive correctly recipe list");
    }

    if (recipeList.isEmpty) {
      print('No he recibido nada');
      /*var r = Recipe(
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
      */
    }
    return recipeList;
  }
}
