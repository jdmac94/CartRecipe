import 'package:flutter/material.dart';

import 'package:cartrecipe/api/api_wrapper.dart';

import 'package:cartrecipe/models/product.dart';

import 'package:cartrecipe/widgets/fridge_speedial.dart';
import 'package:cartrecipe/widgets/detail_view_product.dart';
import 'package:cartrecipe/widgets/delete_alert.dart';
import 'package:flutter/rendering.dart';

import 'dart:io';

import 'package:cartrecipe/data/dummy_data.dart';

class MyFridgeScreen extends StatefulWidget {
  @override
  _MyFridgeScreenState createState() => _MyFridgeScreenState();
}

class _MyFridgeScreenState extends State<MyFridgeScreen> {
  //http://db6bc548365b.ngrok.io/api/v1/nevera/getProdKeyWord
  //TODO! Cambiar cada vez que se levante el servidor por el momento

  Map selectedMap = new Map<int,
      String>(); //Primer camp sera el Index, segon el Codi de Barres

  bool connection = false;

  List<String> delete = [];

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

  Future<List<Product>> getListProducts() async {
    print('Tengo conexión: $connection');

    if (connection)
      return ApiWrapper().getFridgeProducts();
    else
      return DUMMY_PRODUCTS;
  }

  @override
  bool initState() {
    Socket.connect('158.109.74.46', 55005, timeout: Duration(seconds: 5))
        .then((socket) {
      print("Hay conexión");
      connection = true;
      socket.destroy();
    }).catchError((error) {
      print("Exception on Socket " + error.toString());
    });
    super.initState();

    return connection;
  }

  void undo() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Text('Productos en la nevera'),
            Expanded(
              child: FutureBuilder(
                //TODO! REVISAR
                future:
                    getListProducts(), //if(checkConnection() == true) ?  : DUMMY_DATA,
                //ApiWrapper.getFridgeProducts(),
                builder: (BuildContext context, snapshot) {
                  if (!snapshot.hasData) {
                    print('No data in snapshot');
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Dismissible(
                            background: Container(color: Colors.red),
                            key: UniqueKey(),
                            onDismissed: (direction) {
                              setState(() {
                                //snapshot.data.removeAt(index);
                                print(
                                    'Borrando este producto ${snapshot.data[index].id}');

                                //TODO BORAR SI YA NO ES NECESARIO
                                // if (!delete.contains(snapshot.data[index].id))
                                //   delete.add(snapshot.data[index].id);
                                // print(delete);
                                // print(
                                //     'Delete es lista: ${delete is List<String>}');

                                // delete.forEach((element) {
                                //   element = '"' + element + '"';
                                //   print(element);
                                // });
                                String test = snapshot.data[index].id;

                                ApiWrapper().deleteSingleProduct(test);
                              });
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                    "${snapshot.data[index].name} eliminado"),
                                action: SnackBarAction(
                                    label: 'Deshacer',
                                    onPressed: undo //!YA SE HARÁ,
                                    ),
                              ));
                            },
                            child: Card(
                              child: ListTile(
                                  leading: (snapshot.data[index].image == null)
                                      ? FlutterLogo(size: 70)
                                      : Image.network(
                                          snapshot.data[index].image,
                                          width: 70,
                                          height: 70,
                                        ),
                                  title: Text(snapshot.data[index].name),
                                  onTap: () => dialogProduct(
                                      context, snapshot.data[index]),
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
                                        selectedMap[index] =
                                            snapshot.data[index].id;
                                        print('Add Selected id: ' +
                                            selectedMap[index].toString());
                                      }
                                    });
                                  }),
                            ),
                          );
                        });
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                    ),
                  );
                },
              ),
            ),
            Visibility(
              visible: selectedMap.isNotEmpty,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: FloatingActionButton(
                  child: Icon(Icons.delete),
                  onPressed: () {
                    confirmDelete(context, selectedMap);
                  },
                  backgroundColor: Colors.redAccent,
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
