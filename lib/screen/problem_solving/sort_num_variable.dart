import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'bottom_button.dart';
import 'sort_add_variable.dart';
import 'sort_controller.dart';

SortingController sortingController;

class SortingInputNumVariable extends StatefulWidget {
  final int type;
  SortingInputNumVariable({this.type});
  @override
  _SortingInputNumVariableState createState() => _SortingInputNumVariableState();
}

class _SortingInputNumVariableState extends State<SortingInputNumVariable> {
  bool warnVariable = false;
  bool warnEmpty = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Problem Solving'),
        centerTitle: true,
      ),
//      drawer: DrawTab(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text('NUMBER OF ELEMENTS', style: TextStyle(color: Colors.black87)),
                ),
                TextFormField(
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: '3-10',
                    errorText: warnEmpty
                        ? "Please input"
                        : (warnVariable
                            ? 'The input number must be in range 3 - 10'
                            : null),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  keyboardType: TextInputType.numberWithOptions(signed: true),
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                    BlacklistingTextInputFormatter.singleLineFormatter
                  ],
                  onChanged: (val) {
                    if (val.length >= 2) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    }
                  },
                  controller: elementController,
                ),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: BottomBackButton(),
              ),
              SizedBox(width: 60.0),
              Expanded(
                child: BottomNextButton(onPressed: () {
                  setState(() {
                    warnEmpty = elementController.text == "" ? true : false;
                    if (!warnEmpty) {
                      var varInt = int.parse(elementController.text);
                      warnVariable = varInt < 3 && varInt > 10 ? true : false;
                    }
                  });
                  if (!warnEmpty && !warnVariable) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SortingInputVariable(type: widget.type)));
                  }
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
