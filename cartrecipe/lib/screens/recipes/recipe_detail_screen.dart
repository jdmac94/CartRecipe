import 'package:dots_indicator/dots_indicator.dart';
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

/*
IDEA: 

  IMAGEN - OK
  NOMBRE RECETA
  TIEMPO, DIFICULTAD, Nº COMENSALES
  ALERGENOS(?)
  USUARIO CREACION
  INGREDIENTES
  PASOS
  CONSEJOS

*/
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
            // Image.network( 
            //   widget.recipe.imagenes[0], 
            //   height: 200, // maybe set this depending on size of the screen?
            //   fit: BoxFit.cover,
            // ),
            
            Image.network(
                  widget.recipe.imagenes[0],
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                
            _getRecipeName(),
            _getRecipeBasicInformation(),
            _getUsername(),
            _buildAllergyList(),
            // TODO: REMOVE _buildIntroductionDetails(),
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
            widget.recipe.consejos.isEmpty ? Container() : _buildRecipeTips(),
            //Divider(height: 10, thickness: 3, indent: 20, endIndent: 20),
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
        CircleAvatar(
          radius: 5.0
        ), // Replace to circleavatar
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(3),
            child: Text(
              indexKey + " - " + 
              currentMap[indexKey][0] + " " +
              currentMap[indexKey][1], 
            ),
          ),
        ),        
      ]));
    }
    return Container(
      child: Column(
        children: <Widget>[
          Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text("Ingredientes", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
            ),
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
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text("Pasos", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
            ),
          ),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: widget.recipe.pasos.length,
          itemBuilder: (context, index) => Container(
            child: Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.black87, width: 0.2),
                borderRadius: BorderRadius.circular(2.0),
              ),
              child: ListTile(
              leading: CircleAvatar(
                child: Text('${(index + 1)}'),
                radius: 15,
              ),
              title: Text(widget.recipe.pasos[index]),
            )),
          ),
        )
      ],
    );
  }

  Widget _buildRecipeTips() {
    
    return Column(
      children: <Widget>[
        Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text("Trucos y consejos", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
            ),
          ),
        ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: widget.recipe.consejos.length,
        itemBuilder: (context, index) => Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.black87, width: 0.2),
                  borderRadius: BorderRadius.circular(2.0),
                ), child: ListTile(
            leading: CircleAvatar(
              child: Text('*'),
              radius: 15,
            ),
            title: Text(widget.recipe.consejos[index])),
      ))
      ],
    ) ;
  }

  //NO INTRODUCIR ESTE WIDGET AUN, PORQUE PETARÁ
  //TODO: Editar COMPLETAMENTE esto ya que será un chip con el valor fijo de comensales
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
        //TODO: return images of all allergies found in this recipe, (multiple ifs in a gridview?)
        //      allergy
        "assets/images/allergies/egg.png",
        height: 50,
        width: 50,
      )
    ];
  }

  //Return a Widget that shows the name of the recipe formatted.
  Widget _getRecipeName() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal:50.0, vertical: 20.0),
        child: Text(
          widget.recipe.titulo,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            // Set a better font
          ),
        ),
      ),
    );
  }

  // Show the time of the recipe, its difficulty and number of users
  Widget _getRecipeBasicInformation() {
    return Container(
      color: Colors.transparent,
      child: Row( //Row with some kind of border/background?
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        
        children: <Widget>[
          Chip(
            backgroundColor: Colors.transparent,
            avatar: Icon(
                    Icons.timer,
                    color: Colors.grey[700],
                  ),
                  label: Text(
                    widget.recipe.tiempo,
                    style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold),
                  )
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
          Chip(
            backgroundColor: Colors.transparent,
            avatar: Icon(
                    Icons.restaurant,
                    color: Colors.grey[700],
                  ),
                  label: Text(
                    widget.recipe.comensales.toString(), //TODO:Change this to number of servings
                    style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold),
                  )
          )
        ],
      ),
    );
  }

  Widget _getUsername() {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          children: <Text>[
            Text(
              "Creado por: "
            ),
            Text(
              widget.recipe.usuario,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ) ,
    );
  }

  
  Widget _buildAllergyList() {
    List<String> allergens = ["en:gluten", "en:oats", "en:crustaceans", "en:eggs", "en:fish", "en:peanuts", "en:soybeans", "en:milk", "en:nuts", "en:celery", "en:mustard", "en:sesame-seeds", "en:sulphur-dioxide-and -sulphites", "en:lupin", "en:molluscs"];
    List<Chip> allergyList = [];

    for (String allergy in widget.recipe.allergenList) {
      if (allergens.contains(allergy)) {
        
        allergyList.add(
          Chip( // Una idea para remarcar las alergias del usuario seria cambiar el color del chip en caso de tener la alergia, o mostrar un icono de aviso junto la alergia.
            label: Text(getFormattedAllergyName(allergy)),
          )
        );
      }
    }

    if (allergyList.isEmpty) { 
      return Container();
    }
    return Container(
      child: Column(
        children: <Widget>[
          Divider(height: 10, thickness: 3, indent: 20, endIndent: 20),
          Center(
            child:Text(
            'Alergias'
            )
          ),
          Wrap(
              children: allergyList,
            ),
          
        ],
      ),
    );
  }

  String getFormattedAllergyName(String allergy) {
    if (allergy == "en:gluten") 
      return "gluten";
    else if (allergy == "en:oats")
      return "avena";
    else if (allergy == "en:crustaceans")
      return "crustaceos";
    else if (allergy == "en:eggs")
      return "huevos";
    else if (allergy == "en:fish")
      return "pescado";
    else if (allergy == "en:peanuts")
      return "cacahuetes";
    else if (allergy == "en:soybeans")
      return "soja";
    else if (allergy == "en:milk")
      return "leche";
    else if (allergy == "en:nuts")
      return "frutos secos";
    else if (allergy == "en:celery")
      return "apio";
    else if (allergy == "en:mustard")
      return "mostaza";
    else if (allergy == "en:sesame-seeds")
      return "semillas de sesamo";
    else if (allergy == "en:sulphur-dioxide-and -sulphites")
      return "sulfitos";
    else if (allergy == "en:lupin")
      return "altramuces";
    else if (allergy == "en:molluscs")
      return "moluscos";
    else
      return "otros"; //No deberia llegar nunca aqui, pero por si a caso
  }
}
