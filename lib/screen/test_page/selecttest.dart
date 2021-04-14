import 'package:flutter/material.dart';
import 'package:numbercrunching/screen/test_page/do_test.dart';


class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {

  List<String> images = [
    'assets/images/iconSimplexMethod-06.png',
    'assets/images/iconBranchAndBound-06.png',
    'assets/images/iconCuttingPlane-06.png'
  ];

  List<String> description = [
    'The most basic method to solve Linear Program',
    'The "divide and conquer" method to solve LP with integer conditions',
    'Refine a feasible set or objective function by means of linear inequalities',
  ];

  Widget testOption(String method, String image, String description) {
    return Container(
      height: 100.0,
      margin: EdgeInsets.all(15.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => CreateQuestion(method),
          ));
        },
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Colors.white,
          child: ListTile(
            leading: Image(
              image: AssetImage(image),
              height: 100.0,
            ),
            title: Text(method,
                style: TextStyle(fontSize: 15.0)),
            subtitle: Text(description,
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w100,
                    fontSize: 11.0)),
            trailing: Icon(Icons.navigate_next),
          ),
       ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Column(
          children: <Widget>[
            testOption("Simplex Method", images[0], description[0]),
            testOption("Branch And Bound Method", images[1], description[1]),
            testOption("Cutting Plane Method", images[2], description[2]),
          ],
        ),
      ],
    );
  }
}