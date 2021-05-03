import 'package:cartrecipe/api/api_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:cartrecipe/models/product.dart';
import 'package:flutter/foundation.dart';

class ListProvider with ChangeNotifier {
  List<Product> _list = [];

  void fetchServerData() async {
    _list = await ApiWrapper().getFridgeProducts();
  }

  Future<List<Product>> getRefreshData() async {
    return ApiWrapper().getFridgeProducts();
  }

  void addItem(Product item) {
    _list.add(item);
    notifyListeners();
  }

  void deleteItem(int index) {
    _list.removeAt(index);
    notifyListeners();
  }
}
