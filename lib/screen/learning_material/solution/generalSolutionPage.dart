import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:numbercrunching/screen/learning_material/example/example_page.dart';
import '../database_service.dart';
class generalSolutionPage extends StatefulWidget {
  final String method;

  generalSolutionPage({this.method});

  @override
  _generalSolutionPageState createState() => _generalSolutionPageState(method);
}

class _generalSolutionPageState extends State<generalSolutionPage> {

  String _method;

  _generalSolutionPageState(String method){
    _method = method;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('General Solution'),
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
                  future: DatabaseService().getMethod(_method),
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
                          Image.network(snapshot.data.data['Solution'], fit: BoxFit.fitWidth,),
                          SizedBox(height: 10.0),
                          Container(
                              child: Text(snapshot.data.data['SolutionText'], style: TextStyle(fontWeight: FontWeight.w600),),
                            padding: EdgeInsets.all(15.0),
                          )
                        ],
                      );
                    }
                  }),
              margin: EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow()],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                child: Text(
                  'Example',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.green,
                onPressed: () {
                  Navigator.push(context, new MaterialPageRoute(builder: (context) => ExamplePage(method: _method)));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
