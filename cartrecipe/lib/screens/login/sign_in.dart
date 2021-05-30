import 'package:cartrecipe/api/api_wrapper.dart';
import 'package:cartrecipe/screens/tutorial/tutorial_screen.dart';
import 'package:cartrecipe/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../preferences_screen.dart';

class SignIn extends StatefulWidget {
  final _SignIn state = new _SignIn();
  @override
  _SignIn createState() => _SignIn();
}

class _SignIn extends State<SignIn> {
  final nombreText = TextEditingController();
  final apellidoText = TextEditingController();
  final emailText = TextEditingController();
  final passwordText = TextEditingController();
  final passwordText2 = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool flag461 = false; //email ya existe
  bool flag462 = false; //email mal formateado
  bool flag463 = false; //password mal formateado
  bool flag464 = false; //nombre y apellido mal formateado

  void turnFlagsOff() {
    setState(() {
      flag461 = false;
      flag462 = false;
      flag463 = false;
      flag464 = false;
      _formKey.currentState.validate();
    });
  }

  Future<void> _setCache(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SharedPreferences token = await SharedPreferences.getInstance();
    prefs?.setBool("isLoggedIn", true);
    token?.setString("token", value);
  }

  String _validateNombreyApellido(String value) {
    final patternNombre = r"[a-zA-Z]";
    final regExp = RegExp(patternNombre);
    if (value == null || value.isEmpty) {
      return 'Introduzca datos';
    } else if (flag464) {
      return 'Nombre mal formateado';
    } else if (!regExp.hasMatch(value)) {
      return 'Nombre mal formateado';
    } else {
      return null;
    }
  }

  String _validateEmail(String value) {
    final patternEmail = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regExp = RegExp(patternEmail);
    //print('Validate user $flag404');
    if (value == null || value.isEmpty) {
      return 'Porfavor introduzca un email';
    } else if (flag461) {
      return 'Este email ya existe';
    } else if (flag462) {
      return 'Email mal  formateado';
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
    } else if (flag463) {
      return 'Contraseña mal formateada';
      //} else if (!regExp.hasMatch(value)) {
      // return 'Contraseña 8 caract, almenos 1 letra y 1 numero';
    } else {
      return null;
    }
  }

  void _validateForm(String value) {
    print("estoy en el then $value");
    if (value != "Error") {
      if (value == "461") {
        setState(() {
          flag461 = true;
          _formKey.currentState.validate();
        });
        print('Error 461, email ya existe');
      } else if (value == "462") {
        setState(() {
          flag462 = true;
          _formKey.currentState.validate();
        });
        print('Error 462, email mal formateado');
      } else if (value == "463") {
        setState(() {
          flag463 = true;
          _formKey.currentState.validate();
        });
        print('Error 463, password mal formateado');
      } else if (value == "464") {
        setState(() {
          flag464 = true;
          _formKey.currentState.validate();
        });
        print('Error 464, nombre y apellido mal formateado');
      } else if (value != null) {
        _setCache(value);
        ApiWrapper().setAuthToken(value);
        // ScaffoldMessenger.of(context)
        //     .showSnackBar(SnackBar(content: Text('Usuario registrado')));
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => PreferencesScreen()), //TutorialScreen()),
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
                    Text("Porfavor, introduzca los campos para registrarse"),
                    SizedBox(height: 20),
                    new Image.asset(
                      'assets/images/logo/logocart.png',
                      width: 100,
                      height: 100,
                    ),
                    Center(
                        child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            onChanged: (value) => turnFlagsOff(),
                            validator: (value) =>
                                _validateNombreyApellido(value),
                            controller: nombreText,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.person),
                              labelText: 'Nombre',
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            onChanged: (value) => turnFlagsOff(),
                            validator: (value) =>
                                _validateNombreyApellido(value),
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
                        onChanged: (value) => turnFlagsOff(),
                        validator: (value) => _validateEmail(value),
                        controller: emailText,
                        decoration: const InputDecoration(
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
                          icon: Icon(Icons.lock),
                          labelText: 'Contraseña',
                        ),
                      ),
                    ),
                    Center(
                      child: TextFormField(
                        onChanged: (value) => turnFlagsOff(),
                        validator: (value) {
                          if (value != passwordText.text) {
                            return 'Contraseñas no coiciden';
                          }
                          return null;
                        },
                        controller: passwordText2,
                        obscureText: true,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.lock),
                          labelText: 'Confirme la contraseña',
                        ),
                      ),
                    ),
                    Center(
                        child: TextButton(
                            child: Text("Registrarse"),
                            onPressed: () => {
                                  if (_formKey.currentState.validate())
                                    {
                                      saveUserDataLocally(
                                          nombreText.text, apellidoText.text),
                                      ApiWrapper()
                                          .registrarUsuario(
                                              nombreText.text,
                                              apellidoText.text,
                                              emailText.text,
                                              passwordText.text)
                                          .then((value) => _validateForm(value))
                                    },
                                }))
                  ],
                ),
              ),
            ))));
  }

  saveUserDataLocally(String nombre, String apellido) async {
    SharedPreferences user = await SharedPreferences.getInstance();
    user.setString('nombre', nombre);
    user.setString('apellido', apellido);

    print(nombre = user.getString('nombre'));
  }
}
