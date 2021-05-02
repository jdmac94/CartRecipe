import 'package:cartrecipe/api/api_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:cartrecipe/models/recipe.dart';
import 'package:cartrecipe/widgets/recipecard.dart';

class RecipesScreen extends StatefulWidget {
  List<Recipe> recipeList;
  @override
  _RecipesScreenState createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  Future<List<Recipe>> recipelist;

  @override
  void initState() {
    super.initState();
    recipelist = ApiWrapper().getRecipeList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _recipeListBody(),
    );
  }

  Widget _recipeListBody() {
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
}
