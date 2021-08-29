import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:impulse/Services/database.dart';
import 'package:impulse/Widgets/widgets.dart';
import 'package:impulse/helper/constants.dart';
import 'dart:math' as math;
import 'GroupSection/ConversationScreen.dart';


class SearchScreen extends StatefulWidget{
  @override
  _SearchScreenState createState() =>_SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>{
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTEC = new TextEditingController();

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

  StartConversation({ String username,String userEmail}){
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
              StartConversation(username: name,userEmail: email.split('@')[0]);
            },
            child: Container(alignment: Alignment.center,
              decoration: BoxDecoration(color: Colors.blueGrey.shade100,
                  borderRadius: BorderRadius.circular(30.0)),
              padding: EdgeInsets.symmetric(horizontal: 8.0,vertical: 8.0),
              child: Transform.rotate(
                angle: 325 * math.pi / 180,
                child:Icon(Icons.send_rounded,color: Colors.black,),),
            ),
          ),
        ],),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search User"),),
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

