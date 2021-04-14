import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../drawer.dart';
import '../models/user.dart';
import '../pages/forum_page.dart';
import '../widgets/progress_widget.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with AutomaticKeepAliveClientMixin<SearchPage>{

  TextEditingController searchTextEditingController = TextEditingController();
  Future<QuerySnapshot> futureSearchResult;

  emptyTextFormField(){
    searchTextEditingController.clear();
  }

  controlSearching(String str){
    Future<QuerySnapshot> allUsers = usersReference.where("profileName", isGreaterThanOrEqualTo: str).getDocuments();
    setState(() {
      futureSearchResult = allUsers;
    });
  }

  AppBar searchPageHeader(){
    return AppBar(
      title: TextFormField(
        style: TextStyle(fontSize: 18.0, color: Colors.white),
        controller: searchTextEditingController,
        decoration: InputDecoration(
          hintText: "Search...",
          hintStyle: TextStyle(color: Colors.white),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          filled: true,
          prefixIcon: Icon(Icons.person_pin, color: Colors.white, size: 30.0,),
          suffixIcon: IconButton(icon: Icon(Icons.clear, color: Colors.white), onPressed: emptyTextFormField,)
        ),
        onFieldSubmitted: controlSearching,
      ),
    );
  }
  Container displayNoSearchResultScreen(){
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Center(
        child: ListView(
//          shrinkWrap: true,
          children: <Widget>[
            Icon(Icons.group, color: Colors.grey, size: 200.0,),
            Text(
              "Search Users",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey,fontSize: 65.0,fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
  displayUserFoundScreen(){
    return FutureBuilder(
      future: futureSearchResult,
      builder: (context, dataSnapshot){
        if(!dataSnapshot.hasData) return circularProgress();
        List<UserResult> searchUsersResult = [];
        dataSnapshot.data.documents.forEach((document){
          User eachUser = User.fromDocument(document);
          UserResult userResult = UserResult(eachUser);
          searchUsersResult.add(userResult);
        });
        return ListView(children: searchUsersResult);
      },
    );
  }
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawTab(),
      appBar: searchPageHeader(),
      body: futureSearchResult == null ? displayNoSearchResultScreen() : displayUserFoundScreen(),

    );
  }
}

class UserResult extends StatelessWidget {
  final User eachUser;
  UserResult(this.eachUser);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3.0),
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: ()=>print("Tapped"),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.black,
                  backgroundImage: CachedNetworkImageProvider(eachUser.url),
                ),
                title: Text(
                  eachUser.profileName,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  eachUser.username,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13.0,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
