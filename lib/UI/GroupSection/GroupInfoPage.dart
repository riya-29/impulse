import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:impulse/UI/GroupSection/AddParticipants.dart';
import 'package:impulse/helper/constants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' as i;

class GroupInfo extends StatefulWidget{
  final String groupName;
  GroupInfo({this.groupName});
  @override
  _GroupInfoState createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {

  ScrollController _scrollViewController;
  bool _showAppbar = true;
  bool isScrollingDown = false;
  List<dynamic> memberMails= [];
  String admin="";
  String GImage="";
  String username="";

  getGroupInfo() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('Groups').doc('${widget.groupName}').get();
    setState(() {
      memberMails=documentSnapshot['Members'];
      admin = documentSnapshot['Admin'];
      GImage=documentSnapshot['GPhoto'];
    });
    print(memberMails);
  }
  /*getGroupAdmin(String groupName) async {
    var documentSnapshot = await FirebaseFirestore.instance.collection('Groups').doc('$groupName').get();
    setState(() {

      print(admin);
    });
  }*/

  @override
  void initState() {
    getGroupInfo();
    _scrollViewController = new ScrollController();
    _scrollViewController.addListener(() {
      if (_scrollViewController.position.userScrollDirection == ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          _showAppbar = false;
          setState(() {});
        }
      }

      if (_scrollViewController.position.userScrollDirection == ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          _showAppbar = true;
          setState(() {});
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {

    _scrollViewController.dispose();
    _scrollViewController.removeListener(() {});
    super.dispose();
  }

  //exit group
  exitGroup(String groupName){
    List<String> member=["${Constants.myName}_${Constants.myEmail.split('@')[0]}"];
    FirebaseFirestore.instance.collection('Groups').doc('$groupName')
        .update({ "Members":FieldValue.arrayRemove(member) });
  }

  Widget alertDialogShow(BuildContext context,String message,[groupName]) {   //Pop-up Dialog
    return new AlertDialog(
      actionsPadding: EdgeInsets.symmetric(horizontal: 35),
      title: Text('$message'),
      actions: <Widget>[
        new TextButton(
          onPressed: () async {
            /*(Constants.myEmail.compareTo(admin)==0)?
            deleteMessages(widget.groupName):*/exitGroup(widget.groupName);
            if(message.compareTo("Report Group")==0){

              var ref = await FirebaseFirestore.instance.collection('Groups').doc(widget.groupName).get();
              var mem=ref.get("Report").toString().replaceAll('[',"").replaceAll(']','').split(',');
              int len=ref.get("Report").toString().replaceAll('[',"").replaceAll(']','').split(',').length;
              List<String> member=[];
              for(int i=0;i<len;i++){
                member.add(mem[i].trim());
              }
              if(member.toString().contains("${Constants.username}_${Constants.myEmail.split('@')[0]}")){

              }else{
                member.add("${Constants.username}_${Constants.myEmail.split('@')[0]}");
              }
              Map<String,dynamic> addNewMembers = {"GName":"${widget.groupName}","Report":member};
              await FirebaseFirestore.instance.collection('Groups').doc('${widget.groupName}').update(addNewMembers);
              if(member.length==200){
                await FirebaseFirestore.instance.collection('Groups').doc('${widget.groupName}').delete();
              }
            }

            Navigator.of(context).pop();
            Navigator.of(context).pop();

          },
          // textColor: Colors.teal,
          child: const Text('Yes',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),),
        new TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          // textColor: Colors.teal,
          child: const Text('No',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            AnimatedContainer(
              height: _showAppbar ? 0.0:56.0 ,
              duration: Duration(milliseconds: 200),
              child: AppBar(
                title: Text('${widget.groupName}'),
                actions: <Widget>[
                  ((admin).compareTo(Constants.myEmail)==0)?IconButton(onPressed: () async {
                    showDialog(context: context, builder:(BuildContext context) => AlertDialog(
                      actionsPadding: EdgeInsets.symmetric(horizontal: 35),
                      title: Text('Delete Group'),
                      actions: <Widget>[
                        new TextButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            await FirebaseFirestore.instance.collection('Groups').doc('${widget.groupName}').delete();
                          },
                          // textColor: Colors.teal,
                          child: const Text('Yes',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),),
                        new TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          // textColor: Colors.teal,
                          child: const Text('No',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                        ),
                      ],
                    ));

                    }, icon: Icon(Icons.delete_rounded)):
                  Text("")
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollViewController,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //add your screen content here
                    GestureDetector(
                      onTap:(){
                        // print(GImage);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ViewGroupPhoto(groupName: widget.groupName,GImage: GImage,)));
                    },
                      child: Container(height: MediaQuery.of(context).size.width,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.teal.shade50,
                        child: GImage==""?Container():Image.network('$GImage',fit: BoxFit.cover,),)
                    ),
                    SizedBox(height: 10,),
                    (admin).compareTo(Constants.myEmail)==0?GestureDetector(onTap: (){
                      showDialog(context: context,
                          builder: (BuildContext context) => AddParticipants(groupName: widget.groupName,));
                    },
                        child: Container(height: 50,
                          alignment: Alignment.centerLeft,color: Colors.white,
                          child: Row(
                            children: [
                              SizedBox(width: 10,),
                              Icon(Icons.person_add_rounded,color: Colors.red,),
                              SizedBox(width: 10,),
                              Text("Add participants",style: TextStyle(fontSize: 20,color: Colors.red,fontWeight: FontWeight.bold),),
                            ],
                          ),)):Container(),
                    Divider(),
                    Row(mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 20,),
                        Text("${memberMails.length} Group Participants",style: TextStyle(fontSize: 21,color: Colors.teal,fontWeight: FontWeight.bold),),
                        ]),
                    SizedBox(height: 10,),
                    groupList(),
                    SizedBox(height: 10,),
                    Divider(),
                    GestureDetector(onTap: (){
                      showDialog(context: context,
                          builder: (BuildContext context) => alertDialogShow(context,"Exit Group"));
                    },
                        child: Container(height: 50,
                          alignment: Alignment.centerLeft,color: Colors.white,
                          child: Row(
                            children: [
                              SizedBox(width: 10,),
                              Icon(Icons.exit_to_app,color: Colors.red,),
                              SizedBox(width: 10,),
                              Text("Exit Group",style: TextStyle(fontSize: 20,color: Colors.red,fontWeight: FontWeight.normal),),
                            ],
                          ),)),
                    SizedBox(height: 15,),
                    GestureDetector(onTap: (){
                      showDialog(context: context,
                          builder: (BuildContext context) => alertDialogShow(context,"Report Group",widget.groupName));
                    },
                        child: Container(height: 50,
                          alignment: Alignment.centerLeft,color: Colors.white,
                          child: Row(
                            children: [
                              SizedBox(width: 10,),
                              Icon(Icons.thumb_down,color: Colors.red,),
                              SizedBox(width: 10,),
                              Text("Report",style: TextStyle(fontSize: 21,color: Colors.red,fontWeight: FontWeight.normal),),
                            ],
                          ),)),
                    SizedBox(height: 60,)

                  ],),
              ),),
          ],),
      ),);

  }


  Widget groupList(){
    return Container(width: MediaQuery.of(context).size.width,alignment: Alignment.centerLeft,padding: EdgeInsets.only(left: 3,right: 60),
      child: ListView.builder(
          itemCount: memberMails.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context,index){
            return MemberTile(index: index,memberMails: memberMails,groupName: widget.groupName,admin: admin,);
          }),
    );
  }

