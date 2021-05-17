import 'package:cartrecipe/api/api_wrapper.dart';
import 'package:cartrecipe/screens/tutorial/tutorial_screen.dart';
import 'package:cartrecipe/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatelessWidget {
  final nombreText = TextEditingController();
  final apellidoText = TextEditingController();
  final emailText = TextEditingController();
  final passwordText = TextEditingController();

  Future<void> _setCache(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SharedPreferences token = await SharedPreferences.getInstance();
    prefs?.setBool("isLoggedIn", true);
    token?.setString("token", value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Align(
            alignment: Alignment.center,
            child: Container(
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
                          onPressed: () => {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TutorialScreen()),
                                    (r) => false),
                                ApiWrapper()
                                    .registrarUsuario(
                                        nombreText.text,
                                        apellidoText.text,
                                        emailText.text,
                                        passwordText.text)
                                    .then((value) => {
                                          if (value != null)
                                            {
                                              _setCache(value),
                                              ApiWrapper().setAuthToken(value),
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        'Usuario registrado')),
                                              )
                                            }
                                        }),
                              }))
                ],
              ),
            )));
  }
}
