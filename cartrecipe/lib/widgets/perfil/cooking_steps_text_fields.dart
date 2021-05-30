import 'package:cartrecipe/screens/profile/add_new_recipe_screen.dart';
import 'package:flutter/material.dart';

class CookingStepsTextFields extends StatefulWidget {
  //IngredientsTextFields({Key key}) : super(key: key);

  final int index;
  CookingStepsTextFields(this.index);

  @override
  _CookingStepsTextFieldsState createState() => _CookingStepsTextFieldsState();
}

class _CookingStepsTextFieldsState extends State<CookingStepsTextFields> {
  TextEditingController _nameController;

  @override
  void initState() {
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _nameController.text =
          AddNewRecipeScreenState.cookingStepsList[widget.index] ?? '';
    });

    return TextFormField(
      controller: _nameController,
      onChanged: (v) =>
          AddNewRecipeScreenState.cookingStepsList[widget.index] = v,
      decoration: InputDecoration(hintText: 'Cortar las patatas en láminas...'),
      validator: (v) {
        if (v.trim().isEmpty) return 'Escribe los pasos a seguir';
        return null;
      },
    );
  }
}
