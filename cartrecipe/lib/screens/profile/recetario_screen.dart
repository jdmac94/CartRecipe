import 'package:cartrecipe/screens/profile/add_new_recipe_screen.dart';
import 'package:flutter/material.dart';

class RecetearioScreen extends StatefulWidget {
  @override
  _RecetearioScreenState createState() => _RecetearioScreenState();
}

class _RecetearioScreenState extends State<RecetearioScreen> {
  Future<void> _addRecipeForm() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Title'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text('Txt1'),
                  Text('Txt1'),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text('Cerrar'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

  Future<T> _pushPage<T>(BuildContext context) {
    return Navigator.of(context)
        .push<T>(MaterialPageRoute(builder: (context) => AddNewRecipeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recetario'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _pushPage(context),
          )
        ],
      ),
      body: Container(
        child: Center(
          child: Text('No hay ninguna receta creada'),
        ),
      ),
    );
  }
}
