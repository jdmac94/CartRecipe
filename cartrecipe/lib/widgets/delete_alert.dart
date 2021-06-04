import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DeleteAlert extends StatelessWidget {
  Map selectedMap = new Map<int, String>();

  DeleteAlert(this.selectedMap);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Eliminar productos'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Estas seguro de eliminar ' +
                selectedMap.length.toString() +
                ' productos de la nevera?'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Eliminar'),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    'Eliminando productos:' + selectedMap.values.toString())));
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
