import 'package:cartrecipe/providers/products_data_provider.dart';
import 'package:cartrecipe/screens/fridge_screen.dart';
import 'package:cartrecipe/screens/tabs_screens.dart';
import 'package:flutter/material.dart';
import 'package:cartrecipe/api/api_wrapper.dart';
import 'package:provider/provider.dart';

class DeleteAllAlert extends StatelessWidget {
  static String input;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductsDataProvider>(
      builder: (consumer, provider, child) => AlertDialog(
        title: Text('Eliminar producto'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                  '¿Estás seguro de querer eliminar todos los productos de la nevera?'),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text('Eliminar Todo'),
            onPressed: () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Vaciando nevera')));

              provider.deleteAllProducts();

              //Devuelve a la vista ANTERIOR, no NUEVA ( con el product eliminado)
              Navigator.pop(context);
              //Navigator.popAndPushNamed(context, FridgeScreen.routeName);
              // Navigator.pushReplacement(context,
              //     MaterialPageRoute(builder: (context) => TabsScreen(3)));
            },
          ),
          TextButton(
            child: Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
