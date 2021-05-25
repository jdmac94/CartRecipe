import 'package:cartrecipe/screens/tabs_screens.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:cartrecipe/api/api_wrapper.dart';

import 'package:cartrecipe/models/preferences_list_pages.dart';

class PreferencesScreen extends StatefulWidget {
  PreferencesScreen({Key key}) : super(key: key);

  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

enum Dieta { ninguna, vegetariana, vegana }
enum Alergenos { si, no }
enum Nivel { ninguno, bajo, medio, bueno, excelente }

class _PreferencesScreenState extends State<PreferencesScreen> {
  PageController pageController = PageController(initialPage: 0);
  int pageChangedInt = 0;
  double pageChangedDouble = 0.0;
  int end = 5;
  List<String> allergenArray = [];
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
  Dieta _dieta = Dieta.vegetariana;
  Alergenos _alergenos = Alergenos.no;
  Nivel _nivel = Nivel.medio;
  bool checkedValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView.builder(
            pageSnapping: true,
            controller: pageController,
            onPageChanged: (index) {
              setState(() {
                pageChangedInt = index;
                pageChangedDouble = index.toDouble();
              });
            },
            itemCount: listPages.length,
            itemBuilder: (context, index) {
              return Column(children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      listPages[pageChangedInt].title,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 40),
                    child: Text(
                      listPages[pageChangedInt].subtitle,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Container(
                    child: Column(
                  children: radiobutton(pageChangedInt),
                )),
                Container(
                  child: Expanded(child: gridViewAlergenos(pageChangedInt)),
                ),
                Container(
                    child: Expanded(
                  child: gridView(pageChangedInt),
                )),
                Align(
                    //Este es para alinear bien todos losPageview
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Visibility(
                          visible: pageChangedInt == 3,
                          child: SizedBox(
                            height: 22,
                            //child: Text("hola"),
                          )),
                    )),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0, bottom: 13),
                    child: DotsIndicator(
                      dotsCount: listPages.length,
                      position: pageChangedDouble,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      child: buildButton(pageChangedInt),
                    ),
                  ),
                ),
              ]);
            }));
  }

  List<Widget> radiobutton(int pageChangedInt) {
    if (pageChangedInt == 0) {
      return <Widget>[
        RadioListTile<Dieta>(
          title: const Text('No'),
          value: Dieta.ninguna,
          groupValue: _dieta,
          onChanged: (Dieta value) {
            setState(() {
              _dieta = value;
            });
          },
        ),
        RadioListTile<Dieta>(
          title: const Text('Sigo una dieta vegana'),
          value: Dieta.vegana,
          groupValue: _dieta,
          onChanged: (Dieta value) {
            setState(() {
              _dieta = value;
            });
          },
        ),
        RadioListTile<Dieta>(
          title: const Text('Sigo una dieta vegetariana'),
          value: Dieta.vegetariana,
          groupValue: _dieta,
          onChanged: (Dieta value) {
            setState(() {
              _dieta = value;
            });
          },
        ),
      ];
    } else if (pageChangedInt == 1) {
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
    } else if (pageChangedInt == 2) {
      return <Widget>[
        RadioListTile<Alergenos>(
          title: const Text('No'),
          value: Alergenos.no,
          groupValue: _alergenos,
          onChanged: (Alergenos value) {
            setState(() {
              _alergenos = value;
            });
          },
        ),
        RadioListTile<Alergenos>(
          title: const Text('Si'),
          value: Alergenos.si,
          groupValue: _alergenos,
          onChanged: (Alergenos value) {
            setState(() {
              _alergenos = value;
            });
          },
        ),
      ];
    } else {
      return <Widget>[Container()];
    }
  }

  Widget gridViewAlergenos(int pageChangedInt) {
    return Visibility(
        visible: (pageChangedInt == 2 && (_alergenos == Alergenos.si)),
        maintainState: true,
        maintainAnimation: true,
        maintainSize: true,
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

  Widget gridView(int pageChangedInt) {
    if (pageChangedInt == 3) {
      return GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
          crossAxisCount: 2,
          childAspectRatio: 4,
          children: [for (int i = 0; i < tags.length; i++) checkBox(i)]);
    } else
      return Container();
  }

  Widget checkBox(int index) {
    String tag = tags[index][1];
    return CheckboxListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 2),
      title: Text(tag),
      value: tags[index][0],
      onChanged: (newValue) {
        setState(() {
          tags[index][0] = newValue;
          tags[index][0]
              ? tagsToSend.add(tags[index][1])
              : tagsToSend.remove(tags[index][1]);
        });
      },
      controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
    );
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

  Widget buildButton(pageChangedInt) {
    return Visibility(
        visible: pageChangedInt == 5,
        maintainState: true,
        maintainAnimation: true,
        maintainSize: true,
        child: ElevatedButton(
            child: Text('Cerrar'),
            onPressed: () => {
                  allergensList.forEach((element) {
                    if (element[0] == true)
                      allergenArray.add("en:" + (element[1]));
                  }),
                  ApiWrapper().fillPreferences(
                      _dieta.index == 2,
                      _dieta.index == 1,
                      allergenArray,
                      (_nivel.index + 1),
                      tagsToSend),
                  print(allergensList),
                  print(_alergenos),
                  print(_dieta),
                  print(tagsToSend),
                  Navigator.pushAndRemoveUntil(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => new TabsScreen(0),
                      ),
                      (r) => false)
                }));
  }
}
