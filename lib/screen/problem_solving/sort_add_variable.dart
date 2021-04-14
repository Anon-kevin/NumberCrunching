import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numbercrunching/screen/problem_solving/sort_num_variable.dart';
import 'bottom_button.dart';
import 'number_input_field.dart';
import 'sort_controller.dart';
import 'sort_result.dart';
import 'sort_num_variable.dart';

class SortingInputVariable extends StatefulWidget {
  final int type;
  SortingInputVariable({this.type});
  @override
  _SortingInputVariableState createState() => _SortingInputVariableState();
}

class _SortingInputVariableState extends State<SortingInputVariable> {
  List<Widget> elementInput = [];
  int numVar = int.parse(elementController.text);
  bool isFilled = true;

  void setUp() {
    elementInput.clear();
  }

  void modifyInputVariable() {
    for (int i = 0; i < numVar; i++) {
      elementInput.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text("Element ${i+1} : "),
            Expanded(
                child: NumberInputField(controller: listElementController[i]),),
          ],
        ),
      ));
      elementInput.add(SizedBox(width: 3.0));
    }
  }

  @override
  Widget build(BuildContext context) {
    setUp();
    modifyInputVariable();
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Problem Solving'),
        centerTitle: true,
      ),
//      drawer: DrawTab(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Text('LIST OF ELEMENT',
                        style: TextStyle(color: Colors.black87)),
                  ),
                  Column(
                    children: elementInput,
                  ),
                  Visibility(
                    visible: !isFilled,
                    child: Text(
                      "You must input all number in the input field",
                      style: TextStyle(color: Colors.red, fontFamily: 'Arial'),

                    )
                  )
                ],
              ),
            ),
          ),
          Row(
            children: [
              Expanded(child: BottomBackButton()),
              SizedBox(width: 60.0),
              Expanded(
                child: BottomNextButton(
                  onPressed: () {
                    int i;
                    for(i = 0; i < numVar; i++){
                      if(listElementController[i].text == ""){
                        break;
                      }
                    }
                    isFilled = (i == numVar) ? true : false;
                    if(isFilled) {
                      if (sortingController != null) {
                        sortingController = null;
                      }
                      sortingController = new SortingController(widget.type);
                      sortingController.calculateSort();
                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (context) => SortingResultPage()));
                    }
                    else setState(() {
                      isFilled = false;
                    });
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
