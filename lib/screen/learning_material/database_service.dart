// This file include function to connect to database
// It will hold a reference to the database

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  static final DatabaseService _databaseService = DatabaseService._internal();

  factory DatabaseService() {
    return _databaseService;
  }

  DatabaseService._internal();

  var databaseReference = Firestore.instance;

  // This method is used to get a method from the database
  Future getMethod(String method) async {
    QuerySnapshot qn =
        await databaseReference.collection("methods").getDocuments();
    DocumentSnapshot Rmethod;

    int i = 0;
    qn.documents.forEach((document) {
      if (document.data['name'] == method) Rmethod = document;
    });

    return Rmethod;
  }

// get Sorting mechanism from database

  Future getSorting(String method) async {
    QuerySnapshot qn =
        await databaseReference.collection("sorting").getDocuments();
    DocumentSnapshot Rmethod;

    int i = 0;
    qn.documents.forEach((document) {
      if (document.data['name'] == method) Rmethod = document;
    });

    return Rmethod;
  }
}
