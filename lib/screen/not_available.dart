import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotAvailablePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: [
        Image(image: AssetImage('assets/images/not_available_icon.png')),
        Text(
            "Sorry but the tab you find is currently not available, please select another tab", textAlign: TextAlign.center,),
      ]),
    );
  }
}
