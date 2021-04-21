import 'package:flutter/material.dart';

import 'package:cartrecipe/screens/recipes_screen.dart';
import 'package:cartrecipe/screens/search_screen.dart';
import 'package:cartrecipe/screens/scanner_screen.dart';
import 'package:cartrecipe/screens/my_fridge_screen.dart';
import 'package:cartrecipe/screens/profile_screen.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Map<String, Object>> _pages;
  int _selectedPageIndex = 3;

  @override
  void initState() {
    _pages = [
      {
        'page': RecipesScreen(),
        'title': 'Recetas',
      },
      {
        'page': SearchsScreen(),
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
        unselectedItemColor: Colors.black,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            //backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.receipt),
            label: 'Recetas',
          ),
          BottomNavigationBarItem(
            //backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.search),
            label: 'Búsqueda',
          ),
          BottomNavigationBarItem(
            //backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.scanner),
            label: 'Escáner',
          ),
          BottomNavigationBarItem(
            //backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.bookmark),
            label: 'Mi nevera',
          ),
          BottomNavigationBarItem(
            //backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.verified_user),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
