import 'package:cartrecipe/api/api_wrapper.dart';
import 'package:flutter/material.dart';

class SignIn extends StatelessWidget {
  final nombreText = TextEditingController();
  final apellidoText = TextEditingController();
  final emailText = TextEditingController();
  final passwordText = TextEditingController();

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
                  controller: nombreText,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    labelText: 'Nombre',
                  ),
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: apellidoText,
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
              onPressed: () => ApiWrapper().registrarUsuario(nombreText.text,
                  apellidoText.text, emailText.text, passwordText.text),
              //onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => )),,
            ),
          )
        ],
      ),
    ));
  }
}
