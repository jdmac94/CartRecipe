import 'package:cartrecipe/screens/profile/legal_text_screen.dart';
import 'package:flutter/material.dart';

class LegalScreen extends StatelessWidget {
  _pushToLoremIpsum(BuildContext context, String pageName) {
    Navigator.push(context,
        new MaterialPageRoute(builder: (context) => LegalTextScreen(pageName)));
  }

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
              onTap: () => _pushToLoremIpsum(context, 'Cookies'),
            ),
            ListTile(
              leading: Icon(Icons.shield),
              title: Text('Privacidad'),
              onTap: () => _pushToLoremIpsum(context, 'Privacidad'),
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text('Términos y condiciones'),
              onTap: () => _pushToLoremIpsum(context, 'Términos y condiciones'),
            ),
          ]).toList(),
        ),
      ),
    );
  }
}
