import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class Product {
  final String id;
  final String name;
  final String image;

  const Product({
    @required this.id,
    @required this.name,
    @required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    //Transforma el Map de imágenes en una lista
    //var _list = json['imgs'][0].values.toList();

    return Product(
        id: json['_id'], name: json['product_name'], image: null); //_list[0]);
  }

  @override
  String toString() {
    return "Id = ${id.toString()}, name = ${name.toString()} ,image = ${image.toString()}";
  }
}
