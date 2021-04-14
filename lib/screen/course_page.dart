import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'drawer.dart';
import 'learning_material/learning_material.dart';
import 'not_available.dart';
import 'problem_solving/problem_solving_main.dart';
import 'test_page/selecttest.dart';

class CoursePage extends StatefulWidget {
  final String title;
  CoursePage({Key key, this.title}) : super(key : key);
  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> with SingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'LESSON'),
    Tab(text: 'TEST'),
    Tab(text: 'SOLVER'),
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
           onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.title),
        bottom: TabBar(
          controller: _tabController,
          tabs: myTabs,
        ),
      ),
      drawer: DrawTab(),
      body: TabBarView(
        controller: _tabController,
        children: myTabs.map((Tab tab) {
          final String label = tab.text.toLowerCase();
          if(label == "solver")
            return ProblemSolvingPage(title: widget.title);
          else if(label == "test") if (widget.title == 'Optimization') {
            return TestPage();
          } else
            return NotAvailablePage();
          else {
            return LearningMaterialPage(type: widget.title,);
          }
        }).toList(),
      ),
    );
  }
}

