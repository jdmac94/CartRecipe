import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DeleteAlert extends StatelessWidget {
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
          onPressed: () {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Sesión Cerrada')));

            //Devuelve a la vista ANTERIOR, no NUEVA ( con el product eliminado)
            Navigator.of(context, rootNavigator: true).pop(context);
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
