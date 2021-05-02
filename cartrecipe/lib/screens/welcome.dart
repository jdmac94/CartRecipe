import 'package:cartrecipe/screens/log_in.dart';
import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text("Welcome to CartRecipe"),
          Center(
            child: TextButton(
              child: Text("Sign In"),
              onPressed: () {},
            ),
          ),
          Center(
            child: TextButton(
              child: Text("Log in"),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return LogIn();
                }));
              },
            ),
          ),
        ],
      ),
    );
  }
}
