import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

import 'dart:async';

class ScannerScreen extends StatefulWidget {
  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  String _data = "";
  String _productname = "";

  _scan() async {
    await FlutterBarcodeScanner.scanBarcode(
            "#000000", "Cancelar", true, ScanMode.BARCODE)
        .then((value) => setState(() => _data = value));
  }

  Future<String> getProduct() async {
    var barcode = "0048151623426";

    ProductQueryConfiguration configuration = ProductQueryConfiguration(barcode,
        language: OpenFoodFactsLanguage.GERMAN, fields: [ProductField.ALL]);
    ProductResult result = await OpenFoodAPIClient.getProduct(configuration);

    if (result.status == 1) {
      return "manolo"; //"result.product.productName;"
    } else {
      throw Exception("product not found, please insert data for " + barcode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () => _scan(),
                child: Text("Escanear código de barras")),
            Text(_data),
            ElevatedButton(
                onPressed: () => getProduct(), child: Text("Prueba producto")),
            Text(_productname),
          ],
        ),
      ),
    );
  }
}
