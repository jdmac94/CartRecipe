import 'package:cartrecipe/api/api_wrapper.dart';
import 'package:cartrecipe/models/recipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:cartrecipe/widgets/perfil/cooking_steps_text_fields.dart';
import 'package:cartrecipe/widgets/perfil/cooking_tips_text_fields.dart';
import 'package:cartrecipe/widgets/perfil/ingredients_text_fields.dart';

class AddNewRecipeScreen extends StatefulWidget {
  AddNewRecipeScreen({Key key}) : super(key: key);

  @override
  AddNewRecipeScreenState createState() => AddNewRecipeScreenState();
}

class AddNewRecipeScreenState extends State<AddNewRecipeScreen> {
  int _currentDifficulty = 3;
  int _currentCookingTime = 45;
  final _formKey = GlobalKey<FormState>();
  static List<String> cookingTipsList = [null];
  static List<String> cookingStepsList = [null];
  static List<dynamic> ingredientsFormList = [null];

  TextEditingController recipeNameController;
  TextEditingController unitsController;
  TextEditingController cookingStepsController;
  TextEditingController cookingTipsController;

  _validateRecipeName() {}
  _validateUnits() {}
  _validateIngredients() {}
  _validateCookingSteps() {}
  _validateCookingTips() {}

  @override
  void initState() {
    super.initState();
    recipeNameController = TextEditingController();
    unitsController = TextEditingController();
    cookingStepsController = TextEditingController();
    cookingTipsController = TextEditingController();
  }

  @override
  void dispose() {
    recipeNameController.dispose();
    unitsController.dispose();
    cookingStepsController.dispose();
    cookingTipsController.dispose();
    super.dispose();
  }

  _chooseDifficulty(BuildContext context) {
    new Picker(
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(begin: 1, end: 5),
        ]),
        hideHeader: true,
        title: new Text("Selecciona una dificultad"),
        onConfirm: (Picker picker, List value) {
          setState(() => _currentDifficulty = picker.getSelectedValues().first);
        }).showDialog(context);
  }

  _chooseCookingTime(BuildContext context) {
    new Picker(
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(begin: 10, end: 90),
        ]),
        hideHeader: true,
        title: new Text("Tiempo de cocina (en minutos)"),
        onConfirm: (Picker picker, List value) {
          setState(
              () => _currentCookingTime = picker.getSelectedValues().first);
        }).showDialog(context);
  }

  List<Widget> _getCookingSteps() {
    List<Widget> friendsTextFieldsList = [];
    for (int i = 0; i < cookingStepsList.length; i++) {
      friendsTextFieldsList.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Expanded(child: CookingStepsTextFields(i)),
            SizedBox(
              width: 16,
            ),
            // we need add button at last friends row only
            _addRemoveCookingStepsButton(i == cookingStepsList.length - 1, i),
          ],
        ),
      ));
    }
    return friendsTextFieldsList;
  }

  List<Widget> _getCookingTips() {
    List<Widget> friendsTextFieldsList = [];
    for (int i = 0; i < cookingTipsList.length; i++) {
      friendsTextFieldsList.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Expanded(child: CookingTipsTextFields(i)),
            SizedBox(
              width: 16,
            ),
            // we need add button at last friends row only
            _addRemoveCookingTipsButton(i == cookingTipsList.length - 1, i),
          ],
        ),
      ));
    }
    return friendsTextFieldsList;
  }

  Widget _addRemoveCookingStepsButton(bool add, int index) {
    return InkWell(
      onTap: () {
        if (add) {
          // add new text-fields at the top of all friends textfields
          cookingStepsList.insert(0, null);
        } else
          cookingStepsList.removeAt(index);
        setState(() {});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }

  List<Widget> _getIngredientsForm() {
    List<Widget> friendsTextFieldsList = [];
    for (int i = 0; i < ingredientsFormList.length; i++) {
      friendsTextFieldsList.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Expanded(child: IngredientsTextFields(i)),
            SizedBox(
              width: 16,
            ),
            // we need add button at last friends row only
            _addRemoveIngredientsButton(i == ingredientsFormList.length - 1, i),
          ],
        ),
      ));
    }
    return friendsTextFieldsList;
  }

  Widget _addRemoveCookingTipsButton(bool add, int index) {
    return InkWell(
      onTap: () {
        if (add) {
          // add new text-fields at the top of all friends textfields
          cookingTipsList.insert(0, null);
        } else
          cookingTipsList.removeAt(index);
        setState(() {});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _addRemoveIngredientsButton(bool add, int index) {
    return InkWell(
      onTap: () {
        if (add) {
          // add new text-fields at the top of all friends textfields
          ingredientsFormList.insert(0, null);
        } else
          ingredientsFormList.removeAt(index);
        setState(() {});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }

  _createRecipe() {
    print('******----******');
    print('La receta se llama ${recipeNameController.text}');
    print('Su dificultad es $_currentDifficulty');
    print('Se tarda $_currentCookingTime tiempo en hacerla');
    print('El listado de ingredientes es:');
    List<Map<String, List<String>>> dictList = [];
    for (int i = 0; i < ingredientsFormList.length; i++) {
      print('El ingrediente ${i + 1} es ${ingredientsFormList[i]}');
      Map<String, List<String>> dict = {};
      dict[ingredientsFormList[i]['ingredient']] = [
        ingredientsFormList[i]['quantity'],
        ingredientsFormList[i]['units']
      ];

      dictList.add(dict);
    }
    int i = 1;
    cookingStepsList.reversed.forEach((element) {
      print('El paso $i es $element');
      i++;
    });
    i = 1;
    cookingTipsList.reversed.forEach((element) {
      print('El truco $i es $element');
      i++;
    });
    print(dictList);

    Recipe receta = Recipe(
      titulo: recipeNameController.text,
      dificultad: _currentDifficulty,
      tiempo: _currentCookingTime.toString(),
      ingredientes: dictList,
      pasos: cookingStepsList.reversed.toList(),
      consejos: cookingTipsList.reversed.toList(),
      imagenes: [
        'https://static.openfoodfacts.org/images/products/843/701/703/2298/front_es.21.full.jpg'
      ],
      comensales: 2,
      tags: ['Arroces', 'Asiático'],
    );

    ApiWrapper().createOwnRecipe(receta);
    //Titulo
    //Dificultad
    //Tiempo (string)
    //Lista ingredientes ---- { "garbanzos cocidos": ["400", "gramos"] },
    //Lista pasos [array string]
    //Lista imagenes [array string]
    //Lista trucos / consejos
    //Lista categorias
    //Lista alergenos

    //print('Ingredientes seleccionados: $ingredientsList');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nueva receta propia'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    'Nombre de la receta',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Patatas al horno',
                    ),
                    controller: recipeNameController,
                    validator: (value) => _validateRecipeName(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    child: Text(
                      'Ingredientes',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ..._getIngredientsForm(),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      'Pasos',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ..._getCookingSteps(),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      'Trucos y consejos',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ..._getCookingTips(),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Dificultad',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text('$_currentDifficulty'),
                            ElevatedButton(
                                child: Text('Ajustar dificultad'),
                                onPressed: () => _chooseDifficulty(context)),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'Tiempo',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text('$_currentCookingTime'),
                            ElevatedButton(
                                child: Text('Ajustar tiempo'),
                                onPressed: () => _chooseCookingTime(context)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    child: Text('Crear receta'),
                    onPressed: () => _createRecipe(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
