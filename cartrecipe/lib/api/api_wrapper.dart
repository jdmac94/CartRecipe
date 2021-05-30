import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:async';

import 'package:cartrecipe/models/product.dart';
import 'package:cartrecipe/models/recipe.dart';

class ApiWrapper {
  static ApiWrapper _instance;

  ApiWrapper._internal() {
    _instance = this;
  }

  factory ApiWrapper() => _instance ?? ApiWrapper._internal();

  final String endpoint = //"158.109.74.46:55005";
      "3587b861185a.ngrok.io";

  String authToken;

  Future<List<Product>> getBusqueda(search) async {
    String api = "api/v2/search/products/" + search.toString();

    http.Response response =
        await http.get(Uri.http(endpoint, api), headers: <String, String>{
      'x-auth-token': authToken,
    });

    if (response.statusCode == 200) {
      print("Received correctly product list.");
      print(response.body);
      List<Product> prods = [];

      Iterable l = json.decode(response.body);
      prods = List<Product>.from(l.map((model) => Product.fromJson(model)));
      print(prods.toString());
      return prods;
    } else if (response.statusCode == 404) {
      print('Not found 404');
      return null;
    } else {
      print('F busqueda');
      return null;
    }
  }

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

  Future<void> deleteUser() async {
    var api = "/api/v1/accSettings/deleteAccount/";

    http.Response response = await http.delete(
      Uri.http(endpoint, api),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': authToken,
      },
    );

