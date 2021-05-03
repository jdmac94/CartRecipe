import 'dart:async';

import 'package:cartrecipe/api/api_wrapper.dart';
import 'package:cartrecipe/models/product.dart';
import 'package:cartrecipe/providers/product_list_provider.dart';

import 'package:cartrecipe/widgets/fridge_speedial.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TestStreamScreen extends StatefulWidget {
  //List<Product> listadoProductos = [];

  @override
  _TestStreamScreenState createState() => _TestStreamScreenState();
}

class _TestStreamScreenState extends State<TestStreamScreen> {
  var controller = new StreamController();

  Future<List<Product>> _fetchData() {
    return ApiWrapper().getFridgeProducts();
  }

  @override
  Widget build(BuildContext context) {
    print('Voy para el Stream');
    return Scaffold(
      body: Container(
        child: StreamBuilder<List<Product>>(
          initialData: [],
          stream: Stream.fromFuture(ApiWrapper().getFridgeProducts()),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            print('Esto tiene $snapshot');
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                if (!snapshot.hasData) {
                  return Container(
                    child: Text('No data found'),
                  );
                } else {
                  if (snapshot.data.length == 0) {
                    return Container(
                      child: Column(
                        children: [
                          Icon(Icons.error),
                          Text('No tienes datos cargados'),
                        ],
                      ),
                    );
                  } else {
                    return Card(
                      child: ListTile(
                        title: Text(snapshot.data[index].name),
                      ),
                    );
                  }
                }
              },
            );
          },
        ),
      ),
      floatingActionButton: FridgeSpeedDial(),
    );
  }
}
