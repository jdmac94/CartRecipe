import 'package:cartrecipe/screens/nevera_test.dart';
import 'package:flutter/material.dart';

import 'package:cartrecipe/screens/recipes_screen.dart';
import 'package:cartrecipe/screens/search_screen.dart';
import 'package:cartrecipe/screens/scanner_screen.dart';
import 'package:cartrecipe/screens/my_fridge_screen.dart';
import 'package:cartrecipe/screens/profile_screen.dart';
import 'nevera_test.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;

  @override
  void initState() {
    _pages = [
      {
        'page': RecipesScreen(),
        'title': 'Recetas',
      },
      {
        //'page': SearchsScreen(),
        'page': NeveraTest(),
        'title': 'Búsqueda',
      },
      {
        'page': ScannerScreen(),
        'title': 'Escáner',
      },
      {
        'page': MyFridgeScreen(),
        'title': 'Mi nevera',
      },
      {
        'page': ProfileScreen(),
        'title': 'Perfil',
      },
    ];

    super.initState();
  }

  String _data = "";
  String _productname = "";

  _scan() async {
    await FlutterBarcodeScanner.scanBarcode(
            "#000000", "Cancelar", true, ScanMode.BARCODE)
        .then((value) => setState(() => _data = value));
  }

  void _selectPage(int index) {
    setState(() {
      //var tempIndex = index;

      _selectedPageIndex = index;

      // if (_selectedPageIndex == 2) {
      //   print('Seleccionado el escaner');
      //   _scan();
      //   _selectedPageIndex = tempIndex;
      // }

      // if (_selectedPageIndex == 4) {
      //   _selectedPageIndex = 3;
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_selectedPageIndex]['title']),
      ),
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Theme.of(context).accentColor,
        unselectedItemColor: Colors.white,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            //backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.menu_book),
            label: 'Recetas',
          ),
          BottomNavigationBarItem(
            //backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.search),
            label: 'Búsqueda',
          ),
          BottomNavigationBarItem(
            //backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.qr_code_scanner),
            label: 'Escáner',
          ),
          BottomNavigationBarItem(
            //backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.kitchen),
            label: 'Mi nevera',
          ),
          BottomNavigationBarItem(
            //backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.account_circle),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
