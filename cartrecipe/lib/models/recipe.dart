import 'package:flutter/material.dart';
import 'dart:core';
import 'dart:convert';

class Recipe {
  String id;
  String user;
  String recipeName;
  int difficulty;
  List<IngredienteReceta> ingredients;
  String time;
  String image;
  List<String> steps;
  List<String> tips;

  Recipe({
    @required this.id,
    @required this.user,
    @required this.recipeName,
    @required this.difficulty,
    @required this.ingredients,
    @required this.time,
    @required this.image,
    @required this.steps,
    @required this.tips,
  });

  //TODO: Desde backend, arreglar los datos enviados de los INGREDIENTES. Actualmente se muestra como
  //[     {"NombreIngrediente" : "cantidad", "NombreIngrediente2" : "cantidad2"}      ]
  //Cuando deberia ser:
  // [
  //      {"nombre" : "NombreIngrediente",
  //      "cantidad" : "numero"}, {...}, {...}         ]
  factory Recipe.fromJson(Map<String, dynamic> jsonIn) {
    List<String> stepsList = List<String>.from(jsonIn['pasos'].map((x) => x));
    List<String> tipList = List<String>.from(jsonIn["consejos"].map((x) => x));

    //stepsList = List<String>.from(stepsList);
    //tipList = List<String>.from(tipList);

    print("Printing recipe list received: \n\n");
    print(jsonIn);
    print("\n\n\n");

    //TODO: Añadir ingredientes, actualmente usando un dummy
    List<IngredienteReceta> ings = [
      IngredienteReceta(nombre: 'patatas', cantidad: 1.5)
    ];
    return Recipe(
      id: jsonIn['_id'],
      user: jsonIn['usuario'],
      recipeName: jsonIn['titulo'],
      difficulty: jsonIn['dificultad'],
      ingredients: ings,
      time: jsonIn['tiempo'],
      image: jsonIn['imagenes'].isEmpty
          ? 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/600px-No_image_available.svg.png'
          : jsonIn['imagenes'][0],
      steps: stepsList,
      tips: tipList,
    );
  }
}

class IngredienteReceta {
  String nombre;
  double cantidad;

  IngredienteReceta({
    this.nombre,
    this.cantidad,
  });

  // TODO: Cambiar key en json["key"] segun se pasen los parametros (despues de arreglar)
  factory IngredienteReceta.fromJson(Map<String, dynamic> json) =>
      IngredienteReceta(
        nombre: json["name"],
        cantidad: double.parse(json["cantidad"]),
      );
}
