import 'package:cartrecipe/screens/scanner_screen.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Pantalla de perfil'),
      ),
      floatingActionButton: FloatingActionButton(
          child: Text('Pulsame'),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => ScannerScreen()))
          //Navigator.of(context).popAndPushNamed(ScannerScreen.routeNamed),
          ),
    );
  }
}
