import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'drawer.dart';
import '../data/data.dart';

class DashOption extends StatelessWidget {
  final String image;
  final String title;
  final String next;

  DashOption({this.image, this.title, this.next});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: FlatButton(
          onPressed: () {
            Navigator.pushNamed(context, next);
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Image(
                  image: AssetImage(image),
                  height: 50.0,
                ),
                Text(title)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true,
      ),
      drawer: DrawTab(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 25.0, 10.0, 10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0, left: 5.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                ),
                padding: EdgeInsets.all(10.0),
                child: Center(
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 150.0,
                            child: Text(
                              "Hello my friend",
                              style: TextStyle(
                                fontSize: 24.0,
                                fontFamily: 'Monserrat',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Container(
                            width: 150.0,
                            child: Text(
                              "What would you like to learn today?",
                              style: TextStyle(fontFamily: 'Montserrat'),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Image(
                        image: AssetImage('assets/images/homepage-icon.png'),
                        height: 200.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              children: [
                DashOption(
                  image: optimization.getImage(),
                  title: optimization.getName(),
                  next: optimization.getNext(),
                ),
                SizedBox(width: 15.0),
                DashOption(
                  image: sorting.getImage(),
                  title: sorting.getName(),
                  next: sorting.getNext(),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(child: Container()),
                Expanded(child: Container())
              ],
            ),
            Row(
              children: [
                Expanded(child: Container()),
                Expanded(child: Container())
              ],
            )
          ],
        ),
      ),
    );
  }
}
