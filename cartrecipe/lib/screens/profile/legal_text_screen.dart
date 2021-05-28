import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LegalTextScreen extends StatefulWidget {
  final String appText;
  LegalTextScreen(this.appText);

  @override
  _LegalTextScreenState createState() => _LegalTextScreenState();
}

class _LegalTextScreenState extends State<LegalTextScreen> {
  List<String> _lines = [];

  Future<List<String>> _loadText() async {
    List<String> questions = [];
    await rootBundle
        .loadString('assets/documentation/lorem_ipsum.txt')
        .then((q) {
      for (String i in LineSplitter().convert(q)) {
        questions.add(i);
      }
    });
    return questions;
  }

  @override
  void initState() {
    super.initState();
    _setup();
  }

  _setup() async {
    // Retrieve the questions (Processed in the background)
    List<String> questions = await _loadText();

    // Notify the UI and display the questions
    setState(() {
      _lines = questions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appText),
      ),
      body: Center(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
                itemCount: _lines.length,
                itemBuilder: (context, index) {
                  return Text(
                    _lines[index],
                    textAlign: TextAlign.justify,
                  );
                }),
          ),
        ),
      ),
    );
  }
}
