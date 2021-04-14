import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'option.dart';

class ProblemSolvingPage extends StatelessWidget {
  final String title;
  ProblemSolvingPage({this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
            child: OptionWidgets(title: title),
        ),
    );
  }
}
