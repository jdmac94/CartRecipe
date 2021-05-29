import 'package:flutter/material.dart';

class Dieta extends StatefulWidget {
  const Dieta({Key key}) : super(key: key);
  @override
  State<Dieta> createState() => _Dieta();
  bool get getVegan => _Dieta().getVegan;
  bool get getVegetarian => _Dieta().getVegetarian;
  //List<String> get getTagsArray => _Dieta().getTags;
}

enum Dietas { ninguna, vegetariana, vegana }
Dietas _dieta = Dietas.ninguna;

class _Dieta extends State<Dieta> {
  Widget build(BuildContext context) {
    return Column(children: radiobutton());
  }

  bool get getVegan {
    return _dieta.index == 2;
  }

  bool get getVegetarian {
    return _dieta.index == 1;
  }

  List<Widget> radiobutton() {
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
}
