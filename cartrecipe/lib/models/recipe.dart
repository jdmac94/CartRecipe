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
    this.comensales
  });

  List<dynamic> imagenes;
  List<Map<String, List<String>>> ingredientes;
  List<String> pasos;
  List<String> consejos;
  List<dynamic> tags;
  List<dynamic> allergenList;
  String id;
  List<dynamic> categorias;
  List<Usr> usuario;
  String titulo;
  int dificultad;
  String tiempo;
  int ratingNum;
  int comensales;

  factory Recipe.fromJson(Map<String, dynamic> json) {
      print(json);
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
        usuario: List<Usr>.from(json["usr"].map((x) => Usr.fromJson(x))),
        titulo: json["titulo"],
        dificultad: json["dificultad"],
        tiempo: json["tiempo"],
        ratingNum: json["rating_num"],
        comensales: json["comensales"],
      );
    
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

class Usr {
  String nombre;
  String apellido;

  Usr({this.nombre, this.apellido});

  factory Usr.fromJson(Map<String, dynamic> json) => Usr(
    nombre: json['nombre'],
    apellido: json['apellido']
  );
}
