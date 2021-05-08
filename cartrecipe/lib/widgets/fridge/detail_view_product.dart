import 'package:flutter/material.dart';

import 'package:cartrecipe/models/product.dart';

class DetailViewProduct extends StatelessWidget {
  final Product product;

  DetailViewProduct(this.product);

//TODO! CONTROLAR TODOS LOS INGREDIENTES
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            (product.image == null)
                ? FlutterLogo(size: 70)
                : Image.network(
                    product.image,
                    width: 150,
                    height: 150,
                  ),
            ListTile(
              title: Text(product.name),
              subtitle: Text(
                'Código de barras: ${product.id}',
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Lorem ipsum',
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
              ),
            ),
            (product.nutriScore != null)
                ? Container(
                    child: Image.asset(
                      'assets/images/products/nutriscore/${product.nutriScore}.png',
                      width: 80,
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                  )
                : Text('No tiene nutriscore'),
            ButtonBar(
              alignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () {
                    // Perform some action
                  },
                  child: const Text('ACTION 1'),
                ),
                TextButton(
                  onPressed: () {
                    // Perform some action
                  },
                  child: const Text('ACTION 2'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
