import 'package:flutter/foundation.dart';

import 'package:cartrecipe/models/product.dart';
import 'package:cartrecipe/api/api_wrapper.dart';

class DataProvider extends ChangeNotifier {
  //List<Product> _productList = [];

  Stream<List<Product>> fetchData() {
    // ApiWrapper().getFridgeProducts().then((products) {
    //   _productList = products;
    //   print('Estoy en el DataProvider y obtengo $_productList');
    //   print('DataProvider y obtengo el primer Product ${_productList[0].name}');
    // });
    //var temp = ApiWrapper().getFridgeProducts();

    return Stream.fromFuture(ApiWrapper().getFridgeProducts());
  }

  // Stream <List<Product>> get fetchData(){

  //   var _data = ApiWrapper().getFridgeProducts();

  //   return _data;
  // }
}
