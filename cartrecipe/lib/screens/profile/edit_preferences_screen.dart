import 'package:cartrecipe/screens/profile/editing_preferences_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class EditPreferencesScreen extends StatefulWidget {
  const EditPreferencesScreen({Key key}) : super(key: key);
  @override
  State<EditPreferencesScreen> createState() => _EditPreferencesScreen();
  int get getPantalla => _EditPreferencesScreen().getPantalla;
}

class _EditPreferencesScreen extends State<EditPreferencesScreen> {
  int pantalla;
  int get getPantalla {
    return pantalla;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preferencias'),
      ),
      body: Center(
        child: ListView(
          children: ListTile.divideTiles(context: context, tiles: [
            ListTile(
              leading: Icon(Icons.set_meal),
              title: RichText(
                  text: TextSpan(children: <TextSpan>[
                TextSpan(
                    text: 'Alergias e intolerancias',
                    style: TextStyle(color: Colors.black),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EdittingPreferencesScreen(0)));
                      })
              ])),
            ),
            ListTile(
              leading: Icon(Icons.no_food),
              title: RichText(
                  text: TextSpan(children: <TextSpan>[
                TextSpan(
                    text: 'Dieta',
                    style: TextStyle(color: Colors.black),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EdittingPreferencesScreen(1)));
                      })
              ])),
            ),
            ListTile(
              leading: Icon(Icons.dinner_dining),
              title: RichText(
                  text: TextSpan(children: <TextSpan>[
                TextSpan(
                    text: 'Nivel de cocina',
                    style: TextStyle(color: Colors.black),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EdittingPreferencesScreen(2)));
                      })
              ])),
            ),
            ListTile(
              leading: Icon(Icons.dinner_dining),
              title: RichText(
                  text: TextSpan(children: <TextSpan>[
                TextSpan(
                    text: 'Tipos de recetas que busco',
                    style: TextStyle(color: Colors.black),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EdittingPreferencesScreen(3)));
                      })
              ])),
            ),
            ListTile(
              leading: Icon(Icons.dinner_dining),
              title: RichText(
                  text: TextSpan(children: <TextSpan>[
                TextSpan(
                    text: 'Ingredientes que no me gustan',
                    style: TextStyle(color: Colors.black),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EdittingPreferencesScreen(4)));
                      })
              ])),
            ),
          ]).toList(),
        ),
      ),
    );
  }
}
