import 'package:flutter/material.dart';

class WantedTags extends StatefulWidget {
  const WantedTags({Key key}) : super(key: key);
  @override
  State<WantedTags> createState() => _WantedTags();
  List<String> get getTagsArray => _WantedTags().getTags;
}

class _WantedTags extends State<WantedTags> {
  Widget build(BuildContext context) {
    return gridView();
  }

  List<String> get getTags {
    return tagsToSend;
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

  Widget gridView() {
    return GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
        crossAxisCount: 2,
        childAspectRatio: 4,
        children: [for (int i = 0; i < tags.length; i++) checkBox(i)]);
  }
}
