import 'package:flutter/material.dart';

import 'screens/tabs_screens.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CartRecipe',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.amberAccent,
      ),
      initialRoute: '/',
      routes: {
        '/': (ctx) => TabsScreen(),
      },
    );
  }
}
