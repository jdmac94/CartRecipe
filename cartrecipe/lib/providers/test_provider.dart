import 'package:flutter/cupertino.dart';

import 'package:cartrecipe/models/product.dart';
import 'package:cartrecipe/api/api_wrapper.dart';
import 'package:flutter/foundation.dart';

class TestProvider extends ChangeNotifier {
  List<Product> _largo = [];

  Future<void> getData() async {
    ApiWrapper().getFridgeProducts().then((products) {
      _largo = products;
      print({_largo});
      print(_largo[0].name);
    });

    notifyListeners();
  }

  List<Product> get items {
    notifyListeners();
    return [..._largo];
  }
}
