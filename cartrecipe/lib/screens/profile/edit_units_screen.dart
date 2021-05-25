import 'package:cartrecipe/api/api_wrapper.dart';
import 'package:flutter/material.dart';

class EditUnitsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sistema de unidades'), 
      ),
      body: Center(
        child: ListView(
          children: [
            ListTile(
              title: Text("Métrico"),
              leading: Text("kg"),
              onTap: () {ApiWrapper().modificaSistemaUnidades(true).then((value) => Navigator.pop(context));},
            ),
            ListTile(
              title: Text("Imperial"),
              leading: Text("lb"),
              onTap: () {ApiWrapper().modificaSistemaUnidades(false).then((value) => Navigator.pop(context));},
            ),
          ],
        ),
      ),
    );
  }
}