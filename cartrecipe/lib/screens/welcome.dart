import 'package:cartrecipe/screens/login/log_in.dart';
import 'package:cartrecipe/screens/login/sign_in.dart';
import 'package:cartrecipe/screens/login/sign_in_with_google.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: '294072647128-m2hdn84udhg23mdfutbfr693b3th864a.apps.googleusercontent.com',
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
    'https://www.googleapis.com/auth/userinfo.profile',
  ],
);

class Welcome extends StatelessWidget {
  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Bienvendo a CartRecipe!",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          new Image.asset(
            'assets/images/logo/logocart.png',
            width: 200,
            height: 200,
          ),
          Center(
            child: Container(
              child: ElevatedButton(
                child: Text("Registrarse"),
                onPressed: () => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => SignIn())),
              ),
            ),
          ),
          Center(
            child: OutlinedButton(
              child: Text("Iniciar sesión"),
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => LogIn())),
            ),
          ),
          Center(
            child: Container(
              child: ElevatedButton(
                child: Text("Registrarte o inicia sesión con Google"),
                onPressed: () async {
                  await _handleSignIn();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SignInWithGoogle()));
                },
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
