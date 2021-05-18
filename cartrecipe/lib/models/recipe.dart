import 'package:flutter/material.dart';
import 'dart:core';
import 'dart:convert';

class Recipe {
  Recipe({
    this.imagenes,
    this.ingredientes,
    this.pasos,
    this.consejos,
    this.tags,
    this.allergenList,
    this.id,
    this.categorias,
    this.usuario,
    this.titulo,
    this.dificultad,
    this.tiempo,
    this.ratingNum,
  });

  List<dynamic> imagenes;
  List<Map<String, List<String>>> ingredientes;
  List<String> pasos;
  List<String> consejos;
  List<dynamic> tags;
  List<dynamic> allergenList;
  String id;
  List<dynamic> categorias;
  String usuario;
  String titulo;
  int dificultad;
  String tiempo;
  int ratingNum;

  factory Recipe.fromJson(Map<String, dynamic> json) {
    if (json["_id"] != "608d98bcaf1d7558ccc3e392") {
      print(json);
      ;
      return Recipe(
        imagenes: List<dynamic>.from(json["imagenes"].map((x) => x)),
        ingredientes: List<Map<String, List<String>>>.from(json["ingredientes"]
            .map((x) => Map.from(x).map((k, v) =>
                MapEntry<String, List<String>>(
                    k, List<String>.from(v.map((x) => x)))))),
        pasos: List<String>.from(json["pasos"].map((x) => x)),
        consejos: List<String>.from(json["consejos"].map((x) => x)),
        tags: List<dynamic>.from(json["tags"].map((x) => x)),
        allergenList: List<dynamic>.from(json["allergenList"].map((x) => x)),
        id: json["_id"],
        categorias: json["categorias"] != null //TODO: Handle
            ? List<dynamic>.from(json["categorias"].map((x) => x))
            : [],
        usuario: json["usuario"],
        titulo: json["titulo"],
        dificultad: json["dificultad"],
        tiempo: json["tiempo"],
        ratingNum: json["rating_num"],
      );
    }
  }

  Map<String, dynamic> toJson() => {
        "imagenes": List<dynamic>.from(imagenes.map((x) => x)),
        "ingredientes": List<dynamic>.from(ingredientes.map((x) => Map.from(x)
            .map((k, v) => MapEntry<String, dynamic>(
                k, List<dynamic>.from(v.map((x) => x)))))),
        "pasos": List<dynamic>.from(pasos.map((x) => x)),
        "consejos": List<dynamic>.from(consejos.map((x) => x)),
        "tags": List<dynamic>.from(tags.map((x) => x)),
        "allergenList": List<dynamic>.from(allergenList.map((x) => x)),
        "_id": id,
        "categorias": List<dynamic>.from(categorias.map((x) => x)),
        "usuario": usuario,
        "titulo": titulo,
        "dificultad": dificultad,
        "tiempo": tiempo,
        "rating_num": ratingNum,
      };
}

/*class Recipe {
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
      ingredients: List<dynamic>.from(ingredientes.map((x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x))))));
    ,
      time: jsonIn['tiempo'],
      image: jsonIn['imagenes'].isEmpty
          ? 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/600px-No_image_available.svg.png'
          : jsonIn['imagenes'][0],
      steps: stepsList,
      tips: tipList,
    );
  }
}

class Ingredientes {
  List<String> ingredientName;
  List<double> cantidad;

  Ingredientes({this.ingredientName, this.cantidad});

  Ingredientes.fromJson(Map<String, dynamic> json) {
    json.
  }
}

class IngredienteReceta {
  List<List<String>> ingredientInfo;
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
*/
