import 'package:cartrecipe/api/api_wrapper.dart';
import 'package:cartrecipe/models/product.dart';
import 'package:cartrecipe/models/recipe.dart';
import 'package:cartrecipe/screens/recipes/recipe_detail_screen.dart';
import 'package:cartrecipe/widgets/fridge/detail_view_product.dart';
import 'package:cartrecipe/widgets/recipes/recipe_card.dart';
import 'package:flutter/material.dart';

class SearchsScreen extends StatefulWidget {
  final _SearchsScreen state = new _SearchsScreen();
  SearchsScreen({Key key}) : super(key: key);

  _SearchsScreen createState() => _SearchsScreen();
}

enum Busqueda { products, recetas }
Busqueda _busqueda = Busqueda.products;

class _SearchsScreen extends State<SearchsScreen> {
  final _textFieldController = TextEditingController();
  List<dynamic> _data = [];
  List<String> history = [];
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: UniqueKey(),
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(children: [
              Row(children: [
                Expanded(
                  child: TextFormField(
                    controller: _textFieldController,
                    decoration: InputDecoration(hintText: "Buscar"),
                    autofocus: isSearching,
                    onTap: () {
                      isSearching = true;
                      setState(() {});
                    },
                  ),
                ),
                IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      isSearching = false;
                      if (history.length >= 5) {
                        history.removeLast();
                      }
                      if (!history.contains(_textFieldController.text)) {
                        history.insert(0, _textFieldController.text);
                      }
                      print(
                          'Valor del input buscar: ${_textFieldController.text}');
                      if (_busqueda == Busqueda.products) {
                        ApiWrapper()
                            .getBusqueda(_textFieldController.text)
                            .then((value) {
                          setState(() {
                            _data = value;
                            print("Data is: $_data");
                          }); //setState
                        });
                      } else if (_busqueda == Busqueda.recetas) {
                        ApiWrapper()
                            .getBusquedaRecetas(_textFieldController.text)
                            .then((value) {
                          setState(() {
                            _data = value;
                            print("Data is: $_data");
                          }); //setState
                        });
                      } //then
                    })
              ]),
              RadioListTile<Busqueda>(
                title: const Text('Recetas'),
                value: Busqueda.recetas,
                groupValue: _busqueda,
                onChanged: (Busqueda value) {
                  setState(() {
                    _busqueda = value;
                    _data = [];
                  });
                },
              ),
              RadioListTile<Busqueda>(
                  title: const Text('Productos'),
                  value: Busqueda.products,
                  groupValue: _busqueda,
                  onChanged: (Busqueda value) {
                    setState(() {
                      _busqueda = value;
                      _data = [];
                    });
                  }),
              isSearching && history.isNotEmpty
                  ? //Historial de busqueda (ultimos 5 elementos buscados)
                  ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: history.length,
                      itemBuilder: (BuildContext context, int index) {
                        String currentValue = history[index];
                        return InkWell(
                          child: Container(
                              height: 50,
                              child: Card(
                                child: Center(
                                  child: Text(
                                    currentValue,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )),
                          onTap: () {
                            isSearching = false;
                            _textFieldController.text = currentValue;
                            if (!history.contains(currentValue)) {
                              history.remove(currentValue);
                              history.insert(0, currentValue);
                            }
                            ApiWrapper()
                                .getBusqueda(currentValue)
                                .then((value) {
                              setState(() {
                                _data = value;
                              });
                            });
                          },
                        );
                      },
                    )
                  : Container(),
              ((_data == null) || (_data.isEmpty))
                  ? (Column(children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text("No hay datos")
                    ]))
                  : Column(
                      children: [
                        if (_busqueda == Busqueda.products)
                          ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: _data.length,
                            itemBuilder: (context, index) {
                              Product productItem = _data[index];
                              return Column(children: [
                                _data[index].name == null
                                    ? Text("no hay datos")
                                    : buildCardProduct(productItem, index)
                              ]);
                            },
                          )
                        else if (_busqueda == Busqueda.recetas)
                          ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: _data.length,
                            itemBuilder: (context, index) {
                              Recipe recipeItem = _data[index];
                              return Column(children: [
                                _data[index].titulo == null
                                    ? Text("no hay datos")
                                    : buildCardRecipe(recipeItem, index)
                              ]);
                            },
                          )
                      ],
                    ),
            ]),
          ),
        ),
      ),
    );
  }

  Future<void> dialogProduct(BuildContext context, Product product) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return DetailViewProduct(product, true);
      },
    );
  }

  Card buildCardProduct(Product productItem, int index) {
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

  Card buildCardRecipe(Recipe recipeItem, int index) {
    return Card(
      child: ListTile(
          leading: (recipeItem.imagenes == null)
              ? FlutterLogo(size: 70)
              : Image.network(
                  recipeItem.imagenes[0],
                  width: 70,
                  height: 70,
                ),
          title: Text(recipeItem.titulo),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RecipeDetail(_data[index], true)));
          }),
    );
  }
}
