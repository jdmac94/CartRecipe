import 'package:cartrecipe/desperate/products_data_provider.dart';
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

//TODO! CONTROLAR BUG DE CANCELAR ESCANEO
  _scan(ProductsDataProvider provider) async {
    await FlutterBarcodeScanner.scanBarcode(
            "#000000", "Cancelar", true, ScanMode.BARCODE)
        .then((value) {
      setState(() {
        Map<String, bool> map = _checkIsValidBarcode(value);

        var _listMessage = map.keys.toList();
        var _listValid = map.values.toList();

        if (_listValid[0]) {
          provider.addProduct(value);
        }
        _data = _listMessage[0];
      });
    });
  }

  Map<String, bool> _checkIsValidBarcode(String barcode) {
    bool isValid = true;
    String message;
    Map<String, bool> result;

    final String regexPattern = r'(^[0-9]*$)';
    final regexExpression = RegExp(regexPattern);

    if (regexExpression.hasMatch(barcode)) {
      if (barcode.length < 13) {
        isValid = false;
        message = 'El código de barras tiene menos dígitos de lo esperado (13)';
        result = {message: isValid};
      } else if (barcode.length > 13) {
        isValid = false;
        message = 'El código de barras tiene más dígitos de lo esperado (13)';
        result = {message: isValid};
      } else {
        isValid = true;
        message = 'Se ha escaneado el siguiente código: $barcode';
        result = {message: isValid};
      }
    } else if (barcode == '-1') {
      isValid = false;
      message = 'Se ha cancelado el escaneo';
      result = {message: isValid};
    } else {
      isValid = false;
      message = 'El valor dado no es numérico';
      result = {message: isValid};
    }

    return result;
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
    final provider = Provider.of<ProductsDataProvider>(context);
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
