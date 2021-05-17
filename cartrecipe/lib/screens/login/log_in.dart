import 'dart:io';

import 'package:cartrecipe/api/api_wrapper.dart';
import 'package:cartrecipe/screens/scanner_screen.dart';
import 'package:cartrecipe/screens/tabs_screens.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogIn extends StatelessWidget {
  final emailText = TextEditingController();
  final passwordText = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool flag404 = false;
  bool flag460 = false;

  Future<void> _setCache(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SharedPreferences token = await SharedPreferences.getInstance();
    prefs?.setBool("isLoggedIn", true);
    token?.setString("token", value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Align(
          alignment: Alignment.center,
          child: Container(
            child: Column(
              children: [
                Text("Please log in"),
                Center(
                  child: TextFormField(
                    validator: (value) {
                      final patternEmail = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                      final regExp = RegExp(patternEmail);

                      if (value == null || value.isEmpty) {
                        return 'Porfavor introduzca un email';
                      } else if (flag404) {
                        return 'Usuario no existe';
                      } else if (!regExp.hasMatch(value)) {
                        return 'Mail mal formateado';
                      } else {
                        return null;
                      }
                    },
                    controller: emailText,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.email),
                      labelText: 'Email',
                    ),
                  ),
                ),
                Center(
                  child: TextFormField(
                    obscureText: true,
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
                      onPressed: () => {
                            if (_formKey.currentState.validate())
                              {
                                ApiWrapper()
                                    .logInUsuario(
                                        emailText.text, passwordText.text)
                                    .then((value) => {
                                          print("estoy en el then $value"),
                                          if (value != "Error")
                                            {
                                              if (value == "404")
                                                {
                                                  flag404 = true,
                                                  print(
                                                      'Error 404, Contraseña incorrecta'),
                                                }
                                              else if (value == "460")
                                                {
                                                  flag460 = true,
                                                  print(
                                                      'Error 460, Usuario no existe'),
                                                }
                                              else if (value != null)
                                                {
                                                  _setCache(value),
                                                  ApiWrapper()
                                                      .setAuthToken(value),
                                                  Navigator.pushAndRemoveUntil(
                                                      context,
                                                      new MaterialPageRoute(
                                                        builder: (context) =>
                                                            new TabsScreen(0),
                                                      ),
                                                      (r) => false)
                                                }
                                            }
                                        })
                              }
                          }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
