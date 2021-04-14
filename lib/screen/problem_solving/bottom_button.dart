import 'package:flutter/material.dart';

class BottomBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: 60.0,
      child: FlatButton(
          textColor: Colors.white,
          color: Colors.greenAccent,
          child: Text("BACK", style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: (){
            Navigator.pop(context);
          }
      ),
    );
  }
}

class BottomNextButton extends StatelessWidget {
  BottomNextButton({this.onPressed});
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: 60.0,
      child: FlatButton(
        textColor: Colors.white,
        color: Colors.greenAccent,
        child: Text("NEXT", style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        )),
        onPressed: onPressed,
      ),
    );
  }
}

class BottomFinishButton extends StatelessWidget {
  BottomFinishButton({this.onPressed});
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: 60.0,
      child: FlatButton(
        textColor: Colors.white,
        color: Colors.greenAccent,
        child: Text("FINISH", style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        )),
        onPressed: onPressed,
      ),
    );
  }
}