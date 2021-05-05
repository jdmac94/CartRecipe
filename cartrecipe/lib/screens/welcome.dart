import 'package:cartrecipe/screens/login/log_in.dart';
import 'package:cartrecipe/screens/login/sign_in.dart';
import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  Text("Welcome to CartRecipe"),
                  Center(
                    child: TextButton(
                      child: Text("Sign In"),
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SignIn())),
                    ),
                  ),
                  Center(
                    child: TextButton(
                      child: Text("Log in"),
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LogIn())),
                    ),
                  ),
                ],
              ),
            )));
  }
}
