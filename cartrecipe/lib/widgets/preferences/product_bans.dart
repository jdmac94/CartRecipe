import 'package:flutter/material.dart';
import 'package:cartrecipe/api/api_wrapper.dart';

class ProductBans extends StatefulWidget {
  const ProductBans({Key key}) : super(key: key);
  @override
  State<ProductBans> createState() => _ProductBans();
  List<String> get getProducts => _ProductBans().getProducts;
}

class _ProductBans extends State<ProductBans> {
  final Future<String> _calculation = Future<String>.delayed(
    const Duration(seconds: 2),
    () => 'Data Loaded',
  );
  Widget build(BuildContext context) {
    products.then((value) {
      productNames = value;
      productNames.forEach((element) {
        productban.add(false);
      });
    });
    print(productNames.length);

    return Container(
        child: FutureBuilder<String>(
            future: _calculation,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              Widget children;
              if (snapshot.hasData) {
                children = gridView();
              } else if (snapshot.hasError) {
                children = const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                );
              } else {
                children = Column(children: [
                  SizedBox(
                    child: CircularProgressIndicator(),
                    width: 60,
                    height: 60,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Awaiting result...'),
                  )
                ]);
              }
              return children;
            }));
    //return Container();
  }

  List<String> get getProducts {
    return productsToSend;
  }

  List<String> productsToSend = [];
  List<bool> productban = [];
  List<String> productNames = [];
  Future<List<String>> products = ApiWrapper().getGenericIngredients();

  Widget checkBox(int index) {
    print(productNames.length);
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

  Widget gridView() {
    print(productNames.length);
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
