import 'package:cartrecipe/desperate/products_data_provider.dart';
import 'package:cartrecipe/models/product.dart';
import 'package:cartrecipe/providers/product_list_provider.dart';
import 'package:cartrecipe/providers/product_provider.dart';
import 'package:cartrecipe/providers/stream_provider.dart';

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
        FutureProvider<ProductList>(
          initialData: ProductList(listaProductos: []),
          create: (context) => ProductList().loadProductsData(),
        ),
        FutureProvider<ProductProvider>(
          initialData: ProductProvider(),
          create: (context) => ProductProvider().loadProviderData(),
        ),
        StreamProvider<List<Product>>(
          initialData: [],
          create: (context) => DataProvider().fetchData(),
        ),
        FutureProvider<ProductsDataProvider>(
            initialData: ProductsDataProvider(productList: []),
            create: (context) => ProductsDataProvider().providerWithData()),
      ],
    );
  }
}
