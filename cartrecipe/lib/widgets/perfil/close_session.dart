import 'package:cartrecipe/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class CloseSession extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Cerrar sesión'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Estas seguro de cerrar sesión ?'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cerrar sesión'),
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            SharedPreferences token = await SharedPreferences.getInstance();

            prefs?.setBool("isLoggedIn", false);
            token?.setString("token", '');
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Welcome()),
                (r) => false);

            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Sesión Cerrada')));

            //Devuelve a la vista ANTERIOR, no NUEVA ( con el product eliminado)
            //Navigator.of(context, rootNavigator: true).pop(context);
          },
        ),
        TextButton(
          child: Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
