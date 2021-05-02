import 'package:cartrecipe/providers/product_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:cartrecipe/models/product.dart';

import 'package:cartrecipe/widgets/fridge_speedial.dart';
import 'package:cartrecipe/widgets/detail_view_product.dart';
import 'package:cartrecipe/widgets/delete_alert.dart';
import 'package:flutter/rendering.dart';

import 'dart:async';

import 'package:provider/provider.dart';

class MyFridgeScreen extends StatelessWidget {
  static const String routeNamed = '/fridge';

  //Primer camp sera el Index, segon el Codi de Barres
  Map selectedMap = new Map<int, String>();
  List<String> delete = [];
  var listedProduct;
  String productToAdd;
  Timer timer;

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
    //setState(() {
    productToAdd = ModalRoute.of(context).settings.arguments as String;
    //});
    //final productList = Provider.of<ProductList>(context);
    //final provider = Provider.of<TestProvider>(context, listen: false);
    //final data = provider.items;
    print('Llego a la nevera');
    return Scaffold(
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
                                provider.deleteProduct(item.id, index);
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
                                      //setState(() {
                                      if (selectedMap.containsKey(index)) {
                                        print('Remove Selected id: ' +
                                            selectedMap[index].toString());

                                        selectedMap.remove(index);
                                      } else {
                                        selectedMap[index] = item.id;
                                        print('Add Selected id: ' +
                                            selectedMap[index].toString());
                                      }
                                      //});
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
                        //setState(() {
                        provider.deleteMultipleProduct(keys);
                        selectedMap = new Map<int, String>();
                        //});
                      },
                      backgroundColor: Colors.redAccent,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FridgeSpeedDial() //addPlis() //(),
        );
  }
}
