import 'package:flutter/material.dart';

class DeleteAlert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Eliminar producto'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Estas seguro de eliminar este producto de la nevera?'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Eliminar'),
          onPressed: () {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Eliminando producto:')));
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
