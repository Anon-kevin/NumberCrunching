import 'package:flutter/material.dart';
import '../../data/data.dart';

class OptionElement extends StatelessWidget {
  final String image;
  final String description;
  final String name;
  final String next;
  final BuildContext context;

  OptionElement({this.image, this.name, this.description, this.context, this.next});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      margin: EdgeInsets.all(15.0),
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: ListTile(
          leading: Image(
            image: AssetImage(image),
            height: 100.0,
          ),
          title: Text(name, style: TextStyle(fontSize: 15.0)),
          subtitle: Text(
            description,
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w100,
                fontSize: 11.0),
          ),
          trailing: Icon(Icons.navigate_next),
        ),
        onPressed: () {
          Navigator.pushNamed(context, next);
        },
      ),
    );
  }
}

class OptionWidgets extends StatelessWidget {
  final String title;
  OptionWidgets({this.title});
  @override
  Widget build(BuildContext context) {
    List<Widget> typeListWidget = List<Widget>();
    List<Solver> solverList;
    if (title == 'Optimization')
      solverList = optimization.getTypeList();
    else if (title == 'Sorting')
      solverList = sorting.getTypeList();
    for (int i = 0; i < solverList.length; i++) {
      typeListWidget.add(
        OptionElement(
          name: solverList[i].getName(),
          description: solverList[i].getDescription(),
          image: solverList[i].getImage(),
          next: solverList[i].getNext(),
          context: context,
        ),
      );
    }
    return Column(
      children: typeListWidget,
    );
  }
}