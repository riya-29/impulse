import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:impulse/helper/constants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' as i;

class AnswerPage extends StatefulWidget{
  final String u_name;
  final String u_username;
  final String u_image;
  final String question;
  final String qImage;
  final String time;
  AnswerPage({this.u_name,this.u_username,this.u_image,this.question,this.qImage,this.time});
  @override
  _AnswerPageState createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {

  TextEditingController answer = new TextEditingController();
  String ans_image="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("New Post"),backgroundColor: Colors.teal),
      body: Container(height: MediaQuery.of(context).size.height-10,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(child: Column(children: [
          Card(
          child: Container(padding: EdgeInsets.symmetric(horizontal: 4,vertical: 8),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment:MainAxisAlignment.end,children: [Text("${widget.time.split('.')[0]}",style: TextStyle(color: Colors.grey,fontSize: 14)),SizedBox(width: 15,)],),
              Row(children: [
                SizedBox(width: 3,),
                CircleAvatar(
                  backgroundColor:Colors.grey.shade50,
                  backgroundImage: widget.u_image.isNotEmpty?NetworkImage(widget.u_image):null,
                child: widget.u_image.isEmpty?Icon(Icons.person):Text("")),
                SizedBox(width: 10,),
                Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                  Text("${widget.u_name}",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold)),
                  Text("@${widget.u_username}",style: TextStyle(color: Colors.blueGrey,fontSize: 15,)),
                ],),
              ],),
              SizedBox(height: 5,),
              Text("${widget.question}"),
              SizedBox(height: 5,),
              Container(child: widget.qImage.isNotEmpty?Image.network("${widget.qImage}"):Container(),),
              Divider(),
              /*Row(mainAxisAlignment:MainAxisAlignment.start,children: [
                Text("Answer",style: TextStyle(color: Colors.redAccent,fontSize: 20,fontWeight: FontWeight.bold,))
                ],),*/
              Container(padding: EdgeInsets.all(5),
                child: TextFormField(
                  style: TextStyle(color: Colors.black,fontSize: 19),
                  controller: answer,
                  maxLines: 10,
                  decoration: InputDecoration(
                      hintText: " Reply...",
                      hintStyle: TextStyle(color: Colors.blueGrey,fontSize: 19)),),
                color: Colors.white,
              ),
              SizedBox(height: 15,),
              GestureDetector(onDoubleTap: (){
                setState(() {
                  ans_image="";
                });
              },
                child: Container(padding: EdgeInsets.all(5),
                  color: Colors.white,
                  child: ans_image.isNotEmpty?Image.network(ans_image):Container(),
                ),
              ),
              ans_image.isNotEmpty?Center(child: Text("Double tap to remove the image",style: TextStyle(color: Colors.blueGrey.shade300),),):Container(),
              SizedBox(height: 15,),
            ],),),),
          Divider(),
          Row(mainAxisAlignment: MainAxisAlignment.end,crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(onTap: (){
                uploadImage();
                }, child: Icon(Icons.camera_alt,size: 28,)),
              SizedBox(width: 25,),
              GestureDetector(onTap: (){
                if(answer.text.isNotEmpty||ans_image.isNotEmpty) {
                  uploadPost();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Loading()));
                }
                }, child: Text("POST",style: TextStyle(fontWeight:FontWeight.bold,color: Colors.redAccent,fontSize: 18),)),
              SizedBox(width: 25,),
            ],),
        ],)),
      ),
    );
  }

  uploadPost() async {
    var ref = await FirebaseFirestore.instance.collection('Users').where('Email',isEqualTo: Constants.myEmail).get();
    print(ref);
    String username_ =ref.docs[0].get('Username');
    String ans = answer.text+"|"+ans_image+"|"+Constants.myName+"|"+username_+"|"+Constants.imageURL;
    List<dynamic> ansList;
    String docId="";
    var n = await FirebaseFirestore.instance.collection("AskedQuestions").get();
    for(int i=0;i<n.docs.length;i++){
      if("${widget.question}".compareTo(n.docs[i].get('Question'))==0 && "${widget.qImage}".compareTo(n.docs[i].get('QImage'))==0){
        docId=n.docs[i].id;
        ansList = n.docs[i].get('Answer');
        break;
      }
    }
    ansList.add(ans);
    Map<String,dynamic> uploadAns={
      "Unanswered":"false",
      "Answer":ansList,
    };

    await FirebaseFirestore.instance.collection('AskedQuestions').doc(docId).update(uploadAns);

  }

  uploadImage() async {
    final _firebaseStorage = FirebaseStorage.instance;
    final _imagePicker = ImagePicker();
    PickedFile image;
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted){
      //Select Image
      image = await _imagePicker.getImage(source: ImageSource.gallery);
      var file = i.File(image.path);
      print("xxx");
      if (image != null){
        //Upload to Firebase
        var snapshot = await _firebaseStorage.ref()
            .child('QuestionImages/${Constants.myEmail}${DateTime.now()}')
            .putFile(file);
        var downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          ans_image = downloadUrl;
          print("IMG$ans_image");
        });
      } else {print('No Image Path Received');}
    } else {print('Permission not granted. Try Again with permission access');}
  }

}


class Loading extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,),
      body: Center(child: Container(child: Text("Post ✓",style: TextStyle(color: Colors.blueGrey,fontSize: 22,),),),),
    );
  }
}