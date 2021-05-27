import 'package:flutter/material.dart';

class Dieta extends StatefulWidget {
  const Dieta({Key key}) : super(key: key);
  @override
  State<Dieta> createState() => _Dieta();
  //List<String> get getTagsArray => _Dieta().getTags;
}

enum Dietas { ninguna, vegetariana, vegana }
Dietas _dieta = Dietas.ninguna;

class _Dieta extends State<Dieta> {
  Widget build(BuildContext context) {
    return Column(children: radiobutton());
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
