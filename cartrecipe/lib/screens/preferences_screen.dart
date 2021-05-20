import 'package:cartrecipe/screens/tabs_screens.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

import 'package:cartrecipe/models/preferences_list_pages.dart';

class PreferencesScreen extends StatefulWidget {
  PreferencesScreen({Key key}) : super(key: key);

  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

enum Intereses { equilibrado, descubrir, mejorar }
enum Alergenos { si, no }

class _PreferencesScreenState extends State<PreferencesScreen> {
  PageController pageController = PageController(initialPage: 0);
  int pageChangedInt = 0;
  double pageChangedDouble = 0.0;
  int end = 4;
  List<List<dynamic>> allergens = [
    [false, "alcohol"],
    [false, "celery"],
    [false, "corn"],
    [false, "crustaceans"],
    [false, "eggs"],
    [false, "fish"],
    [false, "gluten"],
    [false, "gmo"],
    [false, "meat"],
    [false, "milk"],
    [false, "molluscs"],
    [false, "mustard"],
    [false, "nuts"],
    [false, "peanuts"],
    [false, "pork"],
    [false, "soybeans"],
    [false, "sugar"],
    [false, "sulphites"],
    [false, "trans_fat"],
    [false, "vegan"],
  ];
  Color _color = Colors.grey;
  Intereses _intereses = Intereses.descubrir;
  Alergenos _alergenos = Alergenos.si;

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
                  child: Expanded(child: gridView(pageChangedInt)),
                ),
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
        RadioListTile<Intereses>(
          title: const Text('Comer más equilibrado y sano'),
          value: Intereses.equilibrado,
          groupValue: _intereses,
          onChanged: (Intereses value) {
            setState(() {
              _intereses = value;
            });
          },
        ),
        RadioListTile<Intereses>(
          title: const Text('Mejorar mis habilidades de Cocina'),
          value: Intereses.mejorar,
          groupValue: _intereses,
          onChanged: (Intereses value) {
            setState(() {
              _intereses = value;
            });
          },
        ),
        RadioListTile<Intereses>(
          title: const Text('Descubrir nuevas recetas'),
          value: Intereses.descubrir,
          groupValue: _intereses,
          onChanged: (Intereses value) {
            setState(() {
              _intereses = value;
            });
          },
        ),
      ];
    } else if (pageChangedInt == 1) {
      return <Widget>[
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
      ];
    } else {
      return <Widget>[Container()];
    }
  }

  Widget gridView(pageChangedInt) {
    if (pageChangedInt == 2) {
      return GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 3,
        children: [
          for (int i = 0; i < allergens.length; i++) allergenButton(i)

          /* GestureDetector(
            onTap: () {
              if (_color == Colors.grey)
                _color = Colors.blueAccent;
              else
                _color = Colors.grey;
              setState(() {});
            },
            child: Container(
                padding: const EdgeInsets.all(8),
                color: _color,
                child: new Image.asset(
                    'assets/images/products/allergens/alcohol.png')),
          ),
          GestureDetector(
            onTap: () {
              if (_color == Colors.grey)
                _color = Colors.blueAccent;
              else
                _color = Colors.grey;
              setState(() {});
            },
            child: Container(
                padding: const EdgeInsets.all(8),
                color: _color,
                child: new Image.asset(
                    'assets/images/products/allergens/celery.png')),
          ),*/
        ],
      );
    } else {
      return Container();
    }
  }

  Widget allergenButton(int allergenNumber) {
    String imagePath = allergens[allergenNumber][1];
    return GestureDetector(
      onTap: () {
        if (allergens[allergenNumber][0]) {
          allergens[allergenNumber][0] = false;
          _color = Colors.blueAccent;
        } else {
          allergens[allergenNumber][0] = true;
          _color = Colors.grey;
        }
        setState(() {});
      },
      child: Container(
          padding: const EdgeInsets.all(8),
          color: _color,
          child: new Image.asset(
              'assets/images/products/allergens/$imagePath.png')),
    );
  }

  Widget buildButton(pageChangedInt) {
    if (pageChangedInt == 3) {
      return ElevatedButton(
          child: Text('Cerrar'),
          onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              new MaterialPageRoute(
                builder: (context) => new TabsScreen(0),
              ),
              (r) => false));
    } else {
      return ElevatedButton(
        child: Text('Adelante'),
        onPressed: () => pageChangedInt++,
      );
    }
  }
}
