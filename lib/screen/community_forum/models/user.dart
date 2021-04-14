import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String profileName;
  final String username;
  final String url;
  final String email;
  final String bio;

  User({
    this.id,
    this.profileName,
    this.username,
    this.url,
    this.email,
    this.bio,
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc.documentID,
      email: doc['email'],
      username: doc['username'],
      url: doc['url'],
      profileName: doc['displayName'],
      bio: doc['bio'],
    );
  }
}





class postData {
  final String id;
  final String description;
  final String username;

  postData({
    this.id,
    this.description,
    this.username,
});

  factory postData.fromDocument(DocumentSnapshot doc){
    return postData(
      id: doc.documentID,
      description: doc['description'],
      username: doc['username'],
    );
  }

}