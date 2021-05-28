import 'package:flutter/material.dart';

class ContactScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Contacto'),
        ),
        body: Center(
          child: RichText(
              text: TextSpan(children: <TextSpan>[
            TextSpan(
              text: 'Para contactarnos puedes llamar al +34 922 921 922',
              style: TextStyle(color: Colors.black),
            )
          ])),
        ));
  }
}
