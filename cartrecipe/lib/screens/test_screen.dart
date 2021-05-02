import 'package:cartrecipe/api/api_wrapper.dart';
import 'package:cartrecipe/models/product.dart';
import 'package:cartrecipe/providers/product_list_provider.dart';
import 'package:cartrecipe/providers/product_provider.dart';
import 'package:cartrecipe/widgets/fridge_speedial.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TestScreen extends StatefulWidget {
  TestScreen({Key key}) : super(key: key);

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  //List<Product> listadoProductos = [];
  var _data;
  List<Product> auxList = [];

  @override
  void initState() {
    //_data = Provider.of<ProductProvider>(context).gimmeData;
    copydata();
    super.initState();
  }

  Future<List<Product>> copydata() async {
    //TODO! CON ESTA FUNCIONA
    final fridge = await ApiWrapper().getFridgeProducts();
    //final fridge = Provider.of<ProductProvider>(context).syncWithApi();
    if (mounted) {
      setState(() {
        _data = fridge;
      });
    }

    return fridge;
  }

  Future<void> addToFridge(String barcode, int index) async {
    Product prod = await ApiWrapper().addProduct(barcode);
    _data.add(prod);
  }

  Future<void> removeFromFridge(String barcode, int index) async {
    ApiWrapper().deleteAndreh([barcode]);
    _data.removeAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Consumer<ProductList>(
          builder: (context, provider, child) => FutureBuilder(
            future: copydata(),
            builder: (BuildContext context, snapshot) {
              if (!snapshot.hasData) {
                print('No data in snapshot');
              } else {
                return ListView.builder(
                    itemCount: _data.length,
                    itemBuilder: (BuildContext context, int index) {
                      List<Product> lista = _data;
                      return Card(
                        child: ListTile(
                          leading: FlutterLogo(size: 72.0),
                          title: Text(lista[index].name),
                          onTap: () {
                            removeFromFridge(lista[index].id, index);
                          },
                          onLongPress: () {
                            addToFridge('8480017560506', index);
                          },
                        ),
                      );
                    });
              }
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FridgeSpeedDial(),
    );
  }
}

addToFridge(String id, int index) {}
