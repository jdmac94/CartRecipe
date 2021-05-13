import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:cartrecipe/screens/profile/preferences_screen.dart';
import 'package:cartrecipe/screens/profile/edit_profile_screen.dart';
import 'package:cartrecipe/screens/profile/contact_screen.dart';
import 'package:cartrecipe/screens/profile/legal_screen.dart';
import 'package:cartrecipe/screens/profile/about_us_screen.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: ListTile.divideTiles(context: context, tiles: [
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('<Nombre del usuario>'),
              subtitle: RichText(
                  text: TextSpan(children: <TextSpan>[
                TextSpan(
                    text: 'Editar usuario',
                    style: TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfileScreen()));
                      })
              ])),
            ),
            ListTile(
              leading: Icon(Icons.food_bank),
              title: RichText(
                  text: TextSpan(children: <TextSpan>[
                TextSpan(
                    text: 'Preferencias alimenticias',
                    style: TextStyle(color: Colors.black),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PreferencesScreen()));
                      })
              ])),
            ),
            ListTile(
              leading: Icon(Icons.tune),
              title: Text('Unidades de medida'),
            ),
            ListTile(
              leading: Icon(Icons.translate),
              title: Text('Idioma'),
            ),
            ListTile(
              leading: Icon(Icons.call),
              title: RichText(
                  text: TextSpan(children: <TextSpan>[
                TextSpan(
                    text: 'Contacto',
                    style: TextStyle(color: Colors.black),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ContactScreen()));
                      })
              ])),
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: RichText(
                  text: TextSpan(children: <TextSpan>[
                TextSpan(
                    text: 'Informacion legal',
                    style: TextStyle(color: Colors.black),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LegalScreen()));
                      })
              ])),
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: RichText(
                  text: TextSpan(children: <TextSpan>[
                TextSpan(
                    text: 'Sobre nosotros',
                    style: TextStyle(color: Colors.black),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AboutUsScreen()));
                      })
              ])),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Cerrar sesión'),
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Eliminar cuenta'),
            ),
          ]).toList(),
        ),
      ),
    );
  }
}
