import 'package:cartrecipe/providers/products_data_provider.dart';
import 'package:cartrecipe/screens/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/tabs_screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //prefs?.setBool("isLoggedIn", false);
  var status = prefs.getBool('isLoggedIn') ?? false;
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
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          accentColor: Colors.amberAccent,
        ),
        initialRoute: '/',
        routes: {
          '/': (ctx) => status == false ? Welcome() : TabsScreen(0),
        },
      ),
      providers: [
        FutureProvider<ProductsDataProvider>(
            initialData: ProductsDataProvider(productList: []),
            create: (context) => ProductsDataProvider().providerWithData()),
      ],
    );
  }
}
