import 'package:cartrecipe/models/product.dart';
import 'package:cartrecipe/providers/product_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/services.dart';

import 'package:cartrecipe/api/api_wrapper.dart';

import 'dart:async';

import 'package:provider/provider.dart';

class ScannerScreen extends StatefulWidget {
  static const String routeNamed = '/scanner';
  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  String _data = "";

  _scan(ProductList provider) async {
    await FlutterBarcodeScanner.scanBarcode(
            "#000000", "Cancelar", true, ScanMode.BARCODE)
        .then((value) => setState(() {
              _data = value;
              provider.addProduct(_data);
            }));
  }

  // Future<String> scanBarcodeNormal() async {
  //   String barcodeScanRes;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
  //         '#ff6666', 'Cancel', true, ScanMode.BARCODE);
  //     print(barcodeScanRes);
  //   } on PlatformException {
  //     barcodeScanRes = 'Failed to get platform version.';
  //   }

  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   //if (!mounted) return;

  //   setState(() {
  //     _data = barcodeScanRes;
  //   });

  //   return _data;
  // }
  //
  void updateProvider() async {
    print('Dato escaneado $_data');
    Product prod = await ApiWrapper().addProduct(_data);
    print('He recibido en el scaner: $prod');
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductList>(context);
    //   return FutureBuilder<String>(
    //       future: _scan(),
    //       builder: (context, AsyncSnapshot<String> snapshot) {
    //         if (snapshot.hasData) {
    //           return Text(snapshot.data);
    //         } else {
    //           return CircularProgressIndicator();
    //         }
    //       });
    // }
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  _scan(provider);

                  //updateProvider();
                },
                child: Text("Escanear código de barras")),
            Text(_data),
          ],
        ),
      ),
    );
  }
}
