import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class Product {
  final String id;
  final String name;
  final String image;
  final List<dynamic> allergens;
  final String nutriScore;
  final String ecoScore;
  final String novaScore;
  final String quantity;
  final String ingredients;
  final List<dynamic> ingredientsAnalysis;
  final List<dynamic> traces;
  final Map<String, dynamic> nutriments;

  const Product({
    @required this.id,
    @required this.name,
    @required this.image,
    @required this.allergens,
    @required this.nutriScore,
    @required this.ecoScore,
    @required this.novaScore,
    @required this.quantity,
    @required this.ingredients,
    @required this.ingredientsAnalysis,
    @required this.traces,
    @required this.nutriments,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    //Transforma el Map de imágenes en una lista
    var _image;
    var _listAllergens = [];
    var _listTraces = [];
    var _listIngredientsAnalysis = [];

    String _name;
    String _ecosScore;
    String _nutriScore;
    String _novaScore;

    if (json['product_name_es'] != null) {
      _name = json['product_name_es'];
    } else {
      _name = json['product_name'];
    }

    if (json['imgs'] != null) {
      if (json['imgs'][0] == null) {
        _image = 'null';
      } else {
        _image = json['imgs'][0].values.toList();
      }
    }

    if (json['allergens_tags'] == null) {
      _listAllergens = null;
    } else {
      List<dynamic> tempAllergens = json['allergens_tags'].toList();

      for (var i = 0; i < tempAllergens.length; i++) {
        _listAllergens.add(tempAllergens[i].replaceAll('en:', ''));
      }
    }

    if (json['ingredients_analysis_tags'] == null) {
      _listIngredientsAnalysis = null;
    } else {
      _listIngredientsAnalysis = json['ingredients_analysis_tags'].toList();
    }

    if (json['traces_tags'] == null) {
      _listTraces = null;
    } else {
      _listTraces = json['traces_tags'].toList();
    }

    if (json['ecoscore_grade'] == 'unknown' || json['ecoscore_grade'] == null) {
      _ecosScore = 'null';
    } else {
      _ecosScore = json['ecoscore_grade'];
    }

    if (json['nutriscore_grade'] == null) {
      _nutriScore = 'null';
    } else {
      _nutriScore = json['nutriscore_grade'];
    }

    if (json['nova_groups'] == null) {
      _novaScore = 'null';
    } else {
      _novaScore = json['nova_groups'];
    }

    Map<String, dynamic> _listNutriments = json['nutriments'];

    return Product(
      id: json['id'],
      name: _name,
      image: _image == null ? _image : _image[0],
      //image: _image[0],
      allergens: _listAllergens,
      nutriScore: _nutriScore,
      ecoScore: _ecosScore,
      novaScore: _novaScore,
      quantity: json['quantity'],
      ingredients: json['ingredients_text_es'], //ingredients_text_es
      ingredientsAnalysis: _listIngredientsAnalysis,
      traces: _listTraces,
      nutriments: _listNutriments,
    );
  }

  @override
  String toString() {
    return "Id = ${id.toString()}, name = ${name.toString()}, image = ${image.toString()}, allergens = ${allergens.toString()}," +
        " nutriscore = ${nutriScore.toString()}, ecosscore = ${ecoScore.toString()}, novascore = ${novaScore.toString()}," +
        " quantity = ${quantity.toString()}, ingredients = ${ingredients.toString()}, ingredientsAnalysis = ${ingredientsAnalysis.toString()}" +
        " traces = ${traces.toString()}, ingredientes = ${nutriments.toString()}";
  }
}
