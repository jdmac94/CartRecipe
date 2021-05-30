import 'dart:io';

import 'package:cartrecipe/api/api_wrapper.dart';
import 'package:cartrecipe/screens/scanner_screen.dart';
import 'package:cartrecipe/screens/tabs_screens.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogIn extends StatefulWidget {
  final _LogIn state = new _LogIn();
  @override
  _LogIn createState() => _LogIn();
}

class _LogIn extends State<LogIn> {
  final emailText = TextEditingController();
  final passwordText = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool flag404 = false; //email no existe
  bool flag460 = false; //password mal

  Future<void> _setCache(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SharedPreferences token = await SharedPreferences.getInstance();
    prefs?.setBool("isLoggedIn", true);
    token?.setString("token", value);
  }

  void turnFlagsOff() {
    setState(() {
      flag404 = false;
      flag460 = false;
      _formKey.currentState.validate();
    });
  }

  String _validateUser(String value) {
    final patternEmail = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regExp = RegExp(patternEmail);
    //print('Validate user $flag404');
    if (value == null || value.isEmpty) {
      return 'Porfavor introduzca un email';
    } else if (flag404) {
      return 'Email no existe';
    } else if (!regExp.hasMatch(value)) {
      return 'Email mal formateado';
    } else {
      return null;
    }
  }

  String _validatePassword(String value) {
    //Minimum eight characters, at least one letter and one number
    //final patternEmail = r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$";
    //final regExp = RegExp(patternEmail);

    if (value == null || value.isEmpty) {
      return 'Porfavor introduzca un contraseña';
    } else if (flag460) {
      return 'Contraseña incorrecta';
      //} else if (!regExp.hasMatch(value)) {
      // return 'Contraseña 8 caract, almenos 1 letra y 1 numero';
    } else {
      return null;
    }
  }

  void _validateForm(String value) {
    print("estoy en el then $value");
    if (value != "Error") {
      //USUARIO
      if (value == "404") {
        setState(() {
          flag404 = true;
          _formKey.currentState.validate();
        });
        print('Error 404, Usuario no existe');
      } else if (value == "460") {
        //PASSWORD
        setState(() {
          flag460 = true;
          _formKey.currentState.validate();
        });
        print('Error 460, Contraseña incorrecta');
      } else if (value != null) {
        _setCache(value);
        ApiWrapper().setAuthToken(value);
        Navigator.pushAndRemoveUntil(
            context,
            new MaterialPageRoute(
              builder: (context) => new TabsScreen(0),
            ),
            (r) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  SizedBox(height: 30),
                  Text("Porfavor, introduzca los campos para iniciar sesión"),
                  SizedBox(height: 10),
                  new Image.asset(
                    'assets/images/logo/logocart.png',
                    width: 100,
                    height: 100,
                  ),
                  Center(
                    child: TextFormField(
                      onChanged: (value) => turnFlagsOff(),
                      validator: (value) => _validateUser(value),
                      controller: emailText,
                      decoration: const InputDecoration(
                        focusColor: Colors.deepPurple,
                        icon: Icon(Icons.email),
                        labelText: 'Email',
                      ),
                    ),
                  ),
                  Center(
                    child: TextFormField(
                      onChanged: (value) => turnFlagsOff(),
                      validator: (value) => _validatePassword(value),
                      obscureText: true,
                      controller: passwordText,
                      decoration: const InputDecoration(
                        focusColor: Colors.deepPurple,
                        icon: Icon(Icons.lock),
                        labelText: 'Contraseña',
                      ),
                    ),
                  ),
                  Center(
                    child: TextButton(
                        child: Text("Iniciar sesión"),
                        onPressed: () => {
                              setState(() {
                                if (_formKey.currentState.validate()) {
                                  ApiWrapper()
                                      .logInUsuario(
                                          emailText.text, passwordText.text)
                                      .then((value) => {_validateForm(value)});
                                }
                              })
                            }),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
