import 'package:cartrecipe/screens/login/log_in.dart';
import 'package:cartrecipe/screens/login/sign_in.dart';
import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Welcome to CartRecipe!",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          new Image.asset(
            'assets/images/logo/logocart.png',
            width: 200,
            height: 200,
          ),
          Center(
            child: Container(
              child: ElevatedButton(
                child: Text("Sign In"),
                onPressed: () => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => SignIn())),
              ),
            ),
          ),
          Center(
            child: OutlinedButton(
              child: Text("Log in"),
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => LogIn())),
            ),
          ),
        ],
      ),
    ));
  }
}
