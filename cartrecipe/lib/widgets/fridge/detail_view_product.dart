import 'package:cartrecipe/api/api_wrapper.dart';
import 'package:flutter/material.dart';

import 'package:cartrecipe/models/product.dart';

class DetailViewProduct extends StatelessWidget {
  final Product product;
  final bool typeDetail;
  DetailViewProduct(this.product, this.typeDetail);
  final double _scoresImagesSize = 70;
  final double _allergensImagesSize = 50;

  //final ScrollController _scrollController = ScrollController();

//TODO! CONTROLAR TODOS LOS INGREDIENTES
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Scrollbar(
        isAlwaysShown: true,
        //controller: _scrollController,
        child: SingleChildScrollView(
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                (product.image == null)
                    ? FlutterLogo(size: 70)
                    : Image.network(
                        product.image,
                        width: 150,
                        height: 150,
                        fit: BoxFit.contain,
                      ),
                ListTile(
                  title: Text(product.name),
                  subtitle: Text(
                    'Código de barras: ${product.id}',
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                  ),
                ),
                showIngredients(product),
                showScores(product),
                showAllergens(product),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: typeDetail,
                      child: TextButton(
                        onPressed: () {
                          ApiWrapper().addProduct(product.id);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'Se ha añadido el producto con el código ${product.id}')));
                          Navigator.pop(context);
                        },
                        child: const Text('Añadir a nevera'),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cerrar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container showIngredients(product) {
    return Container(
      child: Column(
        children: [
          Text(
            'Ingredientes',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: product.ingredients != null
                ? Text(
                    product.ingredients,
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                    textAlign: TextAlign.justify,
                  )
                : Text('No tenemos ingredientes de este producto'),
          ),
        ],
      ),
    );
  }

  Container showScores(product) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Calidad nutricional y ecológica',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Image.asset(
                  'assets/images/products/nutriscore/${product.nutriScore}.png',
                  width: _scoresImagesSize,
                  height: _scoresImagesSize,
                  fit: BoxFit.contain,
                ),
              ),
              Container(
                child: Image.asset(
                  'assets/images/products/novascore/${product.novaScore}.png',
                  width: _scoresImagesSize,
                  height: _scoresImagesSize,
                  fit: BoxFit.contain,
                ),
              ),
              Container(
                child: Image.asset(
                  'assets/images/products/ecoscore/${product.ecoScore}.png',
                  width: _scoresImagesSize,
                  height: _scoresImagesSize,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container showAllergens(Product product) {
    if (product.allergens.isEmpty) {
      return Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Alérgenos',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Text('No tiene alérgenos'),
          ],
        ),
      );
    } else {
      return Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Alérgenos',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: product.allergens
                  .map((allergen) => Image.asset(
                        'assets/images/products/allergens/$allergen.png',
                        width: _allergensImagesSize,
                        height: _allergensImagesSize,
                        fit: BoxFit.contain,
                      ))
                  .toList(),
            ),
          ],
        ),
      );
    }
  }
}
