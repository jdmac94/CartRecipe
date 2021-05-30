import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:cartrecipe/screens/tabs_screens.dart';
import 'package:cartrecipe/screens/profile/edit_preferences_screen.dart';
import 'package:cartrecipe/widgets/preferences/allergens.dart';
import 'package:cartrecipe/widgets/preferences/product_bans.dart';
import 'package:cartrecipe/widgets/preferences/wanted_tags.dart';
import 'package:cartrecipe/widgets/preferences/dieta.dart';
import 'package:cartrecipe/widgets/preferences/nivel_cocina.dart';
import 'package:cartrecipe/api/api_wrapper.dart';

class EdittingPreferencesScreen extends StatefulWidget {
  final int receivedPage;

  EdittingPreferencesScreen(this.receivedPage);
  @override
  State<EdittingPreferencesScreen> createState() =>
      _EdittingPreferencesScreen();
}

enum Dietas { ninguna, vegetariana, vegana }
Dietas _dieta = Dietas.ninguna;
enum Nivel { ninguno, bajo, medio, bueno, excelente }
Nivel _nivel = Nivel.medio;

class _EdittingPreferencesScreen extends State<EdittingPreferencesScreen> {
  EditPreferencesScreen edit = new EditPreferencesScreen();
  int _selectedPageIndex;
  void initState() {
    _selectedPageIndex = widget.receivedPage;
    preferencias.then((value) {
      preferences = value;
      resultado = preferences.values.toList();
      print(resultado);
      resultado[0].forEach((element) {
        element = element.toString().replaceAll("en:", '');
        allergensList.forEach((alergen) {
          if (element == alergen[1]) {
            alergen[0] = true;
          }
        });
      });
      if (resultado[1]) _dieta = Dietas.vegana;
      if (resultado[2]) _dieta = Dietas.vegetariana;

      resultado[3].forEach((element) {
        tagsToSend.add(element);
        tags.forEach((tag) {
          if (element == tag[1]) {
            tag[0] = true;
          }
        });
      });
      print(tagsToSend);
      products.then((value) {
        productNames = value;
        productNames.forEach((element) {
          productban.add(false);
        });
        resultado[4].forEach((element) {
          if (!productsToSend.contains(element)) productsToSend.add(element);
          for (int i = 0; i < productNames.length; i++) {
            if (element == productNames[i]) {
              productban[i] = true;
            }
          }
        });
      });

      _nivel = Nivel.values[(resultado[5] - 1)];
    });
    super.initState();
  }

