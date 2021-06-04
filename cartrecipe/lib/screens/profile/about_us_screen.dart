import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('About Us'),
        ),
        body: Center(
          child: RichText(
              text: TextSpan(children: <TextSpan>[
            TextSpan(
              text: 'Esto es CartRecipe, un proyecto de LIS',
              style: TextStyle(color: Colors.black),
            )
          ])),
        ));
  }
}
