import 'dart:io';

import 'package:cartrecipe/api/api_wrapper.dart';
import 'package:cartrecipe/screens/recipes/recipe_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_share/social_share.dart';
import 'package:cartrecipe/models/recipe.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RecipeCard extends StatefulWidget {
  final Recipe recipe;
  //TODO: Añadir favorite?
  RecipeCard({
    @required this.recipe,
  });

  @override
  _RecipeCardState createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 3.0,
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          //1. Usuari (Icon + username) , Chip of number of minutes (+ icon)
          //2. Stack of ClipRRect and Positioned with text
          //3. Difficulty + Favourite + Share
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Row(
                          children: [
                            Icon(
                              Icons.account_box_sharp,
                            ),
                            Text(
                              this.widget.recipe.usuario[0].nombre +
                                  " " +
                                  this.widget.recipe.usuario[0].apellido,
                            )
                          ],
                        ),
                        Chip(
                            label: Text(this.widget.recipe.tiempo),
                            avatar: Icon(
                              Icons.timer,
                            )),
                      ],
                    ),
                  ),
                  //2. Favourite + Share icons (non functional)
                  Column(
                    children: <Widget>[
                      InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    RecipeDetail(this.widget.recipe, false))),
                        child: Stack(
                          children: <Widget>[
                            ClipRRect(
                              clipBehavior: Clip.antiAlias,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                              child: Image.network(
                                widget.recipe.imagenes[0],
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              right: 10,
                              child: Container(
                                  width: 300,
                                  color: Colors.black54,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 20),
                                  child: Text(
                                    this.widget.recipe.titulo,
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                    softWrap: true,
                                    overflow: TextOverflow.fade,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      //Difficulty, share and favorite (non functional)

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
                          IconButton(
                              icon: widget.recipe.fav
                                  ? Icon(Icons.favorite, color: Colors.red)
                                  : Icon(Icons.favorite_border,
                                      color: Colors.black),
                              color: Colors.white, // Implementar funcion like
                              onPressed: () {
                                widget.recipe.fav = !widget.recipe.fav;
                                ApiWrapper().addFav(widget.recipe.id);
                                // TODO: ADD IN RECETARIUM BELOW THIS LINE, await API call, MAYBE USE like_button DEPENDENCY
                                setState(() {}); //Could be animated
                              }), //TODO: Funcional sharing recipe
                          IconButton(
                              icon: Icon(Icons.share),
                              onPressed: () async {
                                print(widget.recipe.imagenes[0]);
                                SharedPreferences user =
                                    await SharedPreferences.getInstance();
                                SocialShare.shareOptions("Hola, el usuario " +
                                    user.getString('nombre') +
                                    " ya hace uso de la aplicación de CartRecipe, si la descargas podrás ver esta deliciosa receta de " +
                                    widget.recipe.titulo +
                                    " para mas información pidele la aplicación a Andrés porque no esta en la Play Store");
                              }),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