    if (response.statusCode == 200) {
      print('Eliminado correctamente');
      return "Eliminado";
    } else if (response.statusCode == 400) {
      print('Error 400 del Delete');
      return "Error";
    } else if (response.statusCode == 404) {
      print('Error 404 del Delete');
      return "Error";
    }
  }

  Future<void> saveReason(String reason) async {
    var api = "/api/v1/accSettings/deleteAccountMotive/";

    http.Response response = await http.post(Uri.http(endpoint, api),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, String>{
            'motivo': reason,
          },
        ));
    if (response.statusCode == 200) {
      print('Guardado correctamente');
      return "Guardado";
    } else if (response.statusCode == 400) {
      return "Error";
    }
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

    List<Recipe> recipeList = [];
    //TODO: Recipe filtering - later
    http.Response response =
        await http.get(Uri.http(endpoint, api), headers: <String, String>{
      'x-auth-token': authToken,
    });

    if (response.statusCode == 200) {
      print("Received correctly recipe list.");

      recipeList = await List<Recipe>.from(
          json.decode(response.body).map((x) => Recipe.fromJson(x)));
      //Iterable i = json.decode(response.body);
      //recipeList = List<Recipe>.from(i.map((model) => Recipe.fromJson(model)));
    } else {
      print("Did not receive correctly recipe list");
    }

    if (recipeList.isEmpty) {
      print('No he recibido nada');
    }
    return recipeList;
  }

  Future<String> modifyProfile(String nombre, String apellido,
      String oldPassword, String newPassword) async {
    var api = "/api/v1/accSettings/modIdFields/";

    var bytesOldPass = utf8.encode(oldPassword);
    var hashOldPass = sha256.convert(bytesOldPass);

    var bytesNewPass = utf8.encode(newPassword);
    var hashNewPass = sha256.convert(bytesNewPass);

    print('Name + App $nombre$apellido');
    print('Password Hash $hashOldPass');
    print('Old Password  $oldPassword');
    print('New Password  $newPassword');

    http.Response response = await http.put(
      Uri.http(endpoint, api),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': authToken,
      },
      body: jsonEncode(<String, String>{
        'nombre': nombre,
        'apellido': apellido,
        'old_password': hashOldPass.toString(),
        'password': hashNewPass.toString(),
      }),
    );

    if (response.statusCode == 200) {
      print("Mofificación de datos completada");
      print(response.body.toString());
      return '200';
    } else if (response.statusCode == 460) {
      print('Error 460 contraseña errónea');
      return "460";
    } else {
      print(response.statusCode.toString());
      print(response.body.toString());
      return "Error";
    }
  }

  Future<void> fillPreferences(
      bool is_vegan,
      bool is_vegetarian,
      List<String> allergenArray,
      int level,
      List<String> tags,
      List<String> ban) async {
    var api = 'api/v1/accSettings/fillPreferences';

    http.Response response = await http.post(
      Uri.http(endpoint, api),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': authToken,
      },
      body: jsonEncode(<String, dynamic>{
        'is_vegan': is_vegan,
        'is_vegetarian': is_vegetarian,
        'allergenArray': allergenArray,
        'level': level,
        'tagArray': tags,
        'banArray': ban
      }),
    );

    print('Body: ${response.statusCode}');

    if (response.statusCode == 200)
      print('Recibido bien');
    else
      print('No he recibido preferencias');
  }

  Future<void> modAlergias(List<String> allergenArray) async {
    var api = 'api/v1/accSettings/modAlergias';

    http.Response response = await http.post(
      Uri.http(endpoint, api),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': authToken,
      },
      body: jsonEncode(<String, List<String>>{
        'allergenArray': allergenArray,
      }),
    );
    print('Body: ${response.statusCode}');

    if (response.statusCode == 200)
      print('Recibido bien');
    else
      print('F');
  }

  Future<void> modDieta(bool isVegan, bool isVegetarian) async {
    var api = 'api/v1/accSettings/modDieta';

    http.Response response = await http.post(
      Uri.http(endpoint, api),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': authToken,
      },
      body: jsonEncode(<String, bool>{
        'is_vegan': isVegan,
        'is_vegetarian': isVegetarian,
      }),
    );
    print('Body: ${response.statusCode}');

    if (response.statusCode == 200)
      print('Recibido bien');
    else
      print('F');
  }

  Future<void> modNivel(int level) async {
    var api = 'api/v1/accSettings/modNivel';

    http.Response response = await http.post(
      Uri.http(endpoint, api),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': authToken,
      },
      body: jsonEncode(<String, int>{
        'level': level,
      }),
    );
    print("${response}");
    print('Body: ${response.statusCode}');

    if (response.statusCode == 200)
      print('Recibido bien');
    else
      print('F');
  }

  Future<void> modTags(List<String> tags) async {
    var api = 'api/v1/accSettings/modNivel';

    http.Response response = await http.post(
      Uri.http(endpoint, api),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': authToken,
      },
      body: jsonEncode(<String, List<String>>{
        'tagArray': tags,
      }),
    );
    print("${response}");
    print('Body: ${response.statusCode}');

    if (response.statusCode == 200)
      print('Recibido bien');
    else
      print('F');
  }

  Future<void> modBanned(List<String> ban) async {
    var api = 'api/v1/accSettings/modNivel';

    http.Response response = await http.post(
      Uri.http(endpoint, api),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': authToken,
      },
      body: jsonEncode(<String, List<String>>{'banArray': ban}),
    );
    print("${response}");
    print('Body: ${response.statusCode}');

    if (response.statusCode == 200)
      print('Recibido bien');
    else
      print('F');
  }

  Future<void> modificaSistemaUnidades(bool metricUnit) async {
    var api = "api/v1/accSettings/modSistemaMedida";
    http.Response response = await http.post(Uri.http(endpoint, api),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': authToken,
        },
        body: jsonEncode(<String, String>{
          'sistema_unidades': metricUnit.toString(),
        }));
    print(response.body);
    authToken = response.body.toString();
    print('Received response ' + '${response.statusCode}');
    if (response.statusCode == 200) {
      print('Received correctly');
    } else {
      print('Found a status code different than 200');
    }
  }

  Future<List<String>> getGenericIngredients() async {
    const String api = "api/v1/accSettings/getGenericIngredients";
    List<String> prods = [];
    final response = await http.get(
      Uri.http(endpoint, api),
      headers: <String, String>{
        'x-auth-token': authToken,
      },
    );
    if (response.statusCode == 200) {
      print('ha llegado!!!!');
      prods = List<String>.from(json.decode(response.body));
    } else {
      print(response.body);
      print(response.statusCode);
    }
    return prods;
  }

  Future<void> createOwnRecipe(Recipe receta) async {
    const String api = "api/v1/receta/addReceta";

    print(receta.dificultad.toString());

    http.Response response = await http.post(Uri.http(endpoint, api),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': authToken,
        },
        body: jsonEncode(<String, String>{
          'titulo': receta.titulo,
          'dificultad': receta.dificultad.toString(),
          'tiempo': receta.tiempo,
          'ingredientes': receta.ingredientes.toString(),
          'pasos': receta.pasos.toString(),
          'consejos': receta.consejos.toString(),
          'imagenes': receta.imagenes.toString(),
          'comensales': receta.comensales.toString(),
          'tags': receta.tags.toString(),
        }));

    if (response.statusCode == 200) {
      print('Receta enviada correctamente');
    } else {
      print(response.statusCode);
      print(response.body);
    }
  }

  /*  Future<void> modificaSistemaUnidades(bool metricUnit) async {
    var api = "api/v1/accSettings/modSistemaMedida";
    http.Response response = await http.post(Uri.http(endpoint, api),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': authToken,
        },
        body: jsonEncode(<String, String>{
          'sistema_unidades': metricUnit.toString(),
        }));
    print(response.body);
    authToken = response.body.toString();
    print('Received response ' + '${response.statusCode}');
    if (response.statusCode == 200) {
      print('Received correctly');
    } else {
      print('Found a status code different than 200');
    }
  } */
  Future<Map<String, dynamic>> getPreferences() async {
    const String api = "api/v1/accSettings/getPreferences";
    Map<String, dynamic> preferences = {};
    final response = await http.get(
      Uri.http(endpoint, api),
      headers: <String, String>{
        'x-auth-token': authToken,
      },
    );
    if (response.statusCode == 200) {
      print('ha llegado!!!!');
      preferences = Map<String, dynamic>.from(json.decode(response.body));
    } else {
      print(response.body);
      print(response.statusCode);
    }
    return preferences;
  }
}
