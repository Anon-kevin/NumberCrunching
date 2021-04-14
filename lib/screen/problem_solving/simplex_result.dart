import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numbercrunching/screen/problem_solving/bottom_button.dart';
import 'package:numbercrunching/screen/problem_solving/simplex_num_variable_constraint.dart';
import 'package:flutter_tex/flutter_tex.dart';
import '../drawer.dart';

class ResultPage extends StatefulWidget {
  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  bool showHint = false;
  @override
  Widget build(BuildContext context) {
    simplexController.calculateResult();
    return Scaffold(
      appBar: AppBar(
        title: Text('Problem Solving',
            style: TextStyle(fontWeight: FontWeight.w300)),
        centerTitle: true,
      ),
//      drawer: DrawTab(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text("FIND MAXIMUM OF"),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    margin: EdgeInsets.all(12.0),
                    width: double.infinity,
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Text(
                      simplexController.printEquation(),
                      style: TextStyle(fontSize: 18.0, fontFamily: 'Montserrat'),
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Text("UNDER CONSTRAINT"),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    margin: EdgeInsets.all(12.0),
                    width: double.infinity,
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Text(
                      simplexController.printCondition(),
                      style: TextStyle(fontSize: 18.0, fontFamily: 'Montserrat'),
                    ),
                  ),
                  Text("THE RESULT IS", style: TextStyle(fontSize: 18.0)),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    margin: EdgeInsets.all(12.0),
                    width: double.infinity,
                    decoration: new BoxDecoration(
                      color: Color(0xFFFFAF7A),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      simplexController.printResult(),
                      style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !showHint,
                    child: RaisedButton(
                      onPressed: () {
                        setState(() {
                          showHint = true;
                        });
                      },
                      child: Text(
                        "HINT TO SOLVE THIS PROBLEM",
                        style:
                            TextStyle(color: Colors.white),
                      ),
                      color: Colors.green,
                    ),
                  ),
                  Visibility(
                    visible: showHint,
                    child: RaisedButton(
                      onPressed: () {
                        setState(() {
                          showHint = false;
                        });
                      },
                      child: Text("CLOSE HINT"),
                    ),
                  ),
                  Visibility(
                    visible: showHint,
                    child: HintTab(),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: BottomFinishButton(
              onPressed: (){
                Navigator.popUntil(context, ModalRoute.withName('/optimization'));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class HintTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.all(12.0),
      width: double.infinity,
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        children: [
          Text(
            simplexController.printHintFirst(),
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: 'Montserrat',
            ),
          ),
          SingleChildScrollView(scrollDirection: Axis.horizontal,child: simplexController.printTableu()),
          Text(
            simplexController.printHintSecond(),
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: 'Montserrat',
            ),
          ),
          SingleChildScrollView(scrollDirection: Axis.horizontal,child: simplexController.printTableuFinal()),
        ],
      ),
    );
  }
}
