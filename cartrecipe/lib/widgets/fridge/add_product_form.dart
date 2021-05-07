import 'package:cartrecipe/providers/products_data_provider.dart';
import 'package:cartrecipe/screens/fridge_screen.dart';
import 'package:cartrecipe/screens/tabs_screens.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class AddProductForm extends StatelessWidget {
  static String input;
  //variable para la validacion
  final _formKey = GlobalKey<FormState>();
  //variable para guardar el texto introducido
  final _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductsDataProvider>(
      builder: (context, proveedor, child) => AlertDialog(
        title: Text('Inserta el código de barras a buscar'),
        content: SingleChildScrollView(
          child: Form(
            //key: _data,
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: _textFieldController,
              //decoration: InputDecoration(hintText: 'Cifra de 13 dígitos'),
              // validator: (value) {
              //   print('Llego aquí');
              //   String patttern = r'(^[0-9]*$)';
              //   RegExp regExp = new RegExp(patttern);
              //   if (value == null || value.isEmpty) {
              //     return 'Por favor, introduzca texto';
              //   } else if (!regExp.hasMatch(value)) {
              //     return 'Sólo puede contener dígitos de 0 a 9';
              //   } else if (value.length < 13) {
              //     return 'Faltan dígitos para llegar a los 13 necesarios';
              //   } else if (value.length > 13) {
              //     return 'Se han escrito más de 13 dígitos';
              //   }

              //   return false;
              // },
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _textFieldController.clear();
              Navigator.of(context).pop();
            },
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.deepPurple,
              onPrimary: Colors.white,
            ),
            onPressed: () {
              //if (_formKey.currentState.validate()) {
              print('Valor del input: ${_textFieldController.text}');
              proveedor.addProduct(_textFieldController.text);
              //addProduct(_textFieldController.text);

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      'Se ha añadido el producto con el código ${_textFieldController.text}'),
                  action: SnackBarAction(
                    label: 'Deshacer',
                    onPressed: () {},
                  )));
              // showSnackBarMessage(
              //     'Se ha añadido el producto con el código ${_textFieldController.text}');
              _textFieldController.clear();
              Navigator.of(context).popAndPushNamed(FridgeScreen.routeName);
              // Navigator.pushReplacement(
              //     context,
              //     new MaterialPageRoute(
              //         builder: (context) => new TabsScreen(3, true)));
              //}
            },
            child: Text('Añadir'),
          ),
        ],
      ),
    );
  }
}
