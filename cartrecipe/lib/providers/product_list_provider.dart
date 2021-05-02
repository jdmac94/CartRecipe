import 'package:cartrecipe/api/api_wrapper.dart';
import 'package:flutter/foundation.dart';

import 'package:cartrecipe/models/product.dart';

class ProductList with ChangeNotifier {
  ProductList({this.listaProductos});

  List<Product> listaProductos;

  Future<void> doSomething() async {
    await Future.delayed(Duration(seconds: 2));
    Product prod1 = new Product(
        id: '1',
        name: 'Prod1',
        image:
            'https://upload.wikimedia.org/wikipedia/commons/c/c7/Tabby_cat_with_blue_eyes-3336579.jpg');
    Product prod2 = new Product(
        id: '2',
        name: 'Prod2',
        image:
            'https://upload.wikimedia.org/wikipedia/commons/c/c7/Tabby_cat_with_blue_eyes-3336579.jpg');
    listaProductos = [
      prod1,
      prod2,
    ];
    print('Uso de gatetes');
  }

  Future<ProductList> someAsyncFunctionToGetMyModel() async {
    await Future.delayed(Duration(seconds: 3));
    List<Product> temp = [];

    Product prod3 = new Product(
        id: '3',
        name: 'Prod3',
        image:
            'https://upload.wikimedia.org/wikipedia/commons/c/c7/Tabby_cat_with_blue_eyes-3336579.jpg');

    temp.add(prod3);

    return ProductList(listaProductos: temp);
  }

  Future<void> update() async {
    listaProductos = await ApiWrapper().getFridgeProducts();
    notifyListeners();
  }

  Future<ProductList> loadProductsData() async {
    //await Future.delayed(Duration(seconds: 3));
    List<Product> temp = [];

    notifyListeners();
    temp = await ApiWrapper().getFridgeProducts();

    print('Soy el temp: $temp');

    print('Datos de productos cargados');

    return ProductList(listaProductos: temp);
  }

  Future<List<Product>> getData() async {
    List<Product> temp = [];

    temp = await ApiWrapper().getFridgeProducts();
    return [...temp];
  }

  void deleteProduct(String barcode, int index) {
    listaProductos.removeAt(index);
    ApiWrapper().deleteAndreh([barcode]);
    notifyListeners();
  }

  void deleteMultipleProduct(List<int> indexes) {
    indexes.forEach((index) {
      listaProductos.removeAt(index);
    });

    notifyListeners();
  }

  Future<void> addProduct(String barcode) async {
    Product prod = await ApiWrapper().addProduct(barcode);
    print('He recibido en el scaner pero estoy en la lista: $prod');
    Product temp = prod;
    listaProductos.add(temp);
    notifyListeners();
  }

  List<Product> updatedListProduct() {
    print('Lista de cosas ya guardads: $listaProductos');
    return [...listaProductos];
  }

  // ------------------- ESTO FUNCA?--------------------
  // Future<List<Product>> loadProductsData() async {
  //   List<Product> temp;

  //   ApiWrapper().getFridgeProducts().then((products) {
  //     temp = products;
  //     //notifyListeners();
  //   });

  //   print('Datos de productos cargados');

  //   return temp;
  // }

  // List<Product> get dameargo {
  //   // if (_showFavoritesOnly) {
  //   //   return _items.where((prodItem) => prodItem.isFavourite).toList();
  //   // }
  //   return [...listaProductos];
  // }

  // List<Product> gimme() {
  //   List<Product> temp;

  //   ApiWrapper().getFridgeProducts().then((products) {
  //     temp = products;
  //     notifyListeners();
  //   });

  //   return temp;
  // }

  // List<Product> _lista = gimme();

  // List<Product> get listaProductos {
  //   List<Product> temp;

  //   return [..._lista];
  // }

  // void addProduct() {}
  // void deleteProduct() {}
}
