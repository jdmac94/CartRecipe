import 'package:cartrecipe/screens/profile/add_new_recipe_screen.dart';
import 'package:flutter/material.dart';

class CookingTipsTextFields extends StatefulWidget {
  //IngredientsTextFields({Key key}) : super(key: key);

  final int index;
  CookingTipsTextFields(this.index);

  @override
  _CookingTipsTextFieldsState createState() => _CookingTipsTextFieldsState();
}

class _CookingTipsTextFieldsState extends State<CookingTipsTextFields> {
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
          AddNewRecipeScreenState.cookingTipsList[widget.index] ?? '';
    });

    return TextFormField(
      controller: _nameController,
      onChanged: (v) =>
          AddNewRecipeScreenState.cookingTipsList[widget.index] = v,
      decoration: InputDecoration(hintText: 'Escoger patatas pequeñas para...'),
      validator: (v) {
        if (v.trim().isEmpty) return 'Escribe trucos de cocina, si existe';
        return null;
      },
    );
  }
}