/*
  Group(String groupName){
    List<String> member=["${Constants.myName}_${Constants.myEmail.split('@')[0]}"];
    FirebaseFirestore.instance.collection('Groups').doc('$groupName')
        .update({ "Members":FieldValue.arrayRemove(member) });
  }*/
}

class MemberTile extends StatefulWidget{
  final int index;
  final List<dynamic> memberMails;
  final String groupName;
  final String admin;
  MemberTile({this.index,this.memberMails,this.groupName,this.admin});
  @override
  _MemberTileState createState() => _MemberTileState();
}

class _MemberTileState extends State<MemberTile> {
  String username="";
  getUsernameByEmail(String email) async {
    var ref = await FirebaseFirestore.instance.collection('Users').get();
    for(int i =0;i<ref.docs.length;i++){
      if(email.compareTo(ref.docs[i].get('Email').toString())==0){
        if(this.mounted){
          setState(() {
            username = ref.docs[i].get('Username');
          });
          break;
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    getUsernameByEmail(widget.memberMails[widget.index].split('_')[1]+"@gmail.com");
    return Container(padding: EdgeInsets.all(2),
      child: Container(
        padding: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,alignment: Alignment.centerLeft,
        decoration: BoxDecoration(gradient: LinearGradient(colors:[Colors.white,Colors.white, Colors.teal.shade50],)),
        child: Row(
          children: [
            Column( crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${widget.memberMails[widget.index].split('_')[0]}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 19),),
                Text("@$username",style: TextStyle(fontWeight: FontWeight.normal,fontSize: 18)),
              ],
            ),
            Spacer(),
            GestureDetector(onTap:(){
                showDialog(context: context,
                    builder: (BuildContext context) => alertDialogShow(context,"Remove Participant"));
              },
                child: (widget.admin).compareTo(Constants.myEmail)==0?
                ((widget.memberMails[widget.index].split('_')[1]+"@gmail.com").compareTo(Constants.myEmail))==0?
                    Text(""):Text("Remove",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.blueGrey))
                    :Text("")
            )
          ],
        ),
      ),
    );
  }

  Widget alertDialogShow(BuildContext context,String message) {   //Pop-up Dialog
    return new AlertDialog(
      actionsPadding: EdgeInsets.symmetric(horizontal: 35),
      title: Text('$message'),
      actions: <Widget>[
        new TextButton(
          onPressed: () {
            List<String> member=["${widget.memberMails[widget.index]}"];
            setState(() {
            FirebaseFirestore.instance.collection('Groups').doc('${widget.groupName}')
            .update({ "Members":FieldValue.arrayRemove(member) });
            Navigator.of(context).pop();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>GroupInfo(groupName: widget.groupName,)));
          });},
          // textColor: Colors.teal,
          child: const Text('Yes',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),),
        new TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          // textColor: Colors.teal,
          child: const Text('No',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
        ),
      ],
    );
  }
}

