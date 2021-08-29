import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:impulse/Services/database.dart';
import 'package:impulse/Widgets/widgets.dart';
import 'package:impulse/helper/constants.dart';
import 'dart:math' as math;


class AddParticipants extends StatefulWidget{
  final String groupName;
  AddParticipants({this.groupName});
  @override
  _AddParticipantsState createState() =>_AddParticipantsState();
}

class _AddParticipantsState extends State<AddParticipants>{
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTEC = new TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  QuerySnapshot searchSnapshot;
  initiateSearch(){
    if(searchTEC.text.startsWith('@')){
      databaseMethods.getUserByUsername(searchTEC.text.substring(1),"Username").then((val) {
        setState(() {
          searchSnapshot = val;
        });
      });
    }else{
      databaseMethods.getUserByUsername(searchTEC.text,"Name").then((val) {
        setState(() {
          searchSnapshot = val;
        });
      });
    }
  }

  @override
  void initState() {
    initiateSearch();
    super.initState();
  }

  /*StartConversation({ String username,String userEmail}){
    String chatRoomId;
    if(username!= Constants.myEmail.split('@')[0]) {
      chatRoomId = getChatRoomId(userEmail, Constants.myEmail.split('@')[0]);
      print("chatRoomId$chatRoomId");
      List<String> users = [userEmail+"@gmail.com", Constants.myEmail];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatRoomId": chatRoomId
      };
      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Chat_Window(chatRoomId)));
      //
      chatUserName = username;  //global
      chatUserEmail = userEmail;  //global

    }
  }*/
  sendRequest({ String username,String userEmail}) async {
    var ref = await FirebaseFirestore.instance.collection('Groups').doc(widget.groupName).get();
    var mem=ref.get("Members").toString().replaceAll('[',"").replaceAll(']','').split(',');
    int len=ref.get("Members").toString().replaceAll('[',"").replaceAll(']','').split(',').length;
    List<String> member=[];
    for(int i=0;i<len;i++){
      member.add(mem[i].trim());
    }
    if(member.toString().contains("${username}_${userEmail.split('@')[0]}")){
      final snackBar = SnackBar(content: Text("Already a group member!!"),backgroundColor: Colors.red,duration: Duration(milliseconds: 4000),);
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }else{
      member.add("${username}_${userEmail.split('@')[0]}");
      final snackBar = SnackBar(content: Text("Member added in group!!"),backgroundColor: Colors.green,duration: Duration(milliseconds: 4000),);
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
    Map<String,dynamic> addNewMembers = {"GName":"${widget.groupName}","Members":member};
    await FirebaseFirestore.instance.collection('Groups').doc('${widget.groupName}').update(addNewMembers);
  }

  Widget searchList(){
    return searchSnapshot!= null?ListView.builder(
        itemCount: searchSnapshot.docs.length,
        shrinkWrap: true,
        itemBuilder: (context,index){
          bool val=true;
          searchSnapshot.docs[index]["Email"].toString()==Constants.myEmail?val=false:val=true;
          return  val?SearchTile( name:  searchSnapshot.docs[index]["Name"],
              username: searchSnapshot.docs[index]["Username"],email: searchSnapshot.docs[index]["Email"]):Container();
        }):Container();
  }

  Widget SearchTile({String name, String username,String email}){
    return Container(padding: EdgeInsets.all(15),
      decoration: BoxDecoration(border: Border.all(color: Colors.white,style: BorderStyle.solid,width: 1.2),color: Colors.grey.shade100),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,style: TextStyle(color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),),
              Text("@$username",style: TextStyle(color: Colors.black,
                  fontSize: 19,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal),)
            ],),
          Spacer(),
          GestureDetector(
            onTap: (){
              sendRequest(username: name,userEmail: email.split('@')[0]);
            },
            child: Container(alignment: Alignment.center,
              decoration: BoxDecoration(color: Colors.blueGrey.shade100,
                  borderRadius: BorderRadius.circular(30.0)),
              padding: EdgeInsets.symmetric(horizontal: 8.0,vertical: 8.0),
              child: Icon(Icons.person_add_alt_1_rounded,color: Colors.black,),
            ),
          ),
        ],),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBarMain(context),
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white24,
        child: Column(
          children: [
            Row(children: [
              Expanded(
                child:
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: searchTEC,
                    style: simpleTextStyle(),
                    decoration: InputDecoration(
                      hintText: 'search',
                      hintStyle: hintTextStyle(),
                      suffixIcon: GestureDetector(
                        onTap: (){
                          initiateSearch();
                        },
                        child: Icon(Icons.search_rounded,size: 30,),),
                    ),),
                ),
              ),
            ],),
            searchList(),
          ],),
      ),);
  }
}


getChatRoomId(String a, String b){
  if(a.compareTo(b)<0){
    return "$a\_$b";
  }
  else{
    return "$b\_$a";
  }
}

