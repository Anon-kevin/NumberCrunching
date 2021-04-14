import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../drawer.dart';
import '../models/user.dart';
import '../pages/forum_page.dart';
import '../pages/upload_page.dart';
import '../widgets/header_page.dart';
import '../widgets/post_widget.dart';

class TimeLinePage extends StatefulWidget {
  final User gCurrentUser;

  TimeLinePage({this.gCurrentUser});
  @override
  _TimeLinePageState createState() => _TimeLinePageState();
}

class _TimeLinePageState extends State<TimeLinePage> {
  List<Post> posts;
  List<String> followingList = [];
  final scaffordKey = GlobalKey<ScaffoldState>();

  retrieveTimeLine() async {
//    QuerySnapshot querySnapshot = await timelineReference.document(widget.gCurrentUser.id).collection("timelinePosts");
  }


  @override
  void iniState(){
    super.initState();
//    retriveTimeLine();
//    retrieveFollowings();
  }
  @override
  Widget build(context) {
    return Scaffold(
      drawer: DrawTab(),
      appBar: header(context, isAppTitle: true,),
      body: DisplayThis(),
    );
  }
}

class DisplayThis extends StatelessWidget {
  var a=0;
  List postList = [];
  @override
  Widget build(BuildContext context) {
//    return FutureBuilder<QuerySnapshot>(
//        future: Firestore.instance.collection('posts').getDocuments(),
//        builder: (BuildContext context, snapshot) {
//          switch (snapshot.connectionState) {
//            case ConnectionState.waiting:
//              return CircularProgressIndicator();
//              break;
//            default :
//              List <DocumentSnapshot> documents = snapshot.data.documents;
              return Scaffold(
                floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add_comment),
//                  onPressed: ()=> takeImage(),
                ),
                  body: ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: 5,//documents.length,
                      itemBuilder: (BuildContext context, index) {
//      Pets pets = Pets.fromDocument(snapshot.data.documents[index]);
//                        Post po = Post.fromDocument(
//                            snapshot.data.documents[index]);
                        return new ListTile(
//                          title: Text(po.username, style: TextStyle(color: Colors.white),),//
                          title: Text("This should be list of posts retrived from firebase", style: TextStyle(color: Colors.black),),
                          onTap:()=> print("post view create"),
                        );
                      }
                  )
              );
//          }
//        }
//    );
  }
}

//class getAllPost extends DisplayThis{
//  getPosts() async {
////    setState
//    QuerySnapshot querySnapshot = await postReference.getDocuments();
//    postList = querySnapshot.documents.map((do) => null)
//  }
//}
