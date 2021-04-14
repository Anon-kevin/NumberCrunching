import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'sort_num_variable.dart';
import 'bottom_button.dart';


class SortingResultPage extends StatefulWidget {
  @override
  _SortingResultPageState createState() => _SortingResultPageState();
}

class _SortingResultPageState extends State<SortingResultPage> {
  bool showHint = false;
  @override
  Widget build(BuildContext context) {
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
                  Text("SORTING A LIST OF"),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    margin: EdgeInsets.all(12.0),
                    width: double.infinity,
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Text(
                      sortingController.printBefore(),
                      style: TextStyle(fontSize: 18.0, fontFamily: 'Montserrat'),
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Text("TO"),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    margin: EdgeInsets.all(12.0),
                    width: double.infinity,
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Text(
                      sortingController.printAfter(),
                      style: TextStyle(fontSize: 18.0, fontFamily: 'Montserrat'),
                    ),
                  ),
                  Text("NUMBER OF STEPS", style: TextStyle(fontSize: 18.0)),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    margin: EdgeInsets.all(12.0),
                    width: double.infinity,
                    decoration: new BoxDecoration(
                      color: Color(0xFFFFAF7A),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      sortingController.printStepCount(),
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
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      margin: EdgeInsets.all(12.0),
                      width: double.infinity,
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        sortingController.printHint(),
                        style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'Arial',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: BottomFinishButton(
              onPressed: (){
                Navigator.popUntil(context, ModalRoute.withName('/sorting'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
