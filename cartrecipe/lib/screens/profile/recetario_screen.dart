import 'package:cartrecipe/api/api_wrapper.dart';
import 'package:cartrecipe/models/recipe.dart';
import 'package:cartrecipe/screens/profile/add_new_recipe_screen.dart';
import 'package:cartrecipe/widgets/recipes/recipe_card.dart';
import 'package:flutter/material.dart';

class RecetearioScreen extends StatefulWidget {
  List<Recipe> recipeList;
  @override
  _RecetearioScreenState createState() => _RecetearioScreenState();
}

class _RecetearioScreenState extends State<RecetearioScreen> {
  Future<List<Recipe>> recipelist;

  @override
  void initState() {
    super.initState();
    recipelist = ApiWrapper().getRecipeList();
  }

  Future<T> _pushPage<T>(BuildContext context) {
    return Navigator.of(context)
        .push<T>(MaterialPageRoute(builder: (context) => AddNewRecipeScreen()));
  }

  Widget _getOwnRecipes() {
    return FutureBuilder(
      builder: (context, recipeSnap) {
        if (recipeSnap.connectionState == ConnectionState.none &&
            recipeSnap.hasData == null) {
          return Container(); // Do not show anything
        }
        return ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: recipeSnap?.data?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            Recipe newRecipe = recipeSnap.data[index];
            return RecipeCard(
              recipe: newRecipe,
            );
          },
        );
      },
      future: recipelist,
    );
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
      body: _getOwnRecipes(),
    );
  }
}
