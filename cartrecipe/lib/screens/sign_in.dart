import 'package:flutter/material.dart';

class SignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text("Please log in"),
          Center(
            child: TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                labelText: 'User Name',
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
            child: TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.lock),
                labelText: 'Confirm password',
              ),
            ),
          ),
          Center(
            child: TextButton(
              child: Text("Sign in"),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}
