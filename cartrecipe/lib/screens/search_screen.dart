import 'package:cartrecipe/api/api_wrapper.dart';
import 'package:cartrecipe/models/product.dart';
import 'package:cartrecipe/widgets/fridge/detail_view_product.dart';
import 'package:flutter/material.dart';

class SearchsScreen extends StatefulWidget {
  final _SearchsScreen state = new _SearchsScreen();
  SearchsScreen({Key key}) : super(key: key);

  _SearchsScreen createState() => _SearchsScreen();
}

class _SearchsScreen extends State<SearchsScreen> {
  final _textFieldController = TextEditingController();
  List<Product> _data = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: UniqueKey(),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(children: [
              Row(children: [
                Expanded(
                  child: TextFormField(
                    controller: _textFieldController,
                    decoration: InputDecoration(hintText: "Buscar"),
                  ),
                ),
                IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      print(
                          'Valor del input buscar: ${_textFieldController.text}');
                      ApiWrapper()
                          .getBusqueda(_textFieldController.text)
                          .then((value) {
                        setState(() {
                          _data = value;
                          print("Data is: $_data");
                        }); //setState
                      }); //then
                    })
              ]),
              _data.isEmpty
                  ? Text("No hay datos")
                  : Column(
                      children: [
                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: _data.length,
                          itemBuilder: (context, index) {
                            Product productItem = _data[index];
                            return Column(children: [
                              _data[index].name == null
                                  ? Text("no hay datos")
                                  : buildCard(productItem, index),
                            ]);
                          },
                        ),
                      ],
                    ),
            ]),
          ),
        ));
  }

  Future<void> dialogProduct(BuildContext context, Product product) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return DetailViewProduct(product, true);
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
          onTap: () {
            dialogProduct(context, productItem);
          }),
    );
  }
}
