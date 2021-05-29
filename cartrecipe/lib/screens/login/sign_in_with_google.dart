import 'package:cartrecipe/api/api_wrapper.dart';
import 'package:cartrecipe/screens/preferences_screen.dart';
import 'package:cartrecipe/screens/tutorial/tutorial_screen.dart';
import 'package:cartrecipe/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:cartrecipe/screens/tabs_screens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert' show json;

class SignInWithGoogle extends StatefulWidget {
  final _SignInWithGoogle state = new _SignInWithGoogle();
  @override
  _SignInWithGoogle createState() => _SignInWithGoogle();
}

class _SignInWithGoogle extends State<SignInWithGoogle> {
  final passwordText = TextEditingController();
  final passwordText2 = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<String> _userName;
  GoogleSignInAccount _currentUser;

  bool flag404 = false; //email no existe
  bool flag460 = false; //password mal
  bool flag461 = false; //email ya existe
  bool flag462 = false; //email mal formateado
  bool flag463 = false; //password mal formateado
  bool flag464 = false; //nombre y apellido mal formateado

  GoogleSignIn _googleSignIn = GoogleSignIn(
    // Optional clientId
    // clientId: '294072647128-m2hdn84udhg23mdfutbfr693b3th864a.apps.googleusercontent.com',
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
  }

  void turnFlagsOff() {
    setState(() {
      flag461 = false;
      flag462 = false;
      flag463 = false;
      flag404 = false;
      flag460 = false;
      flag464 = false;
      _formKey.currentState.validate();
    });
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

  void handleSplit() {
    if (_currentUser.displayName.contains(' ')) {
      _userName = _currentUser.displayName.split(' ');
    } else {
      _userName[0] = _currentUser.displayName;
      _userName[1] = ' ';
    }
  }

  Future<void> _setCache(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SharedPreferences token = await SharedPreferences.getInstance();
    prefs?.setBool("isLoggedIn", true);
    token?.setString("token", value);
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
            MaterialPageRoute(builder: (context) => PreferencesScreen()),
            (r) => false);
      }
    }
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

  void _validateForm2(String value) {
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
                    Text("Please sign in"),
                    SizedBox(height: 20),
                    new Image.asset(
                      'assets/images/logo/logocart.png',
                      width: 100,
                      height: 100,
                    ),
                    Center(
                      child: TextFormField(
                        onChanged: (value) => turnFlagsOff(),
                        validator: (value) => _validatePassword(value),
                        obscureText: true,
                        controller: passwordText,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.lock),
                          labelText: 'Password',
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
                          labelText: 'Confirm password',
                        ),
                      ),
                    ),
                    Center(
                        child: TextButton(
                            child: Text("Sign in"),
                            onPressed: () => {
                                  if (_formKey.currentState.validate())
                                    {
                                      print(_currentUser),
                                      handleSplit(),
                                      ApiWrapper()
                                          .registrarUsuario(
                                              _userName[0],
                                              _userName[1],
                                              _currentUser.email,
                                              passwordText.text)
                                          .then((value) => _validateForm(value))
                                    },
                                })),
                    Center(
                        child: TextButton(
                            child: Text("Log in"),
                            onPressed: () => {
                                  if (_formKey.currentState.validate())
                                    {
                                      ApiWrapper()
                                          .logInUsuario(_currentUser.email,
                                              passwordText.text)
                                          .then((value) =>
                                              {_validateForm2(value)})
                                    },
                                }))
                  ],
                ),
              ),
            ))));
  }
}
