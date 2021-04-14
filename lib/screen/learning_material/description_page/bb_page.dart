import 'package:flutter/material.dart';
import '../../drawer.dart';
import '../description_page.dart';
const backgroundMainColor = Color(0xFFF2F2F2);

class BBLearningPageState extends State<BBLearningPage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundMainColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Branch and Bound Method',
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        centerTitle: true,
      ),
      body: DetailedDescription(method: 'Branch and Bound'),
      drawer: DrawTab(),
    );
  }
}

class BBLearningPage extends StatefulWidget{
  @override
  BBLearningPageState createState() => BBLearningPageState();
}