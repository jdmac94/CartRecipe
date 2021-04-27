import 'package:flutter/material.dart';

class DeleteAllAlert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Eliminar producto'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Estas seguro de eliminar todos los productos de la nevera?'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Eliminar Todo'),
          onPressed: () {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Vaciando nevera')));
            //llamar funcion delete all fridge o
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
