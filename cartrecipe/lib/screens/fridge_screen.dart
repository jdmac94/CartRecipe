import 'package:flutter/material.dart';

import 'dart:async';
import 'package:cartrecipe/widgets/fridge/detail_view_product.dart';
import 'package:cartrecipe/providers/products_data_provider.dart';
import 'package:cartrecipe/widgets/fridge/fridge_speedial.dart';
import 'package:cartrecipe/models/product.dart';
import 'package:provider/provider.dart';

class FridgeScreen extends StatefulWidget {
  static const routeName = '/fridge';
  final bool refresh;
  final _FridgeScreenState state = new _FridgeScreenState();
  FridgeScreen({Key key, this.refresh}) : super(key: key);

  @override
  _FridgeScreenState createState() => _FridgeScreenState();
}

class _FridgeScreenState extends State<FridgeScreen> {
  int counter = 0;

  //TextEditingController _textFieldController = TextEditingController();

  Map selectedProducts = new Map<int, String>();

  Future<void> dialogProduct(BuildContext context, Product product) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return DetailViewProduct(product, false);
      },
    );
  }

  @override
  void initState() {
    if (widget.refresh == true) {
      mockRefresh();
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    mockRefresh();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //ESTO NO TIRA POR LO MISMO, se crea el data provider en null
    ProductsDataProvider productList =
        Provider.of<ProductsDataProvider>(context);
    productList.fetchServerData();

    return Scaffold(
      key: UniqueKey(),
      body: Container(
        child: Center(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 20)),
              //Text('Soy la nevera mejorada'),
              Consumer<ProductsDataProvider>(
                builder: (context, proveedor, child) => Expanded(
                    //TODO! Comprobar CircularProgressIndicator
                    child: proveedor.isFetching == null
                        ? Container(
                            child: Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.deepPurple,
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.pink),
                              ),
                            ),
                          )
                        : ((proveedor.productList == null) ||
                                (proveedor.productList.isEmpty))
                            ? Center(
                                child: Text('No hay datos en la nevera'),
                              )
                            : RefreshIndicator(
                                onRefresh: mockRefresh,
                                color: Colors.deepPurple,
                                child: buildListView(proveedor))),
              ),
              buildVisibility(selectedProducts),
            ],
          ),
        ),
      ),
      floatingActionButton: FridgeSpeedDial(selectedProducts),
    );
  }

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
                  children: [
                    Text('??Est??s seguro de querer eliminar ' +
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
                    setState(() {
                      selectedProducts = new Map<int, String>();
                    });

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

  Visibility buildVisibility(Map selectedProducts) {
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

  Future<void> mockRefresh() async {
    setState(() {});
  }

  ListView buildListView(ProductsDataProvider proveedor) {
    counter++;
    print('Counter = $counter');

    var _data = proveedor.productList;

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: _data == null ? 0 : _data.length,
      itemBuilder: (context, index) {
        Product productItem = _data[index];
        return Dismissible(
          key: UniqueKey(),
          background: Container(
            color: Colors.red,
          ),
          child: productItem != null ? buildCard(productItem, index) : null,
          onDismissed: (direction) {
            setState(() {
              // if (selectedProducts.containsKey(index)) {
              //   print(
              //       'Quitamos el producto ${selectedProducts[index]} del Map');
              //   print('${selectedProducts.length}');

              //   //selectedProducts.remove(index);
              // }
              selectedProducts.clear();
            });
            print('El producto completo es $productItem');
            proveedor.deleteProduct([productItem.id]);

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    'Se ha eliminado el producto ${productItem.name} de la nevera'),
                action: SnackBarAction(
                  label: 'Deshacer',
                  onPressed: () {
                    proveedor.addProduct(productItem.id);
                    Timer(Duration(seconds: 1), () {
                      mockRefresh();
                    });
                  },
                )));
          },
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
                print('A??adimos ${selectedProducts[index]} al Map');
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
              print('A??adimos ${selectedProducts[index]} al Map');
              print('${selectedProducts.length}');
            }
          });
        },
      ),
    );
  }
}
