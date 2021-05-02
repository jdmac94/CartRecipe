import 'package:cartrecipe/providers/product_list_provider.dart';
import 'package:cartrecipe/providers/test_provider.dart';
import 'package:flutter/material.dart';

import 'package:cartrecipe/api/api_wrapper.dart';

import 'package:cartrecipe/models/product.dart';

import 'package:cartrecipe/widgets/fridge_speedial.dart';
import 'package:cartrecipe/widgets/detail_view_product.dart';
import 'package:cartrecipe/widgets/delete_alert.dart';
import 'package:flutter/rendering.dart';

import 'dart:async';

import 'package:provider/provider.dart';

class MyFridgeScreen extends StatefulWidget {
  static const String routeNamed = '/fridge';

  @override
  _MyFridgeScreenState createState() => _MyFridgeScreenState();
}

//TODO! Mirar de conseguir el valor del tetxfield para añadirlo a la lista
class _MyFridgeScreenState extends State<MyFridgeScreen> {
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

  moveToButton(BuildContext context) async {
    productToAdd = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FridgeSpeedDial()),
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

  //TODO!
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    listedProduct = Provider.of<ProductList>(context, listen: false);
    //resfreshScreen();
    super.initState();
  }

  void resfreshScreen() {
    ApiWrapper().getFridgeProducts().then((products) {
      if (mounted) {
        setState(() {
          listedProduct = products;
        });
      }

      // Timer.periodic(Duration(seconds: 3), (timer) {
      //   setState(() {
      //     //List temporary;
      //     ApiWrapper()
      //         .getFridgeProducts()
      //         .then((products) => listedProduct = products);
      //   });
      // });
    });
  }

  void deleteProduct(List<String> product, int index) {
    if (mounted)
      setState(() {
        listedProduct.removeAt(index);
        ApiWrapper().deleteAndreh(product);
        ApiWrapper()
            .getFridgeProducts()
            .then((products) => listedProduct = products);

        //I assume you want to remove favorites as well otherwise the two indeces will go out of sync? Maybe?
        //favourites.removeAt(index)
      });
  }

  void deleteMultipleProducts(List<int> positions) {
    if (mounted) {
      setState(() {
        positions.forEach((position) {
          print('Se borra la posicion $position de los selected');
          listedProduct.removeAt(position);
        });

        //ApiWrapper().deleteAndreh(product);
        //I assume you want to remove favorites as well otherwise the two indeces will go out of sync? Maybe?
        //favourites.removeAt(index)
      });
    }
  }

  Future refresh() async {
    setState(() {
      ApiWrapper()
          .getFridgeProducts()
          .then((products) => listedProduct = products);
    });
  }

  void undo() {}

  Future refreshAfterAdd() async {
    setState(() {
      ApiWrapper()
          .getFridgeProducts()
          .then((products) => listedProduct = products);
    });

    return FridgeSpeedDial();
  }

  // FridgeSpeedDial addPlis() {
  //   setState(() {
  //     productToAdd = 'a';
  //     return FridgeSpeedDial();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    setState(() {
      productToAdd = ModalRoute.of(context).settings.arguments as String;
    });
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
              // Consumer<ProductList>(
              //   builder: (context, productList, child) =>
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
                                //productList.update();
                                //deleteProduct([item.id], index);
                                //provider.loadProductsData();
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
                        //productList.update();
                        //deleteMultipleProducts(keys);
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
        floatingActionButton: FridgeSpeedDial() //addPlis() //(),
        );
  }
}
