import 'package:flutter/material.dart';
import 'package:numbercrunching/screen/course_page.dart';
import 'package:numbercrunching/screen/learning_material/description_page/sort_page.dart';

import 'description_page/bb_page.dart';
import 'description_page/cutting_plane_page.dart';
import 'description_page/simplex_page.dart';

const PrimaryColor = const Color(0xFF3786FF);
const backgroundMainColor = Color(0xFFF2F2F2);

class LearningMaterialPageState extends State<LearningMaterialPage> {
  String _type;

  LearningMaterialPageState(String type) {
    this._type = type;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _type == 'Optimization'
              ? BuildSuggestion()._buildOptimization(context)
              : BuildSuggestion()._buildSorting(context),
        ],
      ),
    );
  }
}

class LearningMaterialPage extends StatefulWidget {
  final String type;

  const LearningMaterialPage({Key key, this.type}) : super(key: key);

  @override
  LearningMaterialPageState createState() => LearningMaterialPageState(type);
}

class BuildSuggestion {
  List<Widget> sortList = [];
  List<String> sort = [
    'Quick Sort',
    'Merge Sort',
    'Bubble Sort',
    'Insertion Sort'
  ];

  void contructSortList(BuildContext context) {
    sort.forEach((element) {
      sortList.add(Container(
          height: 100.0,
          margin: EdgeInsets.all(15.0),
          child: FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            color: Colors.white,
            child: ListTile(
              title: Text(element),
              trailing: Icon(Icons.navigate_next),
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SortPage(sort: element)));
            },
          )));
    });
  }

  Widget _buildOptimization(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            height: 100.0,
            margin: EdgeInsets.all(15.0),
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: Colors.white,
              child: ListTile(
                leading: Image(
                  image: AssetImage('assets/images/iconSimplexMethod-06.png'),
                  height: 100.0,
                ),
                title: Text(
                  "Simplex Method",
                ),
                subtitle: Text("The most basic method to solve Linear Program",
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.normal,
                        fontSize: 10.0)),
                trailing: Icon(Icons.navigate_next),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SimplexLearningPage()));
              },
            )),
        Container(
            height: 100.0,
            margin: EdgeInsets.all(15.0),
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: Colors.white,
              child: ListTile(
                leading: Image(
                  image: AssetImage('assets/images/iconBranchAndBound-06.png'),
                  height: 100.0,
                ),
                title:
                    Text("Branch and Bound", style: TextStyle(fontSize: 18.0)),
                subtitle: Text(
                    'The "divide and conquer" method to solve LP with integer conditions',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.normal,
                        fontSize: 10.0)),
                trailing: Icon(Icons.navigate_next),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BBLearningPage()));
              },
            )),
        Container(
            height: 100.0,
            margin: EdgeInsets.all(15.0),
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CuttingPlaneLearningPage()));
              },
              child: ListTile(
                leading: Image(
                  image: AssetImage('assets/images/iconCuttingPlane-06.png'),
                  height: 100.0,
                ),
                title: Text("Cutting Plane", style: TextStyle(fontSize: 18.0)),
                subtitle: Text(
                    "Refine a feasible set or objective function by means of linear inequalities",
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.normal,
                        fontSize: 10.0)),
                trailing: Icon(Icons.navigate_next),
              ),
            )),
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }

  Widget _buildSorting(BuildContext context) {
    contructSortList(context);
    return Column(
      children: sortList,
    );
  }
}
