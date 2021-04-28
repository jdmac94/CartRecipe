import 'package:flutter/material.dart';

import 'package:cartrecipe/api/api_wrapper.dart';

class AddProductForm extends StatelessWidget {
  //variable para la validacion
  final _formKey = GlobalKey<FormState>();
  //variable para guardar el texto introducido
  final productText = TextEditingController();

  //TODO Mirar que te aparezca el teclado numérico
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Añadir producto'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: productText,
                    // The validator receives the text that the user has entered.
/*                  validator: (value) {
                      String patttern = r'(^[0-9]*$)';
                      RegExp regExp = new RegExp(patttern);
                      if (value == null || value.isEmpty) {
                        return 'Porfavor introduzca texto';
                      } else if (!regExp.hasMatch(value)) {
                        return 'Solo debe contener numeros 0-9';
                      } else if (value.length < 13) {
                        return 'Introduzca los 13 caracteres';
                      }

                      return null;
                    },*/
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      //if (_formKey.currentState.validate()) {
                      // If the form is valid, display a snackbar.
                      ApiWrapper().addProduct(productText.text);
                      // ****call a server or save the information in a database****
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              //productText.text es el contenido del form
                              Text('Processing Data:' + productText.text)));

                      //Devuelve a la vista ANTERIOR, no NUEVA ( con el product añadido )
                      Navigator.of(context, rootNavigator: true).pop(context);
                      //}
                    },
                    child: Text('Submit'),
                  ),
                ),
                // ignore: deprecated_member_use
                FlatButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ]),
        ),
      ),
    );
  }
}
