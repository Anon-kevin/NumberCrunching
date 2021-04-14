import 'package:flutter/material.dart';

AppBar header(context, {bool isAppTitle = false, String strTitle, disappearedBackButton=false}){
  return AppBar(
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    automaticallyImplyLeading: disappearedBackButton ? false : true,
    title: Text(
      "Forum PSE",
      style: TextStyle(
        color: Colors.white,
        fontFamily: 'Signatra',
        fontSize: isAppTitle? 45.0 : 22.0,
      ),
      overflow: TextOverflow.ellipsis,
    ),
    centerTitle: true,
    backgroundColor: Theme.of(context).accentColor,
  );
}
