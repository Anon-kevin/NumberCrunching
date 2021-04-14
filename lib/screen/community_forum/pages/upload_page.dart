//import 'dart:js';

import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:numbercrunching/screen/community_forum/models/user.dart';
import 'package:numbercrunching/screen/community_forum/pages/forum_page.dart';
import 'package:numbercrunching/screen/community_forum/widgets/progress_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as ImD;

import '../../drawer.dart';

class UploadPage extends StatefulWidget {
  final User gCurrentUser;

  UploadPage({this.gCurrentUser});

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> with AutomaticKeepAliveClientMixin<UploadPage>{
  File file;
  bool uploading = false;
  String postId = Uuid().v4();
  TextEditingController titleTextEditingController = TextEditingController();
  TextEditingController descriptionTextEditingController = TextEditingController();

  captureImageWithCamera() async {
    Navigator.pop(context);
    final picked = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxHeight: 680,
      maxWidth: 970,
    );
    setState(() {
      this.file = File(picked.path);
    });
  }
  pickImageFromGallery() async {
    Navigator.pop(context);
    final picked = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    setState(() {
      this.file = File(picked.path);
    });
  }
  takeImage(mContext){
    return showDialog(
      context: mContext,
      builder: (context){
        return SimpleDialog(
          title: Text("New post", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
          children: <Widget>[
            SimpleDialogOption(
              child: Text("Capture image with camera", style: TextStyle(color: Colors.black),),
              onPressed: captureImageWithCamera,
            ),
            SimpleDialogOption(
              child: Text("Capture image with Gallery", style: TextStyle(color: Colors.black),),
              onPressed: pickImageFromGallery,
            ),
            SimpleDialogOption(
              child: Text("Cancel", style: TextStyle(color: Colors.black),),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      }
    );
  }
  displayUploadScreen(){
    return Container(
//      color: Theme.of(context).accentColor,
    color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.add_photo_alternate, color: Colors.grey, size: 200.0,),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9.0)),
              child: Text("Upload image", style: TextStyle(color: Colors.white, fontSize: 20.0),),
              color: Colors.blue,
              onPressed: ()=> takeImage(context),
            ),
          )
        ],
      ),
    );
  }
  clearPostInfo(){
    titleTextEditingController.text = '';
    descriptionTextEditingController.text = '';
    setState(() {
      file = null;
    });
  }
  compressingPhoto() async{
    final tDirectory = await getTemporaryDirectory();
    final path = tDirectory.path;
    ImD.Image mImageFile = ImD.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postId.jpg')..writeAsBytesSync(ImD.encodeJpg(mImageFile, quality: 90));
    setState(() {
      file = compressedImageFile;
    });
  }
  controlUploadAndSave()async{
    setState(() {
      uploading = true;
    });
    await compressingPhoto();
    String downloadUrl = await uploadPhoto(file);

    savePostInfoToFireStore(url: downloadUrl, title: titleTextEditingController.text, description: descriptionTextEditingController.text);
    titleTextEditingController.text = '';
    descriptionTextEditingController.text = '';
    setState(() {
      file = null;
      uploading = false;
      postId = Uuid().v4();
    });
  }
  savePostInfoToFireStore({String url, String title, String description}){
    postsReference.document(widget.gCurrentUser.id).collection("usersPosts").document(postId).setData({
      "postId": postId,
      "ownerId": widget.gCurrentUser.id,
      "timestamp": timestamp,
      "likes": {},
      "username": widget.gCurrentUser.username,
      "title": title,
      "description": description,
      "url": url,
    });
  }

  Future<String> uploadPhoto(mImageFile) async {
    StorageUploadTask mStorageUploadTask = storageReference.child("post_$postId.jpg").putFile(mImageFile);
    StorageTaskSnapshot storageTaskSnapshot = await mStorageUploadTask.onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
  displayUploadFormScreen(){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.white,),onPressed: clearPostInfo,),
        title: Text("New post", style: TextStyle(fontSize: 24.0, color: Colors.white,fontWeight: FontWeight.bold),),
        actions: <Widget>[
          FlatButton(
            onPressed: uploading ? null : ()=> controlUploadAndSave(),
            child: Text("Share", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16.0 ),),
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          uploading ? linearProgress() : Text(""),
          Container(height: 230.0, width: MediaQuery.of(context).size.width*0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16/9,
                child: Container(
                  decoration: BoxDecoration(image: DecorationImage(image: FileImage(file), fit: BoxFit.cover,)),
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 12.0),),
          ListTile(
            leading: CircleAvatar(backgroundImage: CachedNetworkImageProvider(widget.gCurrentUser.url),),
            title: Container(
                width: 250.0,
                child: TextField(
                  style: TextStyle(color: Colors.black),
                  controller: titleTextEditingController,
                  decoration: InputDecoration(
                    hintText: "Enter title here",
                    hintStyle: TextStyle(color: Colors.black),
                    border: InputBorder.none,
                  ),
                ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.chat, color: Colors.grey,),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.black),
                controller: descriptionTextEditingController,
                decoration: InputDecoration(
                  hintText: "Describe your problem here...",
                  hintStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
  Widget build(BuildContext context) {
//    return displayUploadScreen();
  return file == null ? displayUploadScreen() : displayUploadFormScreen();
  }
}













