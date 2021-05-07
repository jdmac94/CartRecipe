import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TutorialListPages {
  String imagePath;
  String title;
  String subtitle;

  TutorialListPages(
    this.imagePath,
    this.title,
    this.subtitle,
  );
}

var listPages = [
  new TutorialListPages(
      'assets/images/tutorial/barcode.png',
      'Escanea tus productos',
      'Mediante la aplicación podrás escanear todos los productos fácilmente'),
  new TutorialListPages(
      'assets/images/tutorial/refrigerator.png',
      'Gestiona tu nevera',
      'Ten control en todo momento sobre los productos que tienes en la nevera'),
  new TutorialListPages(
      'assets/images/tutorial/cookbook.png',
      'Aprende recetas',
      'La aplicación generará recetas basadas en tus gustos'),
  new TutorialListPages(
    'assets/images/tutorial/cutlery.png',
    '¡A comer!',
    'Ya puedes abrir tu propio restaurante',
  ),
];
