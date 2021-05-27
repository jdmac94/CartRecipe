import 'package:flutter/material.dart';

class Allergens extends StatefulWidget {
  const Allergens({Key key}) : super(key: key);
  @override
  State<Allergens> createState() => _Allergens();
  List<List<dynamic>> get getAllergensArray => _Allergens().getAllergens;
}

class _Allergens extends State<Allergens> {
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
  Widget build(BuildContext context) {
    return gridViewAlergenos();
  }

  List<List<dynamic>> get getAllergens {
    return allergensList;
  }

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
}
