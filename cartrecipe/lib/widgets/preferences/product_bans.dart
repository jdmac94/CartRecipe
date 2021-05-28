import 'package:flutter/material.dart';
import 'package:cartrecipe/api/api_wrapper.dart';

class ProductBans extends StatefulWidget {
  const ProductBans({Key key}) : super(key: key);
  @override
  State<ProductBans> createState() => _ProductBans();
  List<String> get getProducts => _ProductBans().getProducts;
}

class _ProductBans extends State<ProductBans> {
  Widget build(BuildContext context) {
    products.then((value) {
      productNames = value;
    });
    print(productNames.length);

    productNames.forEach((element) {
      productban.add(false);
    });
    //return gridView();
    return Container();
  }

  List<String> get getProducts {
    return productsToSend;
  }

  List<String> productsToSend = [];
  List<bool> productban = [];
  List<String> productNames = [];
  Future<List<String>> products = ApiWrapper().getGenericIngredients();

  Widget checkBox(int index) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 2),
      title: Text(productNames[index]),
      value: productban[index],
      onChanged: (newValue) {
        setState(() {
          print(newValue);
          productban[index] = newValue;
          productban[index]
              ? productsToSend.add(productNames[index])
              : productsToSend.remove(productNames[index]);
        });
      },
      controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
    );
  }

  Future<Widget> gridView() async {
    return GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
        crossAxisCount: 2,
        childAspectRatio: 4,
        children: [for (int i = 0; i < productNames.length; i++) checkBox(i)]);
  }
}
