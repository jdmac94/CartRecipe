import 'package:flutter/material.dart';
import 'package:cartrecipe/screens/tabs_screens.dart';
import 'package:cartrecipe/screens/profile/edit_preferences_screen.dart';
import 'package:cartrecipe/widgets/preferences/allergens.dart';
import 'package:cartrecipe/widgets/preferences/product_bans.dart';
import 'package:cartrecipe/widgets/preferences/wanted_tags.dart';
import 'package:cartrecipe/widgets/preferences/dieta.dart';
import 'package:cartrecipe/widgets/preferences/nivel_cocina.dart';
import 'package:cartrecipe/api/api_wrapper.dart';

class EdittingPreferencesScreen extends StatefulWidget {
  final int receivedPage;

  EdittingPreferencesScreen(this.receivedPage);
  @override
  State<EdittingPreferencesScreen> createState() =>
      _EdittingPreferencesScreen();
}

class _EdittingPreferencesScreen extends State<EdittingPreferencesScreen> {
  EditPreferencesScreen edit = new EditPreferencesScreen();
  int _selectedPageIndex;
  List<String> allergenList = [];
  void initState() {
    _selectedPageIndex = widget.receivedPage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(edit.getPantalla);
    return Scaffold(
        appBar: AppBar(
          title: Text('Preferencias'),
        ),
        body: Column(
          children: [
            if (_selectedPageIndex == 0)
              Expanded(child: Allergens())
            else if (_selectedPageIndex == 1)
              Expanded(child: Dieta())
            else if (_selectedPageIndex == 2)
              Expanded(child: NivelCocina())
            else if (_selectedPageIndex == 3)
              Expanded(child: WantedTags())
            else if (_selectedPageIndex == 4)
              Expanded(child: ProductBans()),
            buildButton()
          ],
        ));
  }

  Widget buildButton() {
    if (_selectedPageIndex == 0)
      Allergens().getAllergensArray.forEach((element) {
        if (element[0] == true) allergenList.add("en:" + (element[1]));
      });
    return ElevatedButton(
        child: Text('Guardar'),
        onPressed: () => {
              if (_selectedPageIndex == 0)
                ApiWrapper().modAlergias(allergenList)
              else if (_selectedPageIndex == 1)
                ApiWrapper().modDieta(Dieta().getVegan, Dieta().getVegetarian)
              else if (_selectedPageIndex == 2)
                ApiWrapper().modNivel(NivelCocina().getNivel)
              else if (_selectedPageIndex == 3)
                ApiWrapper().modTags(WantedTags().getTagsArray)
              else if (_selectedPageIndex == 4)
                ApiWrapper().modBanned(ProductBans().getProducts),
              Navigator.pushAndRemoveUntil(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => EditPreferencesScreen(),
                  ),
                  (r) => false)
            });
  }
}
