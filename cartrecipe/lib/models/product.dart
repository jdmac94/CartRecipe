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

    if (json['product_name_es'] != null) {
      _name = json['product_name_es'];
    } else {
      _name = json['product_name'];
    }

    if (json['imgs'][0] != null) {
      _image = json['imgs'][0].values.toList();
    }

    if (json['allergens_tags'] != null) {
      _listAllergens = json['allergens_tags'].toList();
    }
    if (json['ingredients_analysis_tags'] != null) {
      _listIngredientsAnalysis = json['ingredients_analysis_tags'].toList();
    }

    if (json['traces_tags'] != null) {
      _listTraces = json['traces_tags'].toList();
    }
    Map<String, dynamic> _listNutriments = json['nutriments'];

    return Product(
      id: json['_id'],
      name: _name,
      image: _image[0],
      allergens: _listAllergens,
      nutriScore: json['nutriscore_grade'],
      ecoScore: json['ecoscore_grade'],
      novaScore: json['nova_groups'],
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
