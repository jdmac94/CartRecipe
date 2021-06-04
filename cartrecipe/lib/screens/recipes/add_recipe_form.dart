import 'package:flutter/material.dart';

class AddRecipeForm extends StatefulWidget {
  @override
  _AddRecipeFormState createState() => _AddRecipeFormState();
}

// WIP
class _AddRecipeFormState extends State<AddRecipeForm> {
  final _formKey = GlobalKey<FormState>();
  int _ingredientCount = 1;
  int _stepCount = 1;
  int _tipCount = 1;
  List<TextFormField> _ingredientChildren = [
    //No necesitamos validation, si no hay nada añadido, ignoramos
  ];
  List<Widget> _stepChildren = [];
  List<Widget> _tipChildren = [];

  @override
  void initState() {
    _ingredientChildren = List.from(_ingredientChildren)
      ..add(TextFormField(
          decoration: const InputDecoration(
        labelText: 'Ingrediente',
      )));

    _stepChildren = List.from(_stepChildren)
      ..add(TextFormField(
          decoration: const InputDecoration(
        labelText: 'Paso 1',
      )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: Icon(
            Icons.clear,
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          InkWell(
            child: Icon(
              Icons.check,
              color: Colors.white,
            ),
            onTap: () {
              //On tap we will submit the form
              if (_formKey.currentState.validate()) {
                print('Formulario correcto!');
              } else {
                print('Formulario incorrecto!');
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: _addRecipeFormBody(),
      ),
    );
  }

  /*//TODO: FORMULARIO DE RECETA QUE CONTENGA LO SIGUIENTE:
  //  Nombre receta, Tiempo receta [HH | MM], dificultad, porciones
      [Formularios multiples, que se pueden incrementar]
      Pasos, Ingredientes (nombre + cantidad), consejos
  //  Imagen - ultima cosa a hacer
  */
  Widget _addRecipeFormBody() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              //Nombre de la receta
              decoration: const InputDecoration(
                labelText: 'Nombre de la receta',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Introduce el nombre de la receta';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'HH',
              ),
              // Tiempo de preparacion (Horas)
              keyboardType: TextInputType.number,
              enableInteractiveSelection: false, //Avoid pasting text
              validator: (horas) {
                if (horas != null && horas.isNotEmpty) {
                  final int intHoras = int.parse(horas);
                  if (intHoras < 0) {
                    return 'Introduce valor mayor o igual a 0 en las horas';
                  }
                }
                return null;
              },
            ),
            TextFormField(
              //Tiempo de preparacion (Minutos)
              decoration: const InputDecoration(
                labelText: 'MM',
              ),
              enableInteractiveSelection: false,
              keyboardType: TextInputType.number,
              validator: (minutos) {
                // Por ahora dejaremos que pueda añadir valores mayores de 60 minutos, se lo añadiremos a las horas si eso
                if (minutos != null && minutos.isNotEmpty) {
                  final int intMinutos = int.parse(minutos);
                  if (intMinutos < 0) {
                    return 'Introduce valor mayor o igual a 0 en los minutos';
                  }
                }
                return null;
              },
            ),
            TextFormField(
              //Porciones
              // TODO: Controlar decimales y texto con en la validacion con Regex
              decoration: const InputDecoration(
                labelText: 'Porciones',
              ),
              keyboardType: TextInputType.number,
              validator: (porciones) {
                if (int.parse(porciones) < 1) {
                  return 'Introduce valor mayor o igual a 1 en las porciones';
                }
                return null;
              },
            ),

            //Ingredient list
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => _addIngredientForm(),
            ),

            ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: _ingredientChildren,
            ),
          ],
        ),
      ),
    );
  }

  void _addIngredientForm() {
    _ingredientChildren = List.from(_ingredientChildren)
      ..add(TextFormField(
        decoration: const InputDecoration(
          labelText: 'Ingrediente',
        ),
        //No necesitamos validation, si no hay nada añadido, ignoramos
      ));
    setState(() => _ingredientCount++);
  }
}
