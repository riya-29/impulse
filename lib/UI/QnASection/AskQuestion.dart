import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:impulse/helper/constants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' as i;

class AskQuestion extends StatefulWidget{
  @override
  _AskQuestionState createState() => _AskQuestionState();
}

class _AskQuestionState extends State<AskQuestion> {
  TextEditingController questionTEC = new TextEditingController();
  String QImage="";
  String checkedSubject="Science";
  bool checkedScience=true;
  bool checkedQuantitative=false;
  bool checkedReasoning=false;
  bool checkedMaths=false;
  bool checkedComputer=false;
  bool checkedEnglish=false;
  bool checkedSst=false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Post"),backgroundColor: Colors.teal,),
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(padding: EdgeInsets.all(5),
                child: TextFormField(
                  style: TextStyle(color: Colors.black,fontSize: 19),
                  controller: questionTEC,
                  maxLines: 10,
                  decoration: InputDecoration(
                    hintText: " Have a Query? Ask...",
                    hintStyle: TextStyle(color: Colors.blueGrey,fontSize: 19)),),
                color: Colors.white,
              ),
              SizedBox(height: 15,),
              GestureDetector(onDoubleTap: (){
                setState(() {
                  QImage="";
                });
              },
                child: Container(padding: EdgeInsets.all(5),
                  color: Colors.white,
                  child: QImage.isNotEmpty?Image.network(QImage):Container(),
                ),
              ),
              QImage.isNotEmpty?Center(child: Text("Double tap to remove the image",style: TextStyle(color: Colors.blueGrey.shade300),),):Container(),
              SizedBox(height: 15,),
              Container(
                child: Column(children: [
                  Container(padding:EdgeInsets.symmetric(horizontal: 15),alignment: Alignment.centerLeft,child: Text("Select Subject:",style: TextStyle(fontWeight:FontWeight.bold,color: Colors.blueGrey,fontSize: 17))),
                  SingleChildScrollView(scrollDirection: Axis.horizontal,
                    child: Row(crossAxisAlignment:CrossAxisAlignment.start,
                    children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Checkbox(value: checkedScience, onChanged: (val){
                              setState(() {
                                checkedScience=true;
                                checkedQuantitative=false;
                                checkedReasoning=false;
                                checkedMaths=false;
                                checkedComputer=false;
                                checkedEnglish=false;
                                checkedSst=false;
                                checkedSubject="Science";
                              });
                            },),Text("Science",style: TextStyle(fontWeight:FontWeight.normal,color: Colors.black,fontSize: 16)),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(value: checkedReasoning, onChanged: (val){
                              setState(() {
                                checkedScience=false;
                                checkedQuantitative=false;
                                checkedReasoning=true;
                                checkedMaths=false;
                                checkedComputer=false;
                                checkedEnglish=false;
                                checkedSst=false;
                                checkedSubject="Reasoning";
                              });
                            },),Text("Reasoning",style: TextStyle(fontWeight:FontWeight.normal,color: Colors.black,fontSize: 16)),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(value: checkedComputer, onChanged: (val){
                              setState(() {
                                checkedScience=false;
                                checkedQuantitative=false;
                                checkedReasoning=false;
                                checkedMaths=false;
                                checkedComputer=true;
                                checkedEnglish=false;
                                checkedSst=false;
                                checkedSubject="Computer";
                              });
                            },),Text("Computer",style: TextStyle(fontWeight:FontWeight.normal,color: Colors.black,fontSize: 16)),
                          ],
                        ),
                        Row(
                        children: [
                          Checkbox(value: checkedEnglish, onChanged: (val){
                            setState(() {
                              checkedScience=false;
                              checkedQuantitative=false;
                              checkedReasoning=false;
                              checkedMaths=false;
                              checkedComputer=false;
                              checkedEnglish=true;
                              checkedSst=false;
                              checkedSubject="English";
                            });
                          },),Text("English",style: TextStyle(fontWeight:FontWeight.normal,color: Colors.black,fontSize: 16)),
                        ],
                      ),
                    ],),
                      Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Checkbox(value: checkedQuantitative, onChanged: (val){
                              setState(() {
                                checkedScience=false;
                                checkedQuantitative=true;
                                checkedReasoning=false;
                                checkedMaths=false;
                                checkedComputer=false;
                                checkedEnglish=false;
                                checkedSst=false;
                                checkedSubject="Quantitative Aptitude";
                              });
                            },),Text("Quantitative Aptitude",style: TextStyle(fontWeight:FontWeight.normal,color: Colors.black,fontSize: 16)),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(value: checkedMaths, onChanged: (val){
                              setState(() {
                                checkedScience=false;
                                checkedQuantitative=false;
                                checkedReasoning=false;
                                checkedMaths=true;
                                checkedComputer=false;
                                checkedEnglish=false;
                                checkedSst=false;
                                checkedSubject="Mathematics";
                              });
                            },),Text("Mathematics",style: TextStyle(fontWeight:FontWeight.normal,color: Colors.black,fontSize: 16)),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(value: checkedSst, onChanged: (val){
                              setState(() {
                                checkedScience=false;
                                checkedQuantitative=false;
                                checkedReasoning=false;
                                checkedMaths=false;
                                checkedComputer=false;
                                checkedEnglish=false;
                                checkedSst=true;
                                checkedSubject="Social Science";
                              });
                            },),Text("Social Science",style: TextStyle(fontWeight:FontWeight.normal,color: Colors.black,fontSize: 16)),
                          ],
                        )
                    ],),
                    ],),
                  ),
              ],),),
              SizedBox(height: 30,),
              Divider(),
              Row(mainAxisAlignment: MainAxisAlignment.end,crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(onTap: (){
                      uploadImage();
                    }, child: Icon(Icons.camera_alt,size: 28,)),
                  SizedBox(width: 25,),
                  GestureDetector(onTap: (){
                    if(questionTEC.text.isNotEmpty||QImage.isNotEmpty) {
                          uploadPost();
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Loading()));
                        }
                      }, child: Text("POST",style: TextStyle(fontWeight:FontWeight.bold,color: Colors.redAccent,fontSize: 18),)),
                  SizedBox(width: 25,)
              ],),
              SizedBox(height: 15,)
            ],
          ),
        ),
      ),
    );
  }

  uploadPost() async {
    Map<String,dynamic> uploadQuestion={
     "Question":questionTEC.text,
     "QImage":QImage,
    "Unanswered":"false",
    "Subject":checkedSubject,
      "AskedBy":Constants.myEmail,
      "Answer":[],
      "Time":DateTime.now().toString()
    };
    await FirebaseFirestore.instance.collection('AskedQuestions').add(uploadQuestion);
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
          QImage = downloadUrl;
          print("IMG$QImage");
        });
      } else {print('No Image Path Received');}
    } else {print('Permission not granted. Try Again with permission access');}
  }
}

class Loading extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Container(
        child: Center(child: Text("Post ✓",style: TextStyle(color: Colors.blueGrey,fontSize: 29,),)),),),
    );
  }
}