//View Group Icon
class ViewGroupPhoto extends StatefulWidget{
  final String groupName;
  final String GImage;
  ViewGroupPhoto({this.groupName,this.GImage});
  @override
  _ViewGroupPhotoState createState() => _ViewGroupPhotoState();
}

class _ViewGroupPhotoState extends State<ViewGroupPhoto> {
  String GImage="";
  updateGPhoto() async {
    Map<String,dynamic> imageMap= {
      "Name": widget.groupName,
      "GPhoto": GImage
    };
    var ref = FirebaseFirestore.instance.collection("Groups").doc("${widget.groupName}");
    ref.update(imageMap);
    // final snackBar = SnackBar(content: Text("Changes Saved!!"),backgroundColor: Colors.green,duration: Duration(milliseconds: 5000),);
    // _scaffoldKey.currentState.showSnackBar(snackBar);
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
      if (image != null){
        //Upload to Firebase
        var snapshot = await _firebaseStorage.ref()
            .child('GroupImages/${widget.groupName}')
            .putFile(file);
        var downloadUrl = await snapshot.ref.getDownloadURL();

        setState(() {
          GImage = downloadUrl;
          //print("IMG${GImage}");
        });
      } else {print('No Image Path Received');}
    } else {print('Permission not granted. Try Again with permission access');}
  }

  @override
  void initState() {
    GImage= widget.GImage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: Text("Group Icon"),backgroundColor: Colors.transparent,
      actions: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: GestureDetector(onTap: (){
            updateGPhoto();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>GroupInfo(groupName: widget.groupName,)));
          }, child: Row(mainAxisAlignment:MainAxisAlignment.start,
                children: [
                Text("Save",style: TextStyle(color: Colors.white,fontSize: 19),),
              ],)),
        )
      ],),
      body: Center(child: GestureDetector(
        onTap: (){
          setState(() {
            uploadImage();
            updateGPhoto();
          });
        },
        child: Container(
          child: CircleAvatar(radius: MediaQuery.of(context).size.width/2,
            backgroundColor: Colors.teal.shade50,
            backgroundImage: NetworkImage(GImage),
          ),
        ),
      )),
    );
  }
}