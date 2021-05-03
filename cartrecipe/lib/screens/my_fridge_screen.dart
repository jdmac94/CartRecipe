import 'package:cartrecipe/api/api_wrapper.dart';
import 'package:cartrecipe/providers/product_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:cartrecipe/models/product.dart';

import 'package:cartrecipe/widgets/fridge_speedial.dart';
import 'package:cartrecipe/widgets/detail_view_product.dart';
import 'package:cartrecipe/widgets/delete_alert.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'dart:async';

import 'package:provider/provider.dart';

class MyFridgeScreen extends StatefulWidget {
  static const String routeNamed = '/fridge';

  @override
  _MyFridgeScreenState createState() => _MyFridgeScreenState();
}

class _MyFridgeScreenState extends State<MyFridgeScreen> {
  Map selectedMap = new Map<int, String>();

  List<String> delete = [];

  var listedProduct;

  String productToAdd;

  Timer timer;

  @override
  void initState() {
    listedProduct = [];
    super.initState();
  }

  @override
  void dispose() {
    listedProduct = [];
    super.dispose();
  }

  Future<void> dialogProduct(BuildContext context, Product product) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return DetailViewProduct(product);
      },
    );
  }

  Future<void> confirmDelete(
      BuildContext context, Map<int, String> selectedMap) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return DeleteAlert(selectedMap);
      },
    );
  }

  void undo() {}

  @override
  Widget build(BuildContext context) {
    setState(() {
      listedProduct = Provider.of<ProductList>(context).getData();
    });
    //final productList = Provider.of<ProductList>(context);
    //final provider = Provider.of<TestProvider>(context, listen: false);
    //final data = provider.items;
    print('Llego a la nevera');
    return Scaffold(
      key: UniqueKey(),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Text('Productos en la nevera'),
            Consumer<ProductList>(
              builder: (context, provider, child) => Expanded(
                child: provider.listaProductos == null
                    ? Container(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        key: UniqueKey(),
                        itemCount: provider.listaProductos.length,
                        itemBuilder: (BuildContext context, int index) {
                          print(
                              'Estoy en la nevera y tengo ${provider.listaProductos.length} productos ');
                          //return ProductCard(snapshot, index);
                          Product item = provider.listaProductos[index];
                          return Dismissible(
                            background: Container(color: Colors.red),
                            key: UniqueKey(),
                            onDismissed: (direction) {
                              setState(() {
                                provider.deleteProduct(item.id, index);
                              });

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("${item.name} eliminado"),
                                action: SnackBarAction(
                                    label: 'Deshacer',
                                    onPressed: undo //!YA SE HARÁ,
                                    ),
                              ));
                            },
                            child: Card(
                              child: ListTile(
                                  leading: (item.image == null)
                                      ? FlutterLogo(size: 70)
                                      : Image.network(
                                          item.image,
                                          width: 70,
                                          height: 70,
                                        ),
                                  title: Text(item.name),
                                  onTap: () => dialogProduct(context, item),
                                  //!ESTO PARA TRATAR DE HACER SELECCION MULTIPLE
                                  // trailing: CheckboxListTile(
                                  //   controlAffinity: ListTileControlAffinity,
                                  // ),
                                  selected: selectedMap.containsKey(index),
                                  onLongPress: () {
                                    setState(() {
                                      if (selectedMap.containsKey(index)) {
                                        print('Remove Selected id: ' +
                                            selectedMap[index].toString());

                                        selectedMap.remove(index);
                                      } else {
                                        selectedMap[index] = item.id;
                                        print('Add Selected id: ' +
                                            selectedMap[index].toString());
                                      }
                                    });
                                  }),
                            ),
                          );
                        }),
              ),
            ),
            //),
            Consumer<ProductList>(
              builder: (context, provider, child) => Visibility(
                visible: selectedMap.isNotEmpty,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: FloatingActionButton(
                    child: Icon(Icons.delete),
                    onPressed: () {
                      confirmDelete(context, selectedMap);
                      List<int> keys = [];

                      selectedMap.keys.forEach((key) {
                        print('Se añade la posicion $key al positions');
                        keys.add(key);
                      });
                      setState(() {
                        provider.deleteMultipleProduct(keys);
                        selectedMap = new Map<int, String>();
                      });
                    },
                    backgroundColor: Colors.redAccent,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FridgeSpeedDial(),
    );
  }
}

// class FridgeSpeedDial extends StatelessWidget {
//   Future<void> dialogAddForm(BuildContext context) {
//     return showDialog<void>(
//       context: context,
//       builder: (BuildContext context) {
//         return AddProductForm();
//       },
//     );
//   }

//   Future<void> confirmDelete(BuildContext context) {
//     return showDialog<void>(
//       context: context,
//       builder: (BuildContext context) {
//         return DeleteAllAlert();
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SpeedDial(
//       /// both default to 16
//       marginEnd: 18,
//       marginBottom: 20,
//       animatedIcon: AnimatedIcons.menu_close,
//       animatedIconTheme: IconThemeData(size: 22.0),

//       /// This is ignored if animatedIcon is non null
//       icon: Icons.add,
//       activeIcon: Icons.remove,
//       // iconTheme: IconThemeData(color: Colors.grey[50], size: 30),

//       /// The label of the main button.
//       // label: Text("Open Speed Dial"),
//       /// The active label of the main button, Defaults to label if not specified.
//       // activeLabel: Text("Close Speed Dial"),
//       /// Transition Builder between label and activeLabel, defaults to FadeTransition.
//       // labelTransitionBuilder: (widget, animation) => ScaleTransition(scale: animation,child: widget),
//       /// The below button size defaults to 56 itself, its the FAB size + It also affects relative padding and other elements
//       buttonSize: 56.0,
//       visible: true,

//       /// If true user is forced to close dial manually
//       /// by tapping main button and overlay is not rendered.
//       closeManually: false,
//       curve: Curves.bounceIn,
//       overlayColor: Colors.white,
//       overlayOpacity: 0.5,
//       onOpen: () => print('OPENING DIAL'),
//       onClose: () => print('DIAL CLOSED'),
//       tooltip: 'Speed Dial',
//       heroTag: 'speed-dial-hero-tag',
//       backgroundColor: Colors.deepPurple,
//       foregroundColor: Colors.white,
//       elevation: 8.0,
//       shape: CircleBorder(),

//       // orientation: SpeedDialOrientation.Up,
//       // childMarginBottom: 2,
//       // childMarginTop: 2,
//       gradientBoxShape: BoxShape.circle,
//       activeBackgroundColor: Colors.deepPurple,
//       // gradient: LinearGradient(
//       //   begin: Alignment.topCenter,
//       //   end: Alignment.bottomCenter,
//       //   colors: [Colors.black, Colors.white],
//       // ),
//       children: [
//         SpeedDialChild(
//           child: Icon(Icons.edit),
//           backgroundColor: Colors.deepPurple,
//           foregroundColor: Colors.white,
//           label: 'Añadir manualmente',
//           labelStyle: TextStyle(fontSize: 18),
//           onTap: () => dialogAddForm(context),
//           onLongPress: () => print('FIRST CHILD LONG PRESS'),
//         ),
//         SpeedDialChild(
//           child: Icon(Icons.qr_code),
//           backgroundColor: Colors.deepPurple,
//           foregroundColor: Colors.white,
//           label: 'Añadir mediante escaner',
//           labelStyle: TextStyle(fontSize: 18),
//           onTap: () => print('Abrir scanner'),
//           onLongPress: () => print('SECOND CHILD LONG PRESS'),
//         ),
//         SpeedDialChild(
//           child: Icon(Icons.delete_forever),
//           backgroundColor: Colors.redAccent,
//           foregroundColor: Colors.white,
//           label: 'Vaciar nevera',
//           labelStyle: TextStyle(fontSize: 18),
//           onTap: () => confirmDelete(context),
//           onLongPress: () => print('THIRD CHILD LONG PRESS'),
//         ),
//       ],
//     );
//   }
// }

// class AddProductForm extends StatefulWidget {
//   static String input;

//   @override
//   _AddProductFormState createState() => _AddProductFormState();
// }

// class _AddProductFormState extends State<AddProductForm> {
//   final _formKey = GlobalKey<FormState>();

//   final productText = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text('Añadir producto'),
//       content: SingleChildScrollView(
//         child: Form(
//           key: _formKey,
//           child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: TextFormField(
//                     controller: productText,
//                     // The validator receives the text that the user has entered.
// /*                  validator: (value) {
//                       String patttern = r'(^[0-9]*$)';
//                       RegExp regExp = new RegExp(patttern);
//                       if (value == null || value.isEmpty) {
//                         return 'Porfavor introduzca texto';
//                       } else if (!regExp.hasMatch(value)) {
//                         return 'Solo debe contener numeros 0-9';
//                       } else if (value.length < 13) {
//                         return 'Introduzca los 13 caracteres';
//                       }

//                       return null;
//                     },*/
//                   ),
//                 ),
//                 Consumer<ProductList>(
//                   builder: (context, provider, child) => Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 16.0),
//                     child: ElevatedButton(
//                       onPressed: () {
//                         // Validate returns true if the form is valid, or false otherwise.
//                         //if (_formKey.currentState.validate()) {
//                         // If the form is valid, display a snackbar.

//                         //ApiWrapper().addProduct(productText.text);
//                         setState(() {
//                           provider.addProduct(productText.text);
//                         });
//                         // ****call a server or save the information in a database****
//                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                             content:
//                                 //productText.text es el contenido del form
//                                 Text('Processing Data:' + productText.text)));

//                         //Devuelve a la vista ANTERIOR, no NUEVA ( con el product añadido )
//                         Navigator.pop(context, productText.text);
//                         // Navigator.of(context).pushNamed(
//                         //     MyFridgeScreen.routeNamed,
//                         //     arguments: productText.text);
//                         //}
//                       },
//                       child: Text('Submit'),
//                     ),
//                   ),
//                 ),
//                 // ignore: deprecated_member_use
//                 FlatButton(
//                   child: Text("Cancelar"),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//               ]),
//         ),
//       ),
//     );
//   }
// }

// class DeleteAllAlert extends StatelessWidget {
//   static String input;

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text('Eliminar producto'),
//       content: SingleChildScrollView(
//         child: ListBody(
//           children: <Widget>[
//             Text('Estas seguro de eliminar todos los productos de la nevera?'),
//           ],
//         ),
//       ),
//       actions: <Widget>[
//         TextButton(
//           child: Text('Eliminar Todo'),
//           onPressed: () {
//             ScaffoldMessenger.of(context)
//                 .showSnackBar(SnackBar(content: Text('Vaciando nevera')));

//             ApiWrapper().clearNevera();
//             //Devuelve a la vista ANTERIOR, no NUEVA ( con el product eliminado)

//             Navigator.of(context, rootNavigator: true).pop(context);
//           },
//         ),
//         TextButton(
//           child: Text('Cancelar'),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//       ],
//     );
//   }
// }
