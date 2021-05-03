import 'package:cartrecipe/api/api_wrapper.dart';
import 'package:cartrecipe/screens/scanner_screen.dart';
import 'package:flutter/material.dart';

class LogIn extends StatelessWidget {
  final emailText = TextEditingController();
  final passwordText = TextEditingController();
  var token = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Text("Please log in"),
            Center(
              child: TextFormField(
                controller: emailText,
                decoration: const InputDecoration(
                  icon: Icon(Icons.email),
                  labelText: 'Email',
                ),
              ),
            ),
            Center(
              child: TextFormField(
                controller: passwordText,
                decoration: const InputDecoration(
                  icon: Icon(Icons.lock),
                  labelText: 'Password',
                ),
              ),
            ),
            Center(
              child: TextButton(
                child: Text("Log in"),

                onPressed: () => ApiWrapper()
                    .logInUsuario(emailText.text, passwordText.text),
                //onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
