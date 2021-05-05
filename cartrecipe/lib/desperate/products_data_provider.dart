import 'package:cartrecipe/api/api_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:cartrecipe/models/product.dart';
import 'package:flutter/foundation.dart';

class ProductsDataProvider with ChangeNotifier {
  List<Product> productList = [];
  bool _isFetching = false;

  ProductsDataProvider({this.productList});

  bool get isFetching => _isFetching;

  List<Product> get getProviderData => productList;

  Future<void> fetchServerData() async {
    _isFetching = true;
    notifyListeners();
    var response = await ApiWrapper().getFridgeProducts();
    productList = response;

    _isFetching = false;
    notifyListeners();
  }

  Future<void> updateProviderData() async {
    fetchServerData();
    notifyListeners();
  }

  Future<ProductsDataProvider> providerWithData() async {
    List<Product> temp = [];
    temp = await ApiWrapper().getFridgeProducts();

    print('Soy el temp del provider en la clase DataProvider: $temp');
    print('Datos de productos cargados');
    //productList = temp;
    return ProductsDataProvider(productList: temp);
  }

  Future<void> addProduct(String barcode) async {
    print('Llego a la petición de añadir desde proveedor');
    Product prod = await ApiWrapper().addProduct(barcode);
    //ApiWrapper().addProduct(barcode).then(
    //  (value) => print('Se ha podido añadir el producto $value a la nevera'));

    //notifyListeners();
    print('He recibido en el scaner pero estoy en la lista: $prod');
    //Product temp = prod;
    print('$productList');
    productList.add(prod);
    notifyListeners();
  }

  Future<void> deleteProduct(List<String> barcodes) async {
    print('Llego a la petición de borrar desde proveedor');

    ApiWrapper()
        .deleteAndreh(barcodes)
        .then((value) => print('Borrados los ${barcodes.length} códigos'));

    print('Borrar en local');

    barcodes.forEach((element) {
      productList.removeWhere((product) => product.id == element);
    });

    print('Borrado en local hecho');
    notifyListeners();
  }
}
