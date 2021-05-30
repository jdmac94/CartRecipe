import 'package:flutter/material.dart';

class Allergens extends StatefulWidget {
  @override
  State<Allergens> createState() => _Allergens();
  List<dynamic> get getAllergensArray => _Allergens().getAllergens;
  static Allergens _instance;
  Allergens._internal() {
    _instance = this;
  }
  factory Allergens() => _instance ?? Allergens._internal();
}

class _Allergens extends State<Allergens> {
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
  Widget build(BuildContext context) {
    return gridViewAlergenos();
  }

  List<String> get getAllergens {
    print(allergensList);
    allergensList.forEach((element) {
      if (element[0] == true) {
        allergenSend.add("en:" + (element[1]));
      }
    });
    return allergenSend;
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
