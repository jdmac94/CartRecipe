import 'package:cartrecipe/api/api_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:cartrecipe/models/product.dart';
import 'package:flutter/foundation.dart';

class ProductsDataProvider with ChangeNotifier {
  List<Product> _productList = [];
  bool _isFetching = false;

  bool get isFetching => _isFetching;

  Future<void> fetchServerData() async {
    _isFetching = true;
    notifyListeners();
    var response = await ApiWrapper().getFridgeProducts();
    _productList = response;

    _isFetching = false;
    notifyListeners();
  }

  Future<List<Product>> getData() async {
    List<Product> temp = [];

    temp = await ApiWrapper().getFridgeProducts();

    return [...temp];
  }

  List<Product> get getResponseList => _productList;

  Future<ProductsDataProvider> providerWithData() async {
    List<Product> temp = [];
    temp = await ApiWrapper().getFridgeProducts();

    print('Soy el temp del provider en la clase DataProvider: $temp');
    print('Datos de productos cargados');
    //productList = temp;
    return ProductsDataProvider();
  }

  Future<List<Product>> getRefreshData() async {
    return ApiWrapper().getFridgeProducts();
  }

  List<Product> get obtenerLista {
    return [..._productList];
  }

  void addItem(Product item) {
    _productList.add(item);
    notifyListeners();
  }

  void deleteItem(int index) {
    _productList.removeAt(index);
    notifyListeners();
  }
}
