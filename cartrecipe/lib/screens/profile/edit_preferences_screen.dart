import 'package:flutter/material.dart';

class EditPreferencesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preferencias'),
      ),
      body: Center(
        child: ListView(
          children: ListTile.divideTiles(context: context, tiles: [
            ListTile(
              leading: Icon(Icons.set_meal),
              title: Text('Alergias e Intolerancias'),
            ),
            ListTile(
              leading: Icon(Icons.no_food),
              title: Text('Dieta'),
            ),
            ListTile(
              leading: Icon(Icons.dinner_dining),
              title: Text('Nivel de cocina'),
            ),
          ]).toList(),
        ),
      ),
    );
  }
}
