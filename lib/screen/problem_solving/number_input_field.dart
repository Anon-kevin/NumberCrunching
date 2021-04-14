import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberInputField extends StatefulWidget {
  NumberInputField({this.controller});
  final TextEditingController controller;
  @override
  _NumberInputFieldState createState() => _NumberInputFieldState();
}

class _NumberInputFieldState extends State<NumberInputField> {
  FocusNode myFocusNode;

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      child: TextFormField(
        autofocus: true,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.green)),
        ),
        textDirection: TextDirection.ltr,
        keyboardType: TextInputType.numberWithOptions(signed: true),
        inputFormatters: [
          WhitelistingTextInputFormatter.digitsOnly,
          BlacklistingTextInputFormatter.singleLineFormatter,
        ],
        onTap: (){
          myFocusNode.requestFocus();
        },
        onChanged: (text) {
          if (text.length >= 5) {
            FocusScope.of(context).requestFocus(FocusNode());
          }
        },
        controller: widget.controller,
      ),
    );
  }
}


//class NumberInputField extends StatelessWidget {
//
//
//
//
//  @override
//  Widget build(BuildContext context) {
//
//  }
//}
