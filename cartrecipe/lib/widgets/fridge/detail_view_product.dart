import 'package:flutter/material.dart';

import 'package:cartrecipe/models/product.dart';

class DetailViewProduct extends StatelessWidget {
  final Product product;

  DetailViewProduct(this.product);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Image.network(
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
                'Greyhound divisively hello coldly wonderfully marginally far upon excluding.',
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
              ),
            ),
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
