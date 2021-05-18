import 'package:cartrecipe/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class SureRemove extends StatelessWidget {
  String reason = "";
  SureRemove(this.reason);

  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Eliminar cuenta'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('¿Estás seguro de querer eliminar la cuenta?'),
            // ignore: missing_required_param
            SizedBox(height: 100),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
            child: Text('Sí, estoy seguro'),
            onPressed: () {
              print("Reason$reason");
            }),
        TextButton(
          child: Text('No'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
