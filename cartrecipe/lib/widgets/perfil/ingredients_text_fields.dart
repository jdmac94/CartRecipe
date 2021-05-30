import 'package:cartrecipe/api/api_wrapper.dart';
import 'package:cartrecipe/screens/profile/add_new_recipe_screen.dart';
import 'package:flutter/material.dart';

class IngredientsTextFields extends StatefulWidget {
  final int index;
  IngredientsTextFields(this.index);
  // String dropdownValueIngredient;
  // String dropdownValueUnits;

  @override
  _IngredientsTextFieldsState createState() => _IngredientsTextFieldsState();
  String get productName => _IngredientsTextFieldsState().getIngredient;
  String get unitName => _IngredientsTextFieldsState().getUnits;
}

class _IngredientsTextFieldsState extends State<IngredientsTextFields> {
  TextEditingController unitsController;
  List<String> ingredientsList = [];
  String dropdownValueIngredient = 'Nutella';
  String dropdownValueUnits = "gramos";
  List<String> unitsList = [
    "libras",
    "kilogramos",
    "onzas",
    "gramos",
    "tazas",
    "litros",
    "onzas líquidas",
    "mililitros",
    "cucharadita",
    "cucharada"
  ];

  Map<String, String> pairIngredients = {
    'ingredient': 'aceite',
    'quantity': '0',
    'units': 'gramos',
  };

  get getIngredient => dropdownValueIngredient;

  get getUnits => dropdownValueUnits;

  _validateUnits() {}

  @override
  void initState() {
    unitsController = TextEditingController();
    setState(() {
      ApiWrapper()
          .getGenericIngredients()
          .then((value) => setState(() => ingredientsList = value));
    });
  }

  @override
  void dispose() {
    unitsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   unitsController.text = AddNewRecipeScreenState
    //           .ingredientsFormList[widget.index]['quantity'] ??
    //       '';
    // });

    return Container(
      //width: MediaQuery.of(context).size.width * 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          DropdownButton<String>(
            value: dropdownValueIngredient,
            icon: const Icon(Icons.expand_more),
            iconSize: 24,
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String newValue) {
              setState(() {
                dropdownValueIngredient = newValue;
                pairIngredients['ingredient'] = dropdownValueIngredient;

                AddNewRecipeScreenState.ingredientsFormList[widget.index] =
                    pairIngredients;
              });
            },
            items:
                ingredientsList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          Container(
            width: 40,
            child: TextFormField(
              controller: unitsController,
              keyboardType: TextInputType.number,
              validator: (value) => _validateUnits(),
              onChanged: (v) {
                pairIngredients['quantity'] = v;
                AddNewRecipeScreenState.ingredientsFormList[widget.index] =
                    pairIngredients;
                //print(pairIngredients);
              },
              decoration: InputDecoration(
                hintText: '250',
              ),
            ),
          ),
          DropdownButton<String>(
            value: dropdownValueUnits,
            icon: const Icon(Icons.expand_more),
            iconSize: 24,
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String newValue) {
              setState(() {
                dropdownValueUnits = newValue;
                pairIngredients['units'] = dropdownValueUnits;
                AddNewRecipeScreenState.ingredientsFormList[widget.index] =
                    pairIngredients;
                //['units'] = dropdownValueUnits;
                print(pairIngredients);
              });
            },
            items: unitsList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
