import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:impulse/Services/auth.dart';
import 'package:impulse/Services/database.dart';
import 'package:impulse/UI/GroupSection/groupChatWindow.dart';
import 'package:impulse/UI/GroupSection/searchGroups.dart';
import 'package:impulse/helper/constants.dart';

import 'ChatRooms.dart';
import 'CreateGroup.dart';

class GroupChatRooms extends StatefulWidget{
  @override
  State<GroupChatRooms> createState() => GroupChatRoomsState();
}

class GroupChatRoomsState extends State<GroupChatRooms>{
  AuthMethod authMethod = new AuthMethod();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream chatRoomStream;

  Widget chatRoomList(){
    return StreamBuilder(stream: chatRoomStream,builder: (context,snapshot){
      return snapshot.hasData?ListView.builder(
          itemCount:snapshot.data.docs.length,
          itemBuilder: (context,index){
            return ChatRoomsTile(snapshot.data.docs[index].get('GName').toString()
                ,snapshot.data.docs[index].get("Category"));
          }):Container();
    });
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async{
    print(Constants.myName);
    databaseMethods.getGroupChatRooms("${Constants.myName}"+"_"+"${Constants.myEmail.split('@')[0]}").then((value){
      setState(() {
        chatRoomStream = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Groups',style: TextStyle(color: Colors.white),),backgroundColor: Colors.teal,
          actions: [
            Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Chat_Screen()));},
              icon: Icon(Icons.messenger),)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(onPressed: (){
                Navigator.push(context,MaterialPageRoute(builder: (context)=>CreateGroup()));
                }, icon: Icon(Icons.group_add_rounded,size: 30,)),
            )
          ]),
      backgroundColor: Colors.white,
      body: chatRoomList(),

      floatingActionButton: FloatingActionButton(child: Icon(Icons.add_rounded,size: 29,),
        onPressed: (){
          Navigator.push(context,MaterialPageRoute(builder: (context)=> SearchGroups()));
        },),

    );
  }
}

class ChatRoomsTile extends StatefulWidget{
  final String GName;
  final String category;
  ChatRoomsTile(this.GName,this.category);

  @override
  _ChatRoomsTileState createState() => _ChatRoomsTileState();
}

class _ChatRoomsTileState extends State<ChatRoomsTile> {
  String GImage="";

  getGroupIcon(String groupName) async {
    var documentSnapshot = await FirebaseFirestore.instance.collection('Groups').doc('$groupName').get();
    if(this.mounted){
      setState(() {
        GImage = documentSnapshot['GPhoto'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    getGroupIcon(widget.GName);
    return Column(
      children: [
        GestureDetector(
          onTap: (){
            Navigator.push(context,MaterialPageRoute(builder: (context)=> GroupChatWindow(widget.GName)));
          },
          child: Container(padding: EdgeInsets.symmetric(horizontal: 15,vertical: 12),
            color: Colors.grey.shade50,
            child: Row(children: [
              Container(child: CircleAvatar(
                backgroundColor: Colors.teal,
                backgroundImage: NetworkImage("$GImage"),
                radius: 25,
                child: GImage==""?Text("${widget.GName.substring(0,1).toUpperCase()}",//userName.substring(0,1).toUpperCase()
                  style: TextStyle(color: Colors.white,fontSize: 20),):null,
              ),),
              SizedBox(width: 8,),
              Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${widget.GName}",style: TextStyle(color: Colors.black87,fontSize: 21,fontWeight: FontWeight.bold),),
                  Text("${widget.category.trim()}",style: TextStyle(color: Colors.black54,fontSize: 20,fontWeight: FontWeight.normal),),
                ],
              )
            ],),
          ),
        ),
        Container(color: Colors.grey.shade200,height: 1,)
      ],
    );
  }
}

/*

class GroupPage extends StatefulWidget{
  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Groups"),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: IconButton(onPressed: (){
            Navigator.push(context,MaterialPageRoute(builder: (context)=>CreateGroup()));
            }, icon: Icon(Icons.group_add_rounded,size: 30,)),
        )
      ],),
      backgroundColor: Colors.white,
      body: Container(),
    );
  }
}*/
