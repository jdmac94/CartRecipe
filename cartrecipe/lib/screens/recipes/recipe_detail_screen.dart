import 'package:flutter/material.dart';
import 'package:cartrecipe/models/recipe.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RecipeDetail extends StatefulWidget {
  Recipe recipe;
  int portions;

  RecipeDetail(Recipe r) {
    recipe = r;
    portions = 1;
  }

  @override
  _RecipeDetailState createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Temporary solution to not showing bottom navigation bar
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.favorite_border),
            color: Colors.white, // Implementar funcion like
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.share),
            color: Colors.white,
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            //1. Image of the recipe
            //2. Titulo, tiempo, dificultad, we will add allergies later
            //3. Ingredient list
            //4. Steps
            //5. Tips
            Image.network(
              widget.recipe.image,
              height: 200, // watch out
              fit: BoxFit.cover,
            ),
            _buildIntroductionDetails(),
            widget.recipe.ingredients.isEmpty
                ? Text('No se han encontrado ingredientes!')
                : _buildIngredientList(),
            //_buildPortionAmount(), // Revisar excepcion
            widget.recipe.steps.isEmpty
                ? Text('No hay pasos para esta receta!')
                : _buildRecipeSteps(),
            widget.recipe.tips.isEmpty ? Text('') : _buildRecipeTips(),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroductionDetails() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          //1. Text Recipe name, Chip of duration
          //2. Difficulty rate, (later on) allergies
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Text(
                  widget.recipe.recipeName,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              Chip(
                  avatar: Icon(
                    Icons.timer,
                  ),
                  label: Text(
                    widget.recipe.time,
                  ))
            ],
          ),
          Row(
            children: [
              Column(
                children: <Widget>[
                  Text(
                    'Dificultad:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  RatingBarIndicator(
                    rating: this.widget.recipe.difficulty.toDouble(),
                    itemCount: 5,
                    itemSize: 20,
                    itemBuilder: (context, index) {
                      if (this.widget.recipe.difficulty <= 2) {
                        return Icon(
                          Icons.local_fire_department,
                          color: Colors.green[600],
                        );
                      } else if (this.widget.recipe.difficulty <= 4) {
                        return Icon(
                          Icons.local_fire_department,
                          color: Colors.orange[600],
                        );
                      } else {
                        return Icon(
                          Icons.local_fire_department,
                          color: Colors.red,
                        );
                      }
                    },
                  ),
                  Row(
                    children: [
                      Text('Creado por:'),
                      Text(
                        this.widget.recipe.user,
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientList() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Card(
          color: Theme.of(context).accentColor,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 10,
            ),
            child: Text(widget.recipe.ingredients[index].cantidad.toString() +
                "x " +
                widget.recipe.ingredients[index].nombre),
          ),
        );
      },
      itemCount: widget.recipe.ingredients.length,
    );
  }

  Widget _buildRecipeSteps() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: widget.recipe.steps.length,
      itemBuilder: (context, index) => Container(
        child: ListTile(
          leading: CircleAvatar(
            child: Text('${(index + 1)}'),
          ),
          title: Text(widget.recipe.steps[index]),
        ),
        decoration: BoxDecoration(
            border: Border.all(
          width: 1.0,
          color: Colors.black,
        )),
      ),
    );
  }

  Widget _buildRecipeTips() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: widget.recipe.tips.length,
      itemBuilder: (context, index) => ListTile(
          leading: CircleAvatar(
            child: Text('*'),
          ),
          title: Text(widget.recipe.tips[index])),
    );
  }

  //NO INTRODUCIR ESTE WIDGET AUN, PORQUE PETARÁ
  Widget _buildPortionAmount() {
    return Container(
      child: Row(
        children: <Widget>[
          InkWell(
              //Lower portions
              onTap: () {
                if (widget.portions > 1) {
                  widget.portions--;
                  setState(() {});
                }
              },
              child: Icon(
                Icons.exposure_minus_1,
              )),
          Text(
            widget.portions.toString(),
            style: TextStyle(
              fontSize: 23,
            ),
          ),
          InkWell(
            onTap: () {
              if (widget.portions < 100) {
                widget.portions++;
                setState(() {});
              }
            },
          ),
        ],
      ),
    );
  }
}
