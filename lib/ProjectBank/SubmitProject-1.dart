import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:impulse/helper/constants.dart';
import 'package:permission_handler/permission_handler.dart';

class SubmitProject extends StatefulWidget {
  @override
  _SubmitProjectState createState() => _SubmitProjectState();
}

class _SubmitProjectState extends State<SubmitProject> {
  String imageUrl;
  TextEditingController titleTEC = new TextEditingController();
  TextEditingController abstarctTEC = new TextEditingController();
  TextEditingController contentTEC = new TextEditingController();
  TextEditingController summaryTEC = new TextEditingController();


String _category;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  final formKey =GlobalKey<FormState>();

  final List<String> category=['Computer Science','Mechanical','Robotics','Information Technology','Electrical'];
  List<String> tags=List<String>(10);
  DateTime date=DateTime.now();
  String name=Constants.myName;
  String photo=Constants.imageURL;
  String email=Constants.myEmail;
  sendProject() async {
    Map<String,dynamic> ProjectDataMap={
      "title":titleTEC.text,
      "category":_category,
      "abstract":abstarctTEC.text,
      "image":imageUrl,
      "name":name,
      "email":email,
      "photo":photo,
      "date":date,
      "summary":summaryTEC.text,
      "content":contentTEC.text,
    };

    await FirebaseFirestore.instance.collection("ProjectBank").add(ProjectDataMap).then((value) => print(value));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(title:Text("Project"),
      elevation: 0, brightness: Brightness.light, backgroundColor: Colors.teal,),
      body:SingleChildScrollView(
        child: Form(key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment:CrossAxisAlignment.start ,
              children:[
                SizedBox(height: 10,),
                Text("Submit Project",
                    style:TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)
                ),
                SizedBox(height: 10,),
                Text("Provide all required information along with supporting details",
                    style:TextStyle(color: Colors.black, fontSize: 15, )
                ),
                TextFormField(
                  controller: titleTEC,
                  validator: (val){return titleTEC.text.isNotEmpty?null:"Title Required";},
                  decoration: const InputDecoration(
                    hintText: "Enter Project Title",
                    labelText:'Project Title',
                  ),
                ),
                SizedBox(height:20),
                Container(height: 60,
                  child: TextFormField(
                    controller: summaryTEC,
                    validator: (val){return summaryTEC.text.isNotEmpty?null:"Required field";},
                    decoration: const InputDecoration(
                      hintText: "Descibe your project in 2 lines",
                      labelText:'Summary',
                    ),
                    maxLines: 2,
                  ),
                ),
                SizedBox(height:20),
                //dropdown
                DropdownButtonFormField(
                  hint: Text("--Select Category--"),
                  items: category.map((category)
                {
                  return DropdownMenuItem(value:category,
                  child:Text('$category'));
                }).toList(),
                  onChanged: (val)=>setState(()=>_category=val),

                  validator: (value)=>value==null?'Please enter category of project':null,
                ),

                SizedBox(height:20),
                Container(
                  margin: EdgeInsets.all(10),color: Colors.grey.shade50,
                  child: TextFormField(
                    controller: abstarctTEC,
                    maxLines: 5,
                    validator: (val){return abstarctTEC.text.isNotEmpty?null:"Abstract is Required";},
                    decoration: const InputDecoration(
                      hintText: "Enter an abstract. Be as elaborate as possible in mentioning all details about your project.",
                      labelText:'Abstract',
                    ),

                  ),
                ),
                SizedBox(height:20),
                InkWell(onTap: (){
                     uploadImage();},
                    child: (imageUrl!= null&&imageUrl!="")
                        ? Image.network(imageUrl)
                        : Image.asset("asset/images/upload.png")
                ),
                SizedBox(height:20),
                Container(
                  margin: EdgeInsets.all(10),color: Colors.grey.shade50,
                  child: TextFormField(
                    controller:contentTEC,
                    maxLines: 5,
                    validator: (val){return contentTEC.text.isNotEmpty?null:"is Required";},
                    decoration: const InputDecoration(
                      hintText: "Enter the contents of your project.\nIt may be modules or some software hardware required of your project.",
                      labelText:'Enter Contents',
                    ),
                  ),
                ),
                SizedBox(height:20),
                Center(
                  child: FlatButton(height: 50, minWidth: 120,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text("Submit",style:TextStyle(color:Colors.white,fontSize: 15)),
                    color: Colors.teal,
                    onPressed: (){
                      if(formKey.currentState.validate()){
                        setState(() {
                          isLoading = true;
                        });
                        sendProject();
                        titleTEC.text="";abstarctTEC.text="";_category='';contentTEC.text="";
                        final snackBar = SnackBar(content: Text("Project uploaded!!"),backgroundColor: Colors.green,duration: Duration(milliseconds: 5000),);
                        _scaffoldKey.currentState.showSnackBar(snackBar);
                        summaryTEC.text="";
                        setState(() {
                          imageUrl="";
                        });
                      }},
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height/2.8,),
         ]
        ),
          )

          ),
        ),
    );
  }
  uploadImage()
  async {
    final _storage=FirebaseStorage.instance;
    final _picker=ImagePicker();
    PickedFile image;
    //check for permission
    await Permission.photos.request();
    var permissionStatus=await Permission.photos.status;
    if(permissionStatus.isGranted){
      //select image
      image=await _picker.getImage(source: ImageSource.gallery);
      var file=File(image.path);
      if(image!= null)
      {
        //storing image
        var snapshot=await _storage.ref().child('ProjectBank/${titleTEC.text+DateTime.now().millisecond.toString()}').putFile(file);
        var downloadurl= await snapshot.ref.getDownloadURL();
        setState(() {
          imageUrl=downloadurl;
        });
      }else{
        print("no path received");
      }
    }else{
      print("Grant Permission and try again");
    }

  }
}

