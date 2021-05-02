import 'package:cartrecipe/api/api_wrapper.dart';
import 'package:flutter/foundation.dart';

import 'package:cartrecipe/models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _listaProductos;

  Future<void> loadProviderData() async {
    _listaProductos = await ApiWrapper().getFridgeProducts();
  }

  Future<List<Product>> syncWithApi() async {
    return ApiWrapper().getFridgeProducts();
  }

  List<Product> get gimmeData {
    return _listaProductos;
  }

  set copyToProvider(List<Product> fridge) {
    _listaProductos = fridge;
  }
}
