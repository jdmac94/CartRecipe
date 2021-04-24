import 'package:flutter/material.dart';

class AddProductForm extends StatelessWidget {
  //variable para la validacion
  final _formKey = GlobalKey<FormState>();
  //variable para guardar el texto introducido
  final productText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Card(
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState.validate()) {
                        // If the form is valid, display a snackbar.
                        // ****call a server or save the information in a database****
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                //productText.text es el contenido del form
                                Text('Processing Data:' + productText.text)));
                        //Devuelve a la vista ANTERIOR, no NUEVA ( con el product añadido )
                        Navigator.of(context, rootNavigator: true).pop(context);
                      }
                    },
                    child: Text('Submit'),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
