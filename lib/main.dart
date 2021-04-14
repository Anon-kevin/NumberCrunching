import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screen/homepage.dart';
import 'screen/course_page.dart';
import 'screen/problem_solving/simplex_num_variable_constraint.dart';
import 'screen/problem_solving/sort_num_variable.dart';

const backgroundMainColor = Color(0xFFF2F2F2);
const appBarColor = Color(0xFF46CB18);

void main() {
  runApp(NumberCrunching());
}

class NumberCrunching extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: appBarColor, //or set color with: Color(0xFF0000FF)
    ));
    return MaterialApp(
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (context) => HomePage(),
        // '/optimization': (context) => CoursePage(title: 'Optimization'),
        '/solver/basic_simplex': (context) => SimplexInputNumberOfConstraint(),
        '/solver/quick': (context) => SortingInputNumVariable(type: 1),
        '/solver/merge': (context) => SortingInputNumVariable(type: 2),
        '/sorting': (context) => CoursePage(title: 'Sorting'),
      },
      title: "SORTTTT",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: appBarColor,
        scaffoldBackgroundColor: backgroundMainColor,
        accentColor: Colors.green,
        fontFamily: 'Rubik',
        primaryTextTheme: Theme.of(context)
            .primaryTextTheme
            .apply(bodyColor: Colors.white, fontFamily: 'Rubik'),
        appBarTheme: Theme.of(context).appBarTheme.copyWith(
            elevation: 0.0, iconTheme: IconThemeData(color: Colors.white)),
      ),
//      home: HomePage(),
    );
  }
}

