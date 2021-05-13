import 'package:flutter/material.dart';

class LegalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Legal'),
      ),
      body: Center(
        child: ListView(
          children: ListTile.divideTiles(context: context, tiles: [
            ListTile(
              leading: Icon(Icons.lock_open),
              title: Text('Cookies'),
            ),
            ListTile(
              leading: Icon(Icons.shield),
              title: Text('Privacidad'),
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text('Términos y condiciones'),
            ),
          ]).toList(),
        ),
      ),
    );
  }
}
