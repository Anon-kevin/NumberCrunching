import 'package:flutter/material.dart';
import 'package:numbercrunching/screen/learning_material/feedback/feedback.dart';
import '../database_service.dart';
import '../../homepage.dart';
import 'dart:convert';

class SortPage extends StatelessWidget {
  String sort;

  SortPage({this.sort});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(sort),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              child: FutureBuilder(
                  future: DatabaseService().getSorting(sort),
                  builder: (
                    _,
                    snapshot,
                  ) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Column(
                        children: <Widget>[
                          RichText(
                            text: TextSpan(
                                text: sort + '\n \n',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25.0,
                                    color: Colors.black54),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: jsonDecode(r'{ "data":"' +
                                        snapshot.data.data['Description'] +
                                        r'"}')['data'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17.0,
                                        color: Colors.black54),
                                  ),
                                ]),
                          ),
                        ],
                      );
                    }
                  }),
              margin: EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow()],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RaisedButton(
                    child: Text(
                      'Back to home',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.green,
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(context,
                          new MaterialPageRoute(builder: (_) => HomePage()));
                    },
                  ),
                  RaisedButton(
                    child: Text(
                      'Feedback',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.green,
                    onPressed: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => FeedbackPage()));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
