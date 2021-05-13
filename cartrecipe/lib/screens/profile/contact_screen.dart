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
              text: 'Para contactarnos puedes llamar al XXX XX XX XX',
              style: TextStyle(color: Colors.black),
            )
          ])),
        ));
  }
}
