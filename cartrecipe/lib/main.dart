import 'package:cartrecipe/api/api_wrapper.dart';
import 'package:cartrecipe/providers/products_data_provider.dart';
import 'package:cartrecipe/screens/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/tabs_screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  SharedPreferences token = await SharedPreferences.getInstance();
  //prefs.setBool("isLoggedIn", true); // Forzar login, se puede eliminar
  //prefs?.setBool("isLoggedIn", false);
  var status = prefs.getBool('isLoggedIn') ?? false;

  String tokenString = token.getString('token');
  if (status) {
    ApiWrapper().setAuthToken(tokenString);
    print('El token recuperado es al tener sesisón es $tokenString');
  }

  print(status);
  runApp(MyApp(status));
} /*=> runApp(MyApp());*/

class MyApp extends StatelessWidget {
  MyApp(this.status);

  final status;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: MaterialApp(
        title: 'CartRecipe',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          accentColor: Colors.amberAccent,
          highlightColor: Colors.deepPurple,
        ),
        initialRoute: '/',
        routes: {
          '/': (ctx) => status == false ? Welcome() : TabsScreen(0),
        },
      ),
      providers: [
        FutureProvider<ProductsDataProvider>(
            initialData:
                ProductsDataProvider(productList: [], isFetching: false),
            create: (context) => ProductsDataProvider().providerWithData()),
      ],
    );
  }
}
