import 'dart:ui';

import 'package:cartrecipe/api/api_wrapper.dart';
import 'package:cartrecipe/desperate/products_data_provider.dart';
import 'package:cartrecipe/models/product.dart';
import 'package:cartrecipe/providers/product_list_provider.dart';
import 'package:cartrecipe/screens/tabs_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:cartrecipe/widgets/detail_view_product.dart';
import 'package:provider/provider.dart';

class LocalDesperateFridge extends StatefulWidget {
  LocalDesperateFridge({Key key}) : super(key: key);

  @override
  _LocalDesperateFridgeState createState() => _LocalDesperateFridgeState();
}

class _LocalDesperateFridgeState extends State<LocalDesperateFridge> {
  int counter = 0;
  String valueText;
  TextEditingController _textFieldController = TextEditingController();
  //final _formKey = GlobalKey<FormState>();
  Map selectedProducts = new Map<int, String>();
  var _data;
  String doRefresh;
  bool loaded = false;
  var provider;

  // //TODO NEVERA LOCAL SIN PROVIDER
  // Future<String> fetchData() async {
  //   var temp = await ApiWrapper().getFridgeProducts();

  //   this.setState(() {
  //     _data = temp;
  //   });

  //   print('Tengo datos en nevera?  ${_data.length}');

  //   return 'Succes!';
  // }

  // //TODO NEVERA LOCAL SIN PROVIDER
  // @override
  // void initState() {
  //   fetchData();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // setState(() {
    //   _data = Provider.of<ProductsDataProvider>(context).getResponseList;
    //   print('Inside data build con provider ${_data.length}');
    // });
    // setState(() {
    //   provider = Provider.of<ProductsDataProvider>(context);
    //   provider.fetchServerData;
    //   print('');
    //   //_data = Provider.of<ProductsDataProvider>(context).getList();
    //   //provider.fetchServerData();
    //   // print(
    //   //     'Estoy en el build y hago print del provider lis - ${provider.obtenerLista}');
    // });

    // setState(() {
    //   Future<List> temp = Provider.of<ProductsDataProvider>(context).getData();

    //   //print('Datos obtenidos = $_data');
    // });

    return Scaffold(
      body: Container(
        child: Center(
            child: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 20)),
            Text('Soy la nevera mejorada'),
            Consumer<ProductsDataProvider>(
                builder: (context, proveedor, child) =>
                    Expanded(child: buildListView(proveedor.obtenerLista))),
            buildVisibility(),
          ],
        )),
      ),
      floatingActionButton: buildSpeedDial(),
    );
  }

  // @override
  // void initState() {
  //   _data = [];
  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   _data = [];
  //   super.dispose();
  // }

  // void fetchDataProvider() {
  //   var provider = Provider.of<ProductsDataProvider>(context);
  //   //provider.fetchServerData();
  //   this.setState(() {
  //     _data = provider.obtenerLista;
  //     print('Number list length = ${_data.length}');
  //   });
  // }

  Future<void> dialogProduct(BuildContext context, Product product) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return DetailViewProduct(product);
      },
    );
  }

  Future<void> deleteProduct(Product product) async {
    ApiWrapper().deleteAndreh([product.id]).then(
        (value) => showSnackBarMessage('${product.name} eliminado'));

    print('Borrado en local');
    _data.removeWhere((element) => element.id == product.id);
    //selectedProducts.removeWhere((key, value) => product.id == value);
    selectedProducts = new Map<int, String>();
    _refresh();
  }

  //TODO! No añade más de 1 a mano
  Future<void> addProduct(String barcode) async {
    Product test = await ApiWrapper().addProduct(barcode);
    setState(() {
      _data.add(test);
      //doRefresh = 'now';
    });
    print('El producto añadido es el siguiente: $test');
    //_refresh();
  }

  void _refresh() {
    setState(() {
      //_data.add(test);
      doRefresh = 'now';
    });
    // Navigator.pushReplacement(context,
    //     new MaterialPageRoute(builder: (context) => new TabsScreen(1)));
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

                  ApiWrapper()
                      .deleteAndreh(test)
                      .then((value) => print('Se ha enviado el borrado'));

                  print('Borrado en local');
                  test.forEach((element) {
                    _data.removeWhere((product) => product.id == element);
                  });

                  _refresh();
                  //Devuelve a la vista ANTERIOR, no NUEVA ( con el product eliminado)

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

  // void _chargeData() {
  //   setState(() {
  //   _data = provider.getList();

  //   });
  // }

  Visibility buildVisibility() {
    return Visibility(
      visible: selectedProducts.isNotEmpty,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: FloatingActionButton(
          child: Icon(Icons.delete),
          onPressed: () {
            // List<int> keys = [];

            // selectedProducts.keys.forEach((key) {
            //   print('Se añade la posicion $key al positions');
            //   keys.add(key);
            // });

            _dialogMultipleDelete(context).then((value) {
              setState(() {
                selectedProducts = new Map<int, String>();
              });
            });
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
      onOpen: () {
        setState(() {
          if (selectedProducts.isNotEmpty) {
            print('Vaciado del map');
            selectedProducts.clear();
            print('${selectedProducts.length}');
          }
        });
      },
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
      itemCount: data == null ? 0 : data.length,
      itemBuilder: (context, index) {
        Product productItem = data[index];
        return Dismissible(
          key: UniqueKey(),
          background: Container(
            color: Colors.red,
          ),
          onDismissed: (direction) {
            //provider.deleteProduct(product);
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
        selected: selectedProducts.containsKey(index),
        onTap: () {
          setState(() {
            if (selectedProducts.isEmpty) {
              dialogProduct(context, productItem);
              print('Tap en ${productItem.name}');
            } else {
              if (selectedProducts.containsKey(index)) {
                print(
                    'Quitamos el producto ${selectedProducts[index]} del Map');
                print('${selectedProducts.length}');
                selectedProducts.remove(index);
              } else {
                selectedProducts[index] = productItem.id;
                print('Añadimos ${selectedProducts[index]} al Map');
                print('${selectedProducts.length}');
              }
            }
          });
        },
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
