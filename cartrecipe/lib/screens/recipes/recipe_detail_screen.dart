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
              widget.recipe.imagenes[0], // TODO
              height: 200, // watch out
              fit: BoxFit.cover,
            ),
            _buildIntroductionDetails(),
            Divider(height: 10, thickness: 3, indent: 20, endIndent: 20),
            widget.recipe.ingredientes.isEmpty
                ? Text('No se han encontrado ingredientes!')
                : _buildIngredientList2(),
            Divider(height: 10, thickness: 3, indent: 20, endIndent: 20),
            //_buildPortionAmount(), // Revisar excepcion
            widget.recipe.pasos.isEmpty
                ? Text('No hay pasos para esta receta!')
                : _buildRecipeSteps(),
            Divider(height: 10, thickness: 3, indent: 20, endIndent: 20),
            widget.recipe.consejos.isEmpty ? Text('') : _buildRecipeTips(),
            Divider(height: 10, thickness: 3, indent: 20, endIndent: 20),
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
                  widget.recipe.titulo,
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
                    widget.recipe.tiempo,
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
                    rating: this.widget.recipe.dificultad.toDouble(),
                    itemCount: 5,
                    itemSize: 20,
                    itemBuilder: (context, index) {
                      if (this.widget.recipe.dificultad <= 2) {
                        return Icon(
                          Icons.local_fire_department,
                          color: Colors.green[600],
                        );
                      } else if (this.widget.recipe.dificultad <= 4) {
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
                        this.widget.recipe.usuario,
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: _getRecipeAllergyIcons(this.widget.recipe),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientList2() {
    //Iterate through the different maps.
    List<Widget> ingredientList = [];
    for (var i = 0; i < widget.recipe.ingredientes.length; i++) {
      // Get map value.
      Map<String, List<String>> currentMap = widget.recipe.ingredientes[i];
      String indexKey = currentMap.keys.first;
      // currentMap[indexKey][0] is the name
      // currentMap[indexKey][1] is the value
      ingredientList.add(new Row(children: <Widget>[
        Icon(Icons.fiber_manual_record, size: 9),
        Expanded(
            child: Text(
          currentMap[indexKey][0] +
              " - " +
              currentMap[indexKey][1] +
              currentMap[indexKey][2],
        ))
      ]));
    }
    return Container(
      child: Column(
        children: <Widget>[
          Center(
            child: Text("Ingredients"),
          ),
          Center(
            child: ListView(
              padding: EdgeInsets.all(10),
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: ingredientList,
            ),
          ),
        ],
      ),
    );
  }

/*
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
      itemCount: widget.recipe.ingredientes.length,
    );
  }
*/
  Widget _buildRecipeSteps() {
    return Column(
      children: <Widget>[
        Center(
          child: Text("Pasos"),
        ),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: widget.recipe.pasos.length,
          itemBuilder: (context, index) => Container(
            child: ListTile(
              leading: CircleAvatar(
                child: Text('${(index + 1)}'),
                radius: 15,
              ),
              title: Text(widget.recipe.pasos[index]),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildRecipeTips() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: widget.recipe.consejos.length,
      itemBuilder: (context, index) => ListTile(
          leading: CircleAvatar(
            child: Text('*'),
            radius: 15,
          ),
          title: Text(widget.recipe.consejos[index])),
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

  List<Widget> _getRecipeAllergyIcons(Recipe r) {
    return <Widget>[
      Image.asset(
        //TODO: get list of products and return n values, currently returning one
        //      allergy
        "assets/images/allergies/egg.png",
        height: 50,
        width: 50,
      )
    ];
  }
}
