import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:cartrecipe/models/product.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class MyFridgeScreen extends StatefulWidget {
  @override
  _MyFridgeScreenState createState() => _MyFridgeScreenState();
}

class _MyFridgeScreenState extends State<MyFridgeScreen> {
  static const String endpoint = "762b0d7b9720.ngrok.io";
  static const String api = "api/v1/nevera/getNeveraList";

  Future<List<Product>> _getProducts() async {
    final response = await http.get(Uri.https(endpoint, api));
    if (response.statusCode == 200) {
      print('Recibida la respuesta de la petición');

      List<Product> prods = [];

      Iterable l = json.decode(response.body);
      prods = List<Product>.from(l.map((model) => Product.fromJson(model)));
      return prods;
    } else {
      throw Exception('Failed to load product');
    }
  }

  SpeedDial buildSpeedDial() {
    return SpeedDial(
      /// both default to 16
      marginEnd: 18,
      marginBottom: 20,
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),

      /// This is ignored if animatedIcon is non null
      icon: Icons.add,
      activeIcon: Icons.remove,
      // iconTheme: IconThemeData(color: Colors.grey[50], size: 30),

      /// The label of the main button.
      // label: Text("Open Speed Dial"),
      /// The active label of the main button, Defaults to label if not specified.
      // activeLabel: Text("Close Speed Dial"),
      /// Transition Builder between label and activeLabel, defaults to FadeTransition.
      // labelTransitionBuilder: (widget, animation) => ScaleTransition(scale: animation,child: widget),
      /// The below button size defaults to 56 itself, its the FAB size + It also affects relative padding and other elements
      buttonSize: 56.0,
      visible: true,

      /// If true user is forced to close dial manually
      /// by tapping main button and overlay is not rendered.
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.white,
      overlayOpacity: 0.5,
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      tooltip: 'Speed Dial',
      heroTag: 'speed-dial-hero-tag',
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
      elevation: 8.0,
      shape: CircleBorder(),

      // orientation: SpeedDialOrientation.Up,
      // childMarginBottom: 2,
      // childMarginTop: 2,
      gradientBoxShape: BoxShape.circle,
      activeBackgroundColor: Colors.deepPurple,
      // gradient: LinearGradient(
      //   begin: Alignment.topCenter,
      //   end: Alignment.bottomCenter,
      //   colors: [Colors.black, Colors.white],
      // ),
      children: [
        SpeedDialChild(
          child: Icon(Icons.edit),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          label: 'Añadir manualmente',
          labelStyle: TextStyle(fontSize: 18),
          onTap: () => print('FIRST CHILD'),
          onLongPress: () => print('FIRST CHILD LONG PRESS'),
        ),
        SpeedDialChild(
          child: Icon(Icons.qr_code),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          label: 'Añadir mediante escaner',
          labelStyle: TextStyle(fontSize: 18),
          onTap: () => print('SECOND CHILD'),
          onLongPress: () => print('SECOND CHILD LONG PRESS'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    String displayText = "Same Text Everywhere";

    return Scaffold(
        body: Container(
          child: FutureBuilder(
            future: _getProducts(),
            builder: (BuildContext context, snapshot) {
              if (!snapshot.hasData) {
                print('No data in snapshot');
              } else {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: ListTile(
                          leading: FlutterLogo(size: 72.0),
                          title: Text(snapshot.data[index].name),
                          onTap: () => showMyDialog(context, displayText),
                        ),
                      );
                    });
              }
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                ),
              );
            },
          ),
        ),
        floatingActionButton: buildSpeedDial());
  }

  Future<void> showMyDialog(BuildContext context, String displayText) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: detailedViewProduct(),
        );
      },
    );
  }

  Widget detailedViewProduct() {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Image.network(
              "https://static.openfoodfacts.org/images/products/073/762/806/4502/front_en.6.200.jpg"),
          ListTile(
            title: const Text('Card title 1'),
            subtitle: Text(
              'Secondary Text',
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Greyhound divisively hello coldly wonderfully marginally far upon excluding.',
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () {
                  // Perform some action
                },
                child: const Text('ACTION 1'),
              ),
              TextButton(
                onPressed: () {
                  // Perform some action
                },
                child: const Text('ACTION 2'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
