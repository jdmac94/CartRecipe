import 'package:cartrecipe/providers/products_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VisibilityMultipleDelete extends StatelessWidget {
  //const VisibilityMultipleDelete({Key key}) : super(key: key);

  final Map selectedProducts;

  VisibilityMultipleDelete(this.selectedProducts);

  Future<void> _dialogMultipleDelete(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return Consumer<ProductsDataProvider>(
            builder: (context, proveedor, child) => AlertDialog(
              key: UniqueKey(),
              title: Text('Eliminar productos'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Estas seguro de eliminar ' +
                        selectedProducts.length.toString() +
                        ' productos de la nevera?'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Eliminar'),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Eliminando productos:' +
                            selectedProducts.values.toString())));
                    print('Multiselect $selectedProducts.values');

                    List<String> test = [];

                    selectedProducts.values.forEach((element) {
                      test.add(element);
                    });

                    print('Selected values $test');

                    proveedor.deleteProduct(test);

                    Navigator.of(context, rootNavigator: true).pop(context);
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
        });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: selectedProducts.isNotEmpty,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: FloatingActionButton(
          child: Icon(Icons.delete),
          onPressed: () {
            _dialogMultipleDelete(context);
          },
          backgroundColor: Colors.redAccent,
        ),
      ),
    );
  }
}
