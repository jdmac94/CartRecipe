import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;

  const Product({
    @required this.id,
    @required this.name,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(id: json['_id'], name: json['product_name']);
  }
}
