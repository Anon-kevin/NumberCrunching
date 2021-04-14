import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'bottom_button.dart';
import 'simplex_add_equation_condition.dart';
import 'simplex_controller.dart';

SimplexController simplexController;

class SimplexInputNumberOfConstraint extends StatefulWidget {
  @override
  _SimplexInputNumberOfConstraintState createState() =>
      _SimplexInputNumberOfConstraintState();
}

class _SimplexInputNumberOfConstraintState
    extends State<SimplexInputNumberOfConstraint> {
  bool warnVariable = false;
  bool warnConstraint = false;
  bool warnEmptyVariable = false;
  bool warnEmptyConstraint = false;

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
                  child: Text('NUMBER OF VARIABLES',
                      style: TextStyle(color: Colors.black87)),
                ),
                TextFormField(
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: '2-5',
                    errorText: warnEmptyVariable
                        ? "Please Input"
                        : (warnVariable
                            ? 'The input number must be in range 2 - 5'
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
                    if (val.length >= 1) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    }
                  },
                  controller: variableController,
                ),
                SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text('NUMBER OF CONSTRAINTS',
                      style: TextStyle(color: Colors.black87)),
                ),
                TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: '2-10',
                    errorText: warnEmptyConstraint
                        ? "Please input"
                        : (warnConstraint
                        ? 'The input number must be in range 2 - 10'
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
                  controller: constraintController,
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
                    warnEmptyVariable =
                    variableController.text == "" ? true : false;
                    if (!warnEmptyVariable) {
                      var varInt = int.parse(variableController.text);
                      warnVariable = varInt < 2 || varInt > 5 ? true : false;
                    }
                    warnEmptyConstraint =
                    constraintController.text == "" ? true : false;
                    if (!warnEmptyConstraint) {
                      var conInt = int.parse(constraintController.text);
                      warnConstraint = conInt < 2 || conInt > 10 ? true : false;
                    }
                  });
                  if (!warnEmptyVariable && !warnEmptyConstraint &&
                      !warnVariable && !warnConstraint) {
                    if (simplexController != null) {
                      simplexController = null;
                    }
                    simplexController = new SimplexController();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SimplexInputConstraint()));
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