  List resultado = [];
  Future<Map<String, dynamic>> preferencias = ApiWrapper().getPreferences();
  Map<String, dynamic> preferences;
  final Future<String> _calculation = Future<String>.delayed(
    const Duration(seconds: 2),
    () => 'Data Loaded',
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Preferencias'),
        ),
        body: Column(children: [
          Expanded(
              child: FutureBuilder<String>(
                  future: _calculation,
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    Widget children;
                    if (snapshot.hasData) {
                      if (_selectedPageIndex == 0)
                        children = gridViewAlergenos();
                      else if (_selectedPageIndex == 1)
                        children = Column(children: radiobuttonDieta());
                      else if (_selectedPageIndex == 2)
                        children = Column(children: radiobuttonNivel());
                      else if (_selectedPageIndex == 3)
                        children = gridViewTags();
                      else if (_selectedPageIndex == 4)
                        children = gridViewBans();
                    } else if (snapshot.hasError) {
                      children = const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      );
                    } else {
                      children = Center(
                        child: Column(children: [
                          SizedBox(
                            height: 150,
                          ),
                          SizedBox(
                            child: CircularProgressIndicator(),
                            width: 60,
                            height: 60,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Text('Esperando resultado...'),
                          )
                        ]),
                      );
                    }
                    return children;
                  })),
          buildButton()
        ]));

    /*return Scaffold(
        appBar: AppBar(
          title: Text('Preferencias'),
        ),
        body: Column(
          children: [
            if (_selectedPageIndex == 0)
              Expanded(child: gridViewAlergenos())
            else if (_selectedPageIndex == 1)
              Column(children: radiobuttonDieta())
            else if (_selectedPageIndex == 2)
              Column(children: radiobuttonNivel())
            else if (_selectedPageIndex == 3)
              Expanded(child: gridViewTags())
            else if (_selectedPageIndex == 4)
              Expanded(
                child: FutureBuilder<String>(
                    future: _calculation,
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      Widget children;
                      if (snapshot.hasData) {
                        children = gridViewBans();
                      } else if (snapshot.hasError) {
                        children = const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 60,
                        );
                      } else {
                        children = Column(children: [
                          SizedBox(
                            child: CircularProgressIndicator(),
                            width: 60,
                            height: 60,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Text('Awaiting result...'),
                          )
                        ]);
                      }
                      return children;
                    }),
              ),
            buildButton()
          ],
        ));*/
  }

  Widget buildButton() {
    return ElevatedButton(
        child: Text('Guardar'),
        onPressed: () => {
              if (_selectedPageIndex == 0)
                ApiWrapper().modAlergias(getAllergens)
              else if (_selectedPageIndex == 1)
                ApiWrapper().modDieta(_dieta.index == 2, _dieta.index == 1)
              else if (_selectedPageIndex == 2)
                ApiWrapper().modNivel((_nivel.index + 1))
              else if (_selectedPageIndex == 3)
                ApiWrapper().modTags(tagsToSend)
              else if (_selectedPageIndex == 4)
                ApiWrapper().modBanned(productsToSend),
              Navigator.pop(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditPreferencesScreen(),
                  ))
            });
  }

  List<String> tagsToSend = [];
  List<List<dynamic>> tags = [
    [false, "Arroces"],
    [false, "Asiático"],
    [false, " Carnes"],
    [false, "De Cuchara"],
    [false, "Desayunos"],
    [false, "Ensaladas y Bowls"],
    [false, "Fitness"],
    [false, "Guisos"],
    [false, "Hamburguesas"],
    [false, "Legumbres"],
    [false, "Mexicano"],
    [false, "Pastas"],
    [false, "Pizzas"],
    [false, "Pescados y Mariscos"],
    [false, "Pollo"],
    [false, "Postres"],
    [false, "Revueltos y Tortillas"],
    [false, "Salsas"],
    [false, "Salteados"],
    [false, "Sándwiches y Bocadillos"],
    [false, "Sin Gluten"],
    [false, "Snacking Saludable"],
    [false, "Sopas y Cremas"],
    [false, "Tostas"],
    [false, "Vegano"],
    [false, "Vegetariano"],
    [false, "Verduras"]
  ];
  List<String> allergenSend = [];
  List<List<dynamic>> allergensList = [
    [false, "celery"],
    [false, "crustaceans"],
    [false, "eggs"],
    [false, "fish"],
    [false, "gluten"],
    [false, "milk"],
    [false, "molluscs"],
    [false, "mustard"],
    [false, "nuts"],
    [false, "peanuts"],
    [false, "soybeans"],
    [false, "sulphites"],
  ];

  Widget gridViewAlergenos() {
    return Container(
        child: GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 3,
      children: [
        for (int i = 0; i < allergensList.length; i++) allergenButton(i)
      ],
    ));
  }

  Widget allergenButton(int allergenNumber) {
    String imagePath = allergensList[allergenNumber][1];
    return GestureDetector(
      onTap: () {
        if (allergensList[allergenNumber][0]) {
          setState(() {
            allergensList[allergenNumber][0] = false;
          });
        } else {
          setState(() {
            allergensList[allergenNumber][0] = true;
          });
        }
      },
      child: Container(
          padding: const EdgeInsets.all(8),
          color: allergensList[allergenNumber][0]
              ? Colors.blueAccent
              : Colors.grey,
          child: new Image.asset(
              'assets/images/products/allergens/$imagePath.png')),
    );
  }

  List<Widget> radiobuttonDieta() {
    return <Widget>[
      RadioListTile<Dietas>(
        title: const Text('No'),
        value: Dietas.ninguna,
        groupValue: _dieta,
        onChanged: (Dietas value) {
          setState(() {
            _dieta = value;
          });
        },
      ),
      RadioListTile<Dietas>(
        title: const Text('Sigo una dieta vegana'),
        value: Dietas.vegana,
        groupValue: _dieta,
        onChanged: (Dietas value) {
          setState(() {
            _dieta = value;
          });
        },
      ),
      RadioListTile<Dietas>(
        title: const Text('Sigo una dieta vegetariana'),
        value: Dietas.vegetariana,
        groupValue: _dieta,
        onChanged: (Dietas value) {
          setState(() {
            _dieta = value;
          });
        },
      )
    ];
  }

  List<Widget> radiobuttonNivel() {
    return <Widget>[
      RadioListTile<Nivel>(
        title: const Text('Ninguno'),
        value: Nivel.ninguno,
        groupValue: _nivel,
        onChanged: (Nivel value) {
          setState(() {
            _nivel = value;
          });
        },
      ),
      RadioListTile<Nivel>(
        title: const Text('Bajo'),
        value: Nivel.bajo,
        groupValue: _nivel,
        onChanged: (Nivel value) {
          setState(() {
            _nivel = value;
          });
        },
      ),
      RadioListTile<Nivel>(
        title: const Text('Medio'),
        value: Nivel.medio,
        groupValue: _nivel,
        onChanged: (Nivel value) {
          setState(() {
            _nivel = value;
          });
        },
      ),
      RadioListTile<Nivel>(
        title: const Text('Bueno'),
        value: Nivel.bueno,
        groupValue: _nivel,
        onChanged: (Nivel value) {
          setState(() {
            _nivel = value;
          });
        },
      ),
      RadioListTile<Nivel>(
        title: const Text('Excelente'),
        value: Nivel.excelente,
        groupValue: _nivel,
        onChanged: (Nivel value) {
          setState(() {
            _nivel = value;
          });
        },
      ),
    ];
  }

  Widget checkBoxTags(int index) {
    String tag = tags[index][1];
    return CheckboxListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 2),
      title: Text(tag),
      value: tags[index][0],
      onChanged: (newValue) {
        setState(() {
          print(tagsToSend);
          tags[index][0] = newValue;
          tags[index][0]
              ? tagsToSend.add(tags[index][1])
              : tagsToSend.remove(tags[index][1]);
        });
      },
      controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
    );
  }

  Widget gridViewTags() {
    return GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
        crossAxisCount: 2,
        childAspectRatio: 4,
        children: [for (int i = 0; i < tags.length; i++) checkBoxTags(i)]);
  }

  List<String> productsToSend = [];
  List<bool> productban = [];
  List<String> productNames = [];
  Future<List<String>> products = ApiWrapper().getGenericIngredients();

  List<String> get getAllergens {
    print(allergensList);
    allergensList.forEach((element) {
      if (element[0] == true) {
        allergenSend.add("en:" + (element[1]));
      }
    });
    return allergenSend;
  }

  Widget checkBoxBans(int index) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 2),
      title: Text(productNames[index]),
      value: productban[index],
      onChanged: (newValue) async {
        productban[index] = newValue;
        await productban[index]
            ? productsToSend.add(productNames[index])
            : productsToSend.remove(productNames[index]);
        setState(() {});
      },
      controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
    );
  }

  Widget gridViewBans() {
    return GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
        crossAxisCount: 2,
        childAspectRatio: 4,
        children: [
          for (int i = 0; i < productNames.length; i++) checkBoxBans(i)
        ]);
  }
}
