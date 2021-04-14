import 'package:flutter/material.dart';

const backgroundMainColor = Color(0xFFF2F2F2);

class FeedbackPageState extends State<FeedbackPage>{

  final myController = TextEditingController();

  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose(){
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: backgroundMainColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Feedback',
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(15.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white38,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 25.0,
                backgroundImage: AssetImage('assets/images/mycard.jpg'),
              ),
              SizedBox(height: 10.0),
              Text(
                "Nguyễn Hoàng Dũng",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              TextField(
                autofocus: true,
                controller: myController,
                maxLength: 2000,
                decoration: InputDecoration(
                  hintText: 'Please type your feedback here',
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  onTap: () {
                    if (myController.text != "")
                    return showDialog(
                        context: context,
                        builder: (context){
                          return AlertDialog(
                            title: Text('Feedback submitted !'),
                            content: Text("Every feedback of you is valuable for us. Thank you!"),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          );
                      }
                    );
                    return showDialog(
                        context: context,
                        builder: (context){
                          return AlertDialog(
                            title: Text('Error'),
                            content: Text("You must provide your feedback !"),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          );
                        }
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Send', style: TextStyle(color: Colors.green),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FeedbackPage extends StatefulWidget{
  @override
  FeedbackPageState createState() => FeedbackPageState();
}