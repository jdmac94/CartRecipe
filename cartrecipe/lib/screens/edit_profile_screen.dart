import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Editar perfil'),
        ),
        body: Container(
            child: ListView(
          children: [
            SizedBox(
              height: 30,
            ),
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://cdn.icon-icons.com/icons2/1863/PNG/512/account-circle_119476.png"))),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "Nom",
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "Email",
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "Contraseña",
              ),
            ),
          ],
        )));
  }
}
