import 'dart:async';

import 'package:cartrecipe/screens/tabs_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:cartrecipe/widgets/fridge/add_product_form.dart';
import 'package:cartrecipe/widgets/fridge/delete_all_alert.dart';

class FridgeSpeedDial extends StatelessWidget {
  final Map selectedProducts;

  FridgeSpeedDial(this.selectedProducts);

  Future<void> _dialogAdd(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AddProductForm();
      },
    );
  }
  
  void refresh(BuildContext context) {
    Navigator.pushReplacement(context,
        new MaterialPageRoute(builder: (context) => new TabsScreen(3)));
  }

  Future<void> confirmDelete(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return DeleteAllAlert();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      icon: Icons.menu,
      animatedIcon: AnimatedIcons.menu_close,
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
      //TODO! Controlar borrado selected cuando se pulsa
      //onOpen: () {
      //   setState(() {
      //     if (selectedProducts.isNotEmpty) {
      //       print('Vaciado del map');
      //       selectedProducts.clear();
      //       print('${selectedProducts.length}');
      //     }
      //   });
      // },
      children: [
        SpeedDialChild(
            child: Icon(Icons.edit),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            label: 'Añadir manualmente',
            onTap: () async {
              await _dialogAdd(context);
              Timer(Duration(seconds: 1), () {
                refresh(context);
              });
            }),
        SpeedDialChild(
            child: Icon(Icons.qr_code),
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            label: 'Añadir mediante escaner',
            onTap: () {
              Navigator.pushReplacement(context,
                  new MaterialPageRoute(builder: (context) => TabsScreen(2)));
            }),
        SpeedDialChild(
          child: Icon(Icons.delete_forever),
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
          label: 'Vaciar nevera',
          onTap: () => confirmDelete(context),
        )
      ],
    );
  }
}
