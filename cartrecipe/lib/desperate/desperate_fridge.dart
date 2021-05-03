import 'dart:ui';

import 'package:cartrecipe/api/api_wrapper.dart';
import 'package:cartrecipe/models/product.dart';
import 'package:cartrecipe/screens/tabs_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class DesperateFridge extends StatefulWidget {
  DesperateFridge({Key key}) : super(key: key);

  @override
  _DesperateFridgeState createState() => _DesperateFridgeState();
}

class _DesperateFridgeState extends State<DesperateFridge> {
  int counter = 0;
  String valueText;
  TextEditingController _textFieldController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Map selectedProducts = new Map<int, String>();
  var _data;

  @override
  void initState() {
    //_data = fetchData();
    super.initState();
  }

  Future<List<Product>> fetchData() async {
    return ApiWrapper().getFridgeProducts();
  }

  Future<void> deleteProduct(Product product) async {
    ApiWrapper().deleteAndreh([product.id]);
    showSnackBarMessage('${product.name} eliminado');
  }

  Future<void> addProduct(String barcode) async {
    Product test = await ApiWrapper().addProduct(barcode);
    print('El producto añadido es el siguiente: $test');
    _refresh();
  }

  void _refresh() {
    Navigator.pushReplacement(context,
        new MaterialPageRoute(builder: (context) => new TabsScreen(1)));
  }

  Future<void> _dialogMultipleDelete(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
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

                  ApiWrapper().deleteAndreh(test).then((value) => _refresh());
                  //Devuelve a la vista ANTERIOR, no NUEVA ( con el product eliminado)

                  //Navigator.of(context, rootNavigator: true).pop(context);
                },
              ),
              TextButton(
                child: Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future<void> _dialogAdd(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          // return BackdropFilter(
          //   filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          //   child:
          return AlertDialog(
            title: Text('Inserta el código de barras a buscar'),
            content: SingleChildScrollView(
              child: Form(
                key: _data,
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
                  addProduct(_textFieldController.text);
                  showSnackBarMessage(
                      'Se ha añadido el producto con el código ${_textFieldController.text}');
                  _textFieldController.clear();
                  Navigator.of(context).pop();
                  //}
                },
                child: Text('Añadir'),
              ),
            ],
          );
          //);
        });
  }

  showSnackBarMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'Deshacer',
          onPressed: () {},
        )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 20)),
              Text('Soy la nevera mejorada'),
              FutureBuilder<List<Product>>(
                future: fetchData(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Product>> snapshot) {
                  // switch (snapshot.connectionState) {
                  //   case ConnectionState.none:
                  //     return Text('ConnectionState.none');
                  //   case ConnectionState.waiting:
                  //     return Text('ConnectionState.waiting');
                  //   case ConnectionState.active:
                  //     return Text('ConnectionState.active');
                  //   case ConnectionState.done:
                  //     Text('ConnectionState.done');
                  // }

                  if (snapshot.hasData) {
                    List<Product> _data = snapshot.data;
                    return Expanded(
                      child: buildListView(_data),
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }

                  return CircularProgressIndicator(
                    backgroundColor: Colors.deepPurple,
                  );
                },
              ),
              buildVisibility(),
            ],
          ),
        ),
      ),
      floatingActionButton: buildSpeedDial(),
    );
  }

  Visibility buildVisibility() {
    return Visibility(
      visible: selectedProducts.isNotEmpty,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: FloatingActionButton(
          child: Icon(Icons.delete),
          onPressed: () {
            _dialogMultipleDelete(context);
            List<int> keys = [];

            selectedProducts.keys.forEach((key) {
              print('Se añade la posicion $key al positions');
              keys.add(key);
            });
            // setState(() {
            //   selectedProducts = new Map<int, String>();
            // });
          },
          backgroundColor: Colors.redAccent,
        ),
      ),
    );
  }

  SpeedDial buildSpeedDial() {
    return SpeedDial(
      icon: Icons.menu,
      animatedIcon: AnimatedIcons.menu_close,
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
      children: [
        SpeedDialChild(
            child: Icon(Icons.edit),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            label: 'Añadir manualmente',
            onTap: () {
              _dialogAdd(context);
            }),
        SpeedDialChild(
            child: Icon(Icons.qr_code),
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            label: 'Añadir mediante escaner',
            onTap: () {
              Navigator.pushReplacement(context,
                  new MaterialPageRoute(builder: (context) => TabsScreen(2)));
            }),
        SpeedDialChild(
          child: Icon(Icons.delete_forever),
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
          label: 'Vaciar nevera',
        )
      ],
    );
  }

  ListView buildListView(List<Product> data) {
    counter++;
    print('Counter = $counter');
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        Product productItem = data[index];
        return Dismissible(
          key: UniqueKey(),
          background: Container(
            color: Colors.red,
          ),
          onDismissed: (direction) {
            deleteProduct(productItem);
          },
          child: buildCard(productItem, index),
        );
      },
    );
  }

  Card buildCard(Product productItem, int index) {
    return Card(
      child: ListTile(
        leading: (productItem.image == null)
            ? FlutterLogo(size: 70)
            : Image.network(
                productItem.image,
                width: 70,
                height: 70,
              ),
        title: Text(productItem.name),
        onTap: () {},
        selected: selectedProducts.containsKey(index),
        onLongPress: () {
          setState(() {
            if (selectedProducts.containsKey(index)) {
              print('Quitamos el producto ${selectedProducts[index]} del Map');
              print('${selectedProducts.length}');
              selectedProducts.remove(index);
            } else {
              selectedProducts[index] = productItem.id;
              print('Añadimos ${selectedProducts[index]} al Map');
              print('${selectedProducts.length}');
            }
          });
        },
      ),
    );
  }
}
