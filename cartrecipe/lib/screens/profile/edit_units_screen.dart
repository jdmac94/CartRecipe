import 'package:flutter/material.dart';

class EditUnitsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sistema de unidades'), //TODO: Añadir
      ),
      body: Center(
        child: ListView(
          children: [
            ListTile(
              title: Text("Métrico"),
              leading: Text("kg"),
            ),
            ListTile(
              title: Text("Imperial"),
              leading: Text("lb"),
            ),
          ],
        ),
      ),
    );
  }
}