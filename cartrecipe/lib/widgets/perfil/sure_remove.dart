import 'package:cartrecipe/api/api_wrapper.dart';
import 'package:cartrecipe/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class SureRemove extends StatelessWidget {
  String reason = "";
  SureRemove(this.reason);

  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Eliminar cuenta'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Estas seguro de eliminar?'),
            // ignore: missing_required_param
            SizedBox(height: 100),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
            child: Text('Si, estoy seguro'),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              SharedPreferences token = await SharedPreferences.getInstance();

              prefs?.setBool("isLoggedIn", false);
              token?.setString("token", '');

              print("Reason$reason");

              await ApiWrapper().deleteUser();
              ApiWrapper().saveReason(reason);

              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Welcome()),
                  (r) => false);

              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Cuenta eliminada')));
            }),
        TextButton(
          child: Text('No'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
