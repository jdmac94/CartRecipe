import 'package:cartrecipe/providers/product_list_provider.dart';
import 'package:cartrecipe/screens/test_screen.dart';
import 'package:flutter/material.dart';

import 'package:cartrecipe/screens/recipes_screen.dart';
import 'package:cartrecipe/screens/search_screen.dart';
import 'package:cartrecipe/screens/scanner_screen.dart';
import 'package:cartrecipe/screens/my_fridge_screen.dart';
import 'package:cartrecipe/screens/profile_screen.dart';
import 'package:provider/provider.dart';

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
        'page': TestScreen(),
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

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
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
