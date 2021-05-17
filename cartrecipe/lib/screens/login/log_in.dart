import 'dart:io';

import 'package:cartrecipe/api/api_wrapper.dart';
import 'package:cartrecipe/screens/scanner_screen.dart';
import 'package:cartrecipe/screens/tabs_screens.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogIn extends StatelessWidget {
  final emailText = TextEditingController();
  final passwordText = TextEditingController();
  String token = "";

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
                    onPressed: () => {
                          ApiWrapper()
                              .logInUsuario(emailText.text, passwordText.text)
                              .then((value) => {
                                    if (value != null)
                                      {
                                        token = value,
                                        _setCache(value),
                                        ApiWrapper().setAuthToken(value),
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            new MaterialPageRoute(
                                              builder: (context) =>
                                                  new TabsScreen(0),
                                            ),
                                            (r) => false)
                                      }
                                  })
                        }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
