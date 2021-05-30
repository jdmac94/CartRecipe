import 'package:cartrecipe/screens/profile/edit_units_screen.dart';
import 'package:cartrecipe/screens/profile/recetario_screen.dart';
import 'package:cartrecipe/widgets/fridge/delete_alert.dart';
import 'package:cartrecipe/widgets/perfil/close_session.dart';
import 'package:cartrecipe/widgets/perfil/remove_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:cartrecipe/screens/profile/edit_preferences_screen.dart';
import 'package:cartrecipe/screens/profile/edit_profile_screen.dart';
import 'package:cartrecipe/screens/profile/contact_screen.dart';
import 'package:cartrecipe/screens/profile/legal_screen.dart';
import 'package:cartrecipe/screens/profile/about_us_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../welcome.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String nombre, apellido;

  @override
  void initState() {
    super.initState();
    getLocalUserData().then((result) {
      setState(() {});
    });
  }

  getLocalUserData() async {
    SharedPreferences user = await SharedPreferences.getInstance();
    nombre = user.getString('nombre');
    apellido = user.getString('apellido');
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: ListTile.divideTiles(context: context, tiles: [
            ListTile(
              leading: Icon(Icons.account_circle),
              title: (nombre != null && apellido != null)
                  ? Text(nombre + ' ' + apellido)
                  : Text('<Usuario>'),
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
              leading: Icon(Icons.local_dining),
              title: RichText(
                  text: TextSpan(children: <TextSpan>[
                TextSpan(
                    text: 'Recetario',
                    style: TextStyle(color: Colors.black),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RecetearioScreen()));
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
                                builder: (context) => EditPreferencesScreen()));
                      })
              ])),
            ),
            ListTile(
                leading: Icon(Icons.square_foot),
                title: RichText(
                    text: TextSpan(children: <TextSpan>[
                  TextSpan(
                      text: 'Sistema de unidades',
                      style: TextStyle(color: Colors.black),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditUnitsScreen()));
                        })
                ]))),
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
              onTap: () {
                dialogCloseSession(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Eliminar cuenta'),
              onTap: () {
                dialogRemoveAccount(context);
              },
            ),
          ]).toList(),
        ),
      ),
    );
  }

  Future<void> dialogCloseSession(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return CloseSession();
      },
    );
  }

  Future<void> dialogRemoveAccount(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return RemoveAccount();
      },
    );
  }
}
