import 'dart:async';

import 'package:flutter/material.dart';

import 'package:cartrecipe/api/api_wrapper.dart';
import 'dart:io';
import 'package:cartrecipe/data/dummy_data.dart';
import 'package:cartrecipe/models/product.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class NeveraTest extends StatefulWidget {
  NeveraTest({Key key}) : super(key: key);

  @override
  _NeveraTestState createState() => _NeveraTestState();
}

class _NeveraTestState extends State<NeveraTest> {
  List data;
  bool connection = false;
  bool isInit = true;

  final prodStream = StreamController<List<Product>>();

  final String endpoint = "158.109.74.46:55005";

  Future<List<Product>> getFridgeProducts() async {
    const String api = "api/v1/nevera/getNeveraList";
    final response = await http.get(Uri.http(endpoint, api));
    if (response.statusCode == 200) {
      print('Recibida la respuesta de la petición');

      List<Product> prods = [];

      Iterable l = json.decode(response.body);
      prods = List<Product>.from(l.map((model) => Product.fromJson(model)));

      return prods;
    } else {
      print('Petición de respuesta');
      return DUMMY_PRODUCTS;
      //throw Exception('Failed to load product');
    }
  }

  @override
  void initState() {
    getFridgeProducts().then((products) {
      if (mounted)
        setState(() {
          data = products;
        });
    });

    super.initState();
  }

  void deleteProduct(Product product, int index) {
    if (mounted)
      setState(() {
        data.removeAt(index);
        ApiWrapper().deleteAndreh([product.id]);
        //I assume you want to remove favorites as well otherwise the two indeces will go out of sync? Maybe?
        //favourites.removeAt(index)
      });
  }

  @override
  void dispose() {
    prodStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: prodStream.stream,
            initialData: [],
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.separated(
                  separatorBuilder: (context, index) =>
                      Divider(color: Colors.black),
                  itemCount: snapshot.data.lenght,
                  itemBuilder: (BuildContext context, int index) {
                    Text(snapshot.data[index].name);
                  },
                );
              } else {
                return CircularProgressIndicator();
              }
            }));
  }
}
