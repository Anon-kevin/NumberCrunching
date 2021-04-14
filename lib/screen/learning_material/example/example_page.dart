import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:numbercrunching/screen/course_page.dart';
import 'package:numbercrunching/screen/homepage.dart';
import '../database_service.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../description_page/simplex_page.dart';

class ExamplePage extends StatefulWidget {
  final String method;

  const ExamplePage({Key key, this.method}) : super(key: key);

  @override
  ExamplePageState createState() => ExamplePageState(method);
}

class ExamplePageState extends State<ExamplePage>
    with AutomaticKeepAliveClientMixin {
  String _method;

  YoutubePlayerController _controller;

  ExamplePageState(String method) {
    _method = method;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Example'),
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
              FutureBuilder(
                future: DatabaseService().getMethod(_method),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Container(
                      padding: EdgeInsets.all(15.0),
                      margin: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [BoxShadow()],
                      ),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Below is a video showing how to solve the algorithm',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 15.0),
                          YoutubePlayer(
                            controller: YoutubePlayerController(
                                initialVideoId: YoutubePlayer.convertUrlToId(
                                    snapshot.data.data['url']),
                                flags: YoutubePlayerFlags(
                                  autoPlay: false,
                                  mute: false,
                                )),
                            showVideoProgressIndicator: true,
                            progressIndicatorColor: Colors.red,
                            progressColors: ProgressBarColors(
                                playedColor: Colors.greenAccent,
                                handleColor: Colors.orangeAccent),
                            bottomActions: [
                              CurrentPosition(),
                              ProgressBar(isExpanded: true),
                              RemainingDuration(),
                            ],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            'Is this helpful ?',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Container(
                            padding: EdgeInsets.all(15.0),
                            margin: EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                              color: Colors.orangeAccent,
                              boxShadow: [BoxShadow()],
                            ),
                            child: RatingBar(
                              initialRating: 0,
                              minRating: 0,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                return showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Icon(
                                          Icons.sentiment_very_satisfied,
                                          color: Colors.greenAccent,
                                        ),
                                        content: Text(
                                          "Thank you for your rating",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text(
                                              'OK',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      );
                                    });
                              },
                            ),
                          )
                        ],
                      ),
                    );
                  }
                },
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
                        'Continue',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.green,
                      onPressed: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => CoursePage(title: 'Optimization',)));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
