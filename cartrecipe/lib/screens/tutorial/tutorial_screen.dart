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
        Padding(
          padding: const EdgeInsets.only(bottom: 50, left: 20, right: 20),
          child: Text(
            listPages[pageChangedInt].title,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 60, left: 20, right: 20),
          child: Text(
            listPages[pageChangedInt].subtitle,
            style: TextStyle(
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: DotsIndicator(
            dotsCount: listPages.length,
            position: pageChangedDouble,
          ),
        ),
        Container(
          child: buildButton(pageChangedInt),
        ),
      ],
    ));
  }

  Widget buildButton(pageChangedInt) {
    return Visibility(
        visible: pageChangedInt == 3,
        maintainState: true,
        maintainAnimation: true,
        maintainSize: true,
        child: ElevatedButton(
            child: Text('Cerrar'),
            onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                new MaterialPageRoute(
                  builder: (context) => new TabsScreen(0),
                ),
                (r) => false)));

    //  else {
    //   return Visibility(
    //   visible: pageChangedInt<3,
    //   child:ElevatedButton(
    //     child: Text('Adelante'),
    //     onPressed: () => pageChangedInt++,
    //   ));
    // }
  }
}
