import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:impulse/Widgets/widgets.dart';
import 'package:impulse/helper/constants.dart';
import 'package:impulse/main.dart';
import 'package:permission_handler/permission_handler.dart';
import '../SignUp.dart';
import '../dashboard.dart';
import '../invites.dart';
import 'dart:io' as i;

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool maleCheckedValue=true;
  bool femaleCheckedValue=false;

  TextEditingController nameTEC = new TextEditingController();
  TextEditingController usernameTEC = new TextEditingController();
  // TextEditingController streamTEC = new TextEditingController();
  TextEditingController cityTEC = new TextEditingController();
  TextEditingController countryTEC = new TextEditingController();
  TextEditingController descriptionTEC = new TextEditingController();
  //String imageURL ="";
  bool isLoading = false;

  final formKey =GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String u_name="";
  bool checkedScience=false;
  bool checkedQuantitative=false;
  bool checkedReasoning=false;
  bool checkedMaths=false;
  bool checkedComputer=false;
  bool checkedEnglish=false;
  bool checkedSst=false;
  List<dynamic> interest=[];
  @override
  void initState() {
    getProfileData();
    // checkAllInterest();
    super.initState();
  }
  getProfileData() async {
    String docId="";
    var n = await FirebaseFirestore.instance.collection("Users").get();
    for(int i=0;i<n.docs.length;i++){
      if("${Constants.myEmail}".contains(n.docs[i].get('Email'))){
        docId=n.docs[i].id;
        break;
      }
    }
     DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection("Users").doc("$docId").get();
    setState(() {
      nameTEC.text=documentSnapshot['Name'];
      usernameTEC.text=documentSnapshot['Username'];
      u_name=documentSnapshot['Username'];
      print(u_name);
      // streamTEC.text=documentSnapshot['Stream'];
      interest = documentSnapshot['Interest'];
      print(interest);
      cityTEC.text=documentSnapshot['Location'].toString().split('_')[0];
      countryTEC.text= documentSnapshot['Location'].toString().split('_')[1];
      descriptionTEC.text=documentSnapshot['Description'];
      String gender=documentSnapshot['Gender'];
      if(gender.contains("Male")){maleCheckedValue=true;femaleCheckedValue=false;}
      else{femaleCheckedValue=true;maleCheckedValue=false;}
      Constants.imageURL= documentSnapshot['ImageURL'];

    });
    checkAllInterest();
  }

  checkAllInterest(){
    // print("ifs $interest");
    if(interest.contains("Science")){
      checkedScience=true;
    }
    if(interest.contains("Reasoning")){
      checkedReasoning=true;
    }
    if(interest.contains("Computer")){
      checkedComputer=true;
    }
    if(interest.contains("English")){
      checkedEnglish=true;
    }
    if(interest.contains("Quantitative Aptitude")){
      checkedQuantitative=true;
    }
    if(interest.contains("Mathematics")){
      checkedMaths=true;
    }
    if(interest.contains("Social Science")){
      checkedSst=true;
    }
  }

  updateProfile() async {
    String gender = maleCheckedValue?"Male":"Female";
    Map<String,dynamic> profileMap= {
      'Email':Constants.myEmail,
      "Name": nameTEC.text,
      "Username": usernameTEC.text,
      "Interest":interest,
      "Gender":gender,
      "Location": ("${cityTEC.text}"+"_"+"${countryTEC.text}"),
      "Description": descriptionTEC.text,
      "ImageURL":Constants.imageURL
    };
    String docId="";
    var n = await FirebaseFirestore.instance.collection("Users").get();
    for(int i=0;i<n.docs.length;i++){
      if("${Constants.myEmail}".contains(n.docs[i].get('Email'))){
        docId=n.docs[i].id;
        break;
      }
    }
    print("${docId}");
    var ref = await FirebaseFirestore.instance.collection("Users").doc("$docId");
    ref.update(profileMap);
    // print("$interest");
    final snackBar = SnackBar(content: Text("Changes Saved!!"),backgroundColor: Colors.green,duration: Duration(milliseconds: 5000),);
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        drawer: NavDrawer(),
        appBar: AppBar(elevation: 0, brightness: Brightness.light, backgroundColor: Colors.teal,
            title: Text('Edit > Profile',
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 19,
                  // fontWeight: FontWeight.bold,
                  // color: Colors.white
              ),),

            leading: IconButton(
              onPressed: () {
                if(formKey.currentState.validate()){
                  setState(()  {
                    isLoading = true;
                  });
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>DashboardPage()));
                }
              },
              icon: Icon(Icons.arrow_back_ios,
                size: 20,
                color: Colors.white,),

            ),
            actions: [
              /*Padding(
                padding: EdgeInsets.all(5.0),
                child: Icon(Icons.notifications,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Icon(Icons.account_circle_outlined,
                ),),*/
              Padding(
                padding: EdgeInsets.all(4.0),
                child: Column(
                    children: [
                      PopupMenuButton(
                        itemBuilder: (context) =>
                        [
                          PopupMenuItem(
                            child: InkWell(
                              child: Text("View Profile"),
                            ),
                          ),
                          PopupMenuItem(
                            child:
                            InkWell(
                              child: Text("Edit Profile"),
                                onTap: ()=>{Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => EditProfile())),}
                            ),

                          ),

                          PopupMenuItem(
                            child:
                            InkWell(
                              child: Text("Invite Friends"),
                              onTap: () =>
                              {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => InviteFriends()))
                              },
                            ),

                          ),
                          PopupMenuItem(
                            child:
                            InkWell(
                              child: Text("Logout"),
                              onTap: () =>
                              {Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => HomePage()))
                              },
                            ),

                          ),
                        ],
                      ),
                    ]),
              ),]
        ),
        body: Container(padding: EdgeInsets.symmetric(horizontal: 14,vertical: 10),
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height-1,
          width: MediaQuery.of(context).size.width-5,
          child: SingleChildScrollView(
            child: Form(key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height:20),
                  Center(child: Text("Edit Your Profile", style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.black,),)),
                  SizedBox(height: 10.0),
                  Center(child: _getAvatar()),
                  SizedBox(height:5),
                  Center(child: Text("Update you avatar ", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black,),)),
                  SizedBox(height:5),
                  // Text("Click on the avtaar to update your profile picture", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black,),),
                  SizedBox(height:10),
                  Text("Name", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black,),),
                  SizedBox(height:5),
                  TextFormField(controller: nameTEC,
                    decoration: const InputDecoration(hintText: "Enter Name", labelText:'Name',),
                      validator: (value) {
                      return value.isNotEmpty?RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$').hasMatch(value)?"Only alphabets allowed":null:"Enter Name";
                      /*if (value.isEmpty) {
                        return 'Please Enter some text';
                      }
                      return null;*/},),
                  SizedBox(height:20),
                  Text("Username", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black,),),
                  Row(crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(width: MediaQuery.of(context).size.width-100,
                        child: TextFormField(
                            validator: (val){
                              return RegExp(r"^(?=[a-zA-Z0-9._]{4,20}$)(?!.*[_.]{2})[^_.].*[^_.]$").hasMatch(val)?null:"Invalid username";
                            },
                            controller: usernameTEC,
                            style: simpleTextStyle(),
                            decoration: const InputDecoration(hintText: "Enter username", labelText:'Username',)),
                      ),
                      IconButton(onPressed: () async {
                        bool usernameTaken= await checkUsername(usernameTEC.text);
                        if(usernameTaken==false||u_name.compareTo(usernameTEC.text)==0) {
                          final snackBar = SnackBar(content: Text("Username available!!"),backgroundColor: Colors.green,duration: Duration(milliseconds: 2500),);
                          _scaffoldKey.currentState.showSnackBar(snackBar);
                        }else{
                          print("$u_name ${u_name.compareTo(usernameTEC.text)==0}");
                          final snackBar = SnackBar(content: Text("Username not available!!"),backgroundColor: Colors.redAccent,duration: Duration(milliseconds: 2500),);
                          _scaffoldKey.currentState.showSnackBar(snackBar);
                        }
                      }, icon: Icon(Icons.check_circle,size: 28,color: Colors.teal,))
                    ],
                  ),
                  SizedBox(height: 20,),
                  Text("Interests", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black,),),
                  // TextFormField(controller: streamTEC,decoration: const InputDecoration(hintText: "Enter stream", labelText:'Stream',),),
                  // SizedBox(height: 20,),
                  SingleChildScrollView(scrollDirection: Axis.horizontal,
                    child: Row(crossAxisAlignment:CrossAxisAlignment.start,
                      children: [
                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Checkbox(value: checkedScience, onChanged: (val){
                                  setState(() {
                                    if(checkedScience==false) {
                                        checkedScience = true;
                                        interest.add("Science");
                                      }else{
                                      checkedScience = false;
                                        interest.remove("Science");
                                      }
                                    });
                                },),Text("Science",style: TextStyle(fontWeight:FontWeight.normal,color: Colors.black,fontSize: 17)),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(value: checkedReasoning, onChanged: (val){
                                  setState(() {
                                    if(checkedReasoning==false) {
                                      checkedReasoning = true;
                                      interest.add("Reasoning");
                                    }else{
                                      checkedReasoning = false;
                                      interest.remove("Reasoning");
                                    }
                                  });
                                },),Text("Reasoning",style: TextStyle(fontWeight:FontWeight.normal,color: Colors.black,fontSize: 17)),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(value: checkedComputer, onChanged: (val){
                                  setState(() {
                                    if(checkedComputer==false) {
                                      checkedComputer = true;
                                      interest.add("Computer");
                                    }else{
                                      checkedComputer = false;
                                      interest.remove("Computer");
                                    }
                                  });
                                },),Text("Computer",style: TextStyle(fontWeight:FontWeight.normal,color: Colors.black,fontSize: 17)),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(value: checkedEnglish, onChanged: (val){
                                  setState(() {
                                    if(checkedEnglish==false) {
                                      checkedEnglish = true;
                                      interest.add("English");
                                    }else{
                                      checkedEnglish = false;
                                      interest.remove("English");
                                    }
                                  });
                                },),Text("English",style: TextStyle(fontWeight:FontWeight.normal,color: Colors.black,fontSize: 17)),
                              ],
                            ),
                          ],),
                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Checkbox(value: checkedQuantitative, onChanged: (val){
                                  setState(() {
                                    if(checkedQuantitative==false) {
                                      checkedQuantitative = true;
                                      interest.add("Quantitative Aptitude");
                                    }else{
                                      checkedQuantitative = false;
                                      interest.remove("Quantitative Aptitude");
                                    }
                                  });
                                },),Text("Quantitative Aptitude",style: TextStyle(fontWeight:FontWeight.normal,color: Colors.black,fontSize: 17)),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(value: checkedMaths, onChanged: (val){
                                  setState(() {
                                    if(checkedMaths==false) {
                                      checkedMaths = true;
                                      interest.add("Mathematics");
                                    }else{
                                      checkedMaths = false;
                                      interest.remove("Mathematics");
                                    }
                                  });
                                },),Text("Mathematics",style: TextStyle(fontWeight:FontWeight.normal,color: Colors.black,fontSize: 17)),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(value: checkedSst, onChanged: (val){
                                  setState(() {
                                    if(checkedSst==false) {
                                      checkedSst = true;
                                      interest.add("Social Science");
                                    }else{
                                      checkedSst = false;
                                      interest.remove("Social Science");
                                      // print(interest);
                                    }
                                  });
                                },),Text("Social Science",style: TextStyle(fontWeight:FontWeight.normal,color: Colors.black,fontSize: 17)),
                              ],
                            )
                          ],),
                      ],),
                  ),
                  SizedBox(height:20),
                  Text("Gender", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black,),),
                  Row(children: [
                    Checkbox(onChanged:(val){
                    setState(() {
                      maleCheckedValue=!maleCheckedValue;
                    if(maleCheckedValue){femaleCheckedValue=false;}else{femaleCheckedValue=true;}
                    });
                  },value: maleCheckedValue,),
                    Text("Male  ",style: TextStyle(fontSize: 18),),
                    Checkbox(onChanged:(val){
                      setState(() {
                        femaleCheckedValue=!femaleCheckedValue;
                        if(femaleCheckedValue){maleCheckedValue=false;}else{maleCheckedValue=true;}
                      });
                    },value: femaleCheckedValue,),
                    Text("Female  ",style: TextStyle(fontSize: 18),),
                  ]),
                  SizedBox(height:10),
                  Text("Location", style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold, color: Colors.black,),),
                  Row(
                    children: [
                      Container(width:MediaQuery.of(context).size.width/2.8,
                        child: TextFormField(controller: cityTEC,
                          decoration: const InputDecoration(
                            hintText: "Enter city",
                            labelText:'City',
                          ),
                        ),
                      ),
                      SizedBox(width: 25,),
                      Container(width:MediaQuery.of(context).size.width/2.8,
                        child: TextFormField(
                              controller: countryTEC,
                          decoration: const InputDecoration(
                            hintText: "Enter country",
                            labelText:'Country',
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height:20),
                  Text("Description", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black,),),
                  SizedBox(height: 5,),
                  Container(color: Colors.grey.shade50,alignment: Alignment.topLeft,
                    child: TextFormField(controller: descriptionTEC,
                      maxLines: 6,
                      decoration: const InputDecoration(
                        hintText: "Enter short description",
                        labelText:'Description',
                      ),
                    ),
                  ),
                  SizedBox(height:10),
                  Center(
                    child: FlatButton(
                        height: 50,
                        minWidth: 120,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Text("Save Changes",style:TextStyle(color:Colors.white,fontSize: 15)),
                        color: Colors.teal,
                        onPressed: () async{
                          bool usernameTaken;
                              if(formKey.currentState.validate()){
                              setState(()  {
                              isLoading = true;
                              });
                              usernameTaken= await checkUsername(usernameTEC.text);
                              if(usernameTaken==false||u_name.compareTo(usernameTEC.text)==0) {
                                updateProfile();
                              }else{
                                final snackBar = SnackBar(content: Text("Username not available!!"),backgroundColor: Colors.redAccent,duration: Duration(milliseconds: 2500),);
                                _scaffoldKey.currentState.showSnackBar(snackBar);
                              }
                        }}
                        ,),
                  ),
                  SizedBox(height: 50,)
                ],
              ),
            ),
          ),
        )
    );
  }

  InkWell _getAvatar() {
    return InkWell(
      child: Stack(alignment: Alignment.bottomCenter,
        children: [
          Column(
            children: [
              Center(
                child: CircleAvatar(radius: 40,
                  backgroundColor: Colors.grey.shade100,
                  backgroundImage: (Constants.imageURL !="")?NetworkImage(Constants.imageURL):null,
                  child: (Constants.imageURL=="")?Icon(Icons.person,color: Colors.black87,size: 30,):null,
                ),
              ),
              SizedBox(height: 8.5,)
            ],
          ),
          Icon(Icons.edit,color: Colors.black,),
        ],
      ),
      onTap: (){
        uploadImage();
      },
    );
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
      //var file = h.File([],image.path);
      var file = i.File(image.path);
      print("xxx");
      if (image != null){
        //Upload to Firebase
        var snapshot = await _firebaseStorage.ref()
            .child('User/${Constants.myEmail.split('@')[0]}')
            .putFile(file);
        var downloadUrl = await snapshot.ref.getDownloadURL();

        setState(() {
          Constants.imageURL = downloadUrl;
          //print("IMG$Constants.imageURL");
        });
      } else {print('No Image Path Received');}
    } else {print('Permission not granted. Try Again with permission access');}
  }
}