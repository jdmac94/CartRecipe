import 'package:flutter/material.dart';

class NivelCocina extends StatefulWidget {
  const NivelCocina({Key key}) : super(key: key);
  @override
  State<NivelCocina> createState() => _NivelCocina();
  int get getNivel => _NivelCocina().getNivel;
}

enum Nivel { ninguno, bajo, medio, bueno, excelente }
Nivel _nivel = Nivel.medio;

class _NivelCocina extends State<NivelCocina> {
  Widget build(BuildContext context) {
    return Column(children: radiobutton());
  }

  int get getNivel {
    return (_nivel.index + 1);
  }

  List<Widget> radiobutton() {
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
}
