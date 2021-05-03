import 'package:cartrecipe/screens/scanner_screen.dart';
import 'package:flutter/material.dart';

class LogIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Text("Please log in"),
            Center(
              child: TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.email),
                  labelText: 'Email',
                ),
              ),
            ),
            Center(
              child: TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.lock),
                  labelText: 'Password',
                ),
              ),
            ),
            Center(
              child: TextButton(
                child: Text("Log in"),
                //onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
