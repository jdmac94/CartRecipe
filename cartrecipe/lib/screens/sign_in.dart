import 'package:flutter/material.dart';

class SignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Column(
        children: [
          Text("Please sign in"),
          Center(
              child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    labelText: 'Nombre',
                  ),
                ),
              ),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    labelText: 'Apellido',
                  ),
                ),
              ),
            ],
          )),
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
              //onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => )),,
            ),
          )
        ],
      ),
    ));
  }
}
