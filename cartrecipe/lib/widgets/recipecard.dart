import 'package:cartrecipe/screens/recipe_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:cartrecipe/models/recipe.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  //TODO: Añadir favorite?
  RecipeCard({
    @required this.recipe,
  });

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
                            Text(this.recipe.user),
                          ],
                        ),
                        Chip(
                            label: Text(this.recipe.time),
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
                        // TODO: Mostrar la barra de navegación al hacer push
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    RecipeDetail(this.recipe))),
                        child: Stack(
                          children: <Widget>[
                            ClipRRect(
                              clipBehavior: Clip.antiAlias,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                              child: Image.network(
                                recipe.image,
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
                                    this.recipe.recipeName,
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
                        rating: this.recipe.difficulty.toDouble(),
                        itemCount: 5,
                        itemSize: 20,
                        itemBuilder: (context, index) {
                          if (this.recipe.difficulty <= 2) {
                            return Icon(
                              Icons.local_fire_department,
                              color: Colors.green[600],
                            );
                          } else if (this.recipe.difficulty <= 4) {
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
                        children: <Widget>[
                          //TODO: Functional favorite recipe
                          Icon(
                            Icons.favorite_outline,
                          ),
                          //TODO: Funcional sharing recipe
                          Icon(
                            Icons.share,
                          ),
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
