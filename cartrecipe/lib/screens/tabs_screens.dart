import 'package:cartrecipe/screens/fridge_screen.dart';
import 'package:cartrecipe/screens/profile/edit_preferences_screen.dart';
import 'package:cartrecipe/screens/profile/profile_screen.dart';
import 'package:cartrecipe/screens/tutorial/tutorial_screen.dart';

import 'package:cartrecipe/screens/welcome.dart';
import 'package:flutter/material.dart';

import 'package:cartrecipe/screens/recipes/recipes_screen.dart';
import 'package:cartrecipe/screens/search_screen.dart';
import 'package:cartrecipe/screens/scanner_screen.dart';
import 'package:cartrecipe/screens/preferences_screen.dart';

//TODO Posible mejora
enum Pages {
  Recetas,
  Busqueda,
  Escaner,
  Nevera,
  Perfil,
}

class TabsScreen extends StatefulWidget {
  final int receivedPage;

  TabsScreen(this.receivedPage);

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Map<String, Object>> _pages;
  int _selectedPageIndex;

  @override
  void initState() {
    _selectedPageIndex = widget.receivedPage;

    _pages = [
      {
        'page': RecipesScreen(),
        //'page': TutorialScreen(),
        'title': 'Recetas',
      },
      {
        //'page': TutorialScreen(),
        'page': SearchsScreen(),
        //'page': TestStreamScreen(),
        //'page': SearchsScreen(),
        //'page': LocalDesperateFridge(),
        //'page': Welcome(),
        'title': 'Búsqueda',
      },
      {
        'page': ScannerScreen(),
        'title': 'Escáner',
      },
      {
        'page': FridgeScreen(),
        'title': 'Mi nevera',
      },
      {
        'page': ProfileScreen(),
        //'page': PreferencesScreen(),
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
