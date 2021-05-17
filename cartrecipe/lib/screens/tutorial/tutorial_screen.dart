import 'package:cartrecipe/screens/tabs_screens.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

import 'package:cartrecipe/models/tutorial_list_pages.dart';

class TutorialScreen extends StatefulWidget {
  TutorialScreen({Key key}) : super(key: key);

  @override
  _TutorialScreenState createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  PageController pageController = PageController(initialPage: 0);
  int pageChangedInt = 0;
  double pageChangedDouble = 0.0;
  int end = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          child: PageView.builder(
              pageSnapping: true,
              controller: pageController,
              onPageChanged: (index) {
                setState(() {
                  pageChangedInt = index;
                  pageChangedDouble = index.toDouble();
                });
              },
              itemCount: listPages.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(listPages[index].imagePath),
                        scale: 3),
                  ),
                );
              }),
        ),
        Center(
          child: Column(
            children: [
              Text(
                listPages[pageChangedInt].title,
              ),
              Text(
                listPages[pageChangedInt].subtitle,
              ),
              new DotsIndicator(
                dotsCount: listPages.length,
                position: pageChangedDouble,
              ),
              Container(
                child: buildButton(pageChangedInt),
              )
            ],
          ),
        )
      ],
    ));
  }

  Widget buildButton(pageChangedInt) {
    if (pageChangedInt == 3) {
      return ElevatedButton(
          child: Text('Cerrar'),
          onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              new MaterialPageRoute(
                builder: (context) => new TabsScreen(0),
              ),
              (r) => false));
    } else {
      return ElevatedButton(
        child: Text('Adelante'),
        onPressed: () => pageChangedInt++,
      );
    }
  }
}
