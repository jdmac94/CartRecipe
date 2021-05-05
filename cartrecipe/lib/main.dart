import 'package:cartrecipe/providers/products_data_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/tabs_screens.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
          '/': (ctx) => TabsScreen(0),
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
