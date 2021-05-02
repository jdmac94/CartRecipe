import 'package:flutter/material.dart';

class LogIn extends StatelessWidget {
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
            child: TextButton(
              child: Text("Log in"),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}
