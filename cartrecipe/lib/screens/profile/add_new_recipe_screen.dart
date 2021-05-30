import 'package:cartrecipe/widgets/preferences/product_bans.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:cartrecipe/widgets/perfil/cooking_steps_text_fields.dart';
import 'package:cartrecipe/widgets/perfil/cooking_tips_text_fields.dart';

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

  TextEditingController recipeNameController;
  TextEditingController ingredientsController;
  TextEditingController cookingStepsController;
  TextEditingController cookingTipsController;

  _validateRecipeName() {}
  _validateIngredients() {}
  _validateCookingSteps() {}
  _validateCookingTips() {}

  @override
  void initState() {
    super.initState();
    recipeNameController = TextEditingController();
    recipeNameController = TextEditingController();
    cookingStepsController = TextEditingController();
    cookingTipsController = TextEditingController();
  }

  @override
  void dispose() {
    recipeNameController.dispose();
    recipeNameController.dispose();
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
          //print('Valor 1' + value.toString());
          //print('Valor 2 ${picker.getSelectedValues()}');
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
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      'Ingredientes',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ProductBans(),
                  //..._getCookingTips(),
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
                    onPressed: () {},
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
