import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:impulse/Services/auth.dart';
import 'package:impulse/Services/database.dart';
import 'package:impulse/UI/search.dart';
import 'package:impulse/helper/constants.dart';
import 'package:impulse/helper/helperFunctions.dart';

import 'ConversationScreen.dart';

class Chat_Screen extends StatefulWidget{
  @override
  State<Chat_Screen> createState() => ChatState();
}

class ChatState extends State<Chat_Screen>{
  AuthMethod authMethod = new AuthMethod();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  String mail ;
  Stream chatRoomStream;

  Widget chatRoomList(){
    return StreamBuilder(stream: chatRoomStream,builder: (context,snapshot){
      return snapshot.hasData?ListView.builder(
          itemCount:snapshot.data.docs.length,
          itemBuilder: (context,index){
            String email=snapshot.data.docs[index].get('chatRoomId').toString().replaceAll(mail.split('@')[0], "").replaceAll("_", "")+"@gmail.com";
            //getUsernameByEmail(email);
            //print(email);
            return ChatRoomsTile(email, snapshot.data.docs[index].get("chatRoomId"));
          }):Container();
    });
  }


  @override
  void initState() {
  getUserInfo();
  super.initState();
  }

  getUserInfo() async{
    //print("${await HelperFunction.getUserEmailSharedPreference()}");
    Constants.myEmail = await HelperFunction.getUserEmailSharedPreference();
    //Constants.myName = await HelperFunction.getUserNameSharedPreference();
    databaseMethods.getChatRooms(Constants.myEmail).then((value){
      setState(() {
        chatRoomStream = value;
        print("$chatRoomStream");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    HelperFunction.getUserEmailSharedPreference().then((value) => {mail=value});
    //print(mail);
    return Scaffold(
      appBar: AppBar(title: Text('Chats',style: TextStyle(color: Colors.white),),
        /*actions: [
          GestureDetector(
            onTap: (){
              authMethod.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Authenticate()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.0),
                child: Icon(Icons.logout)
            ),
          ),
        IconButton(icon: Icon(Icons.file_upload), onPressed: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ImgUpload()));
        })]*/),
      backgroundColor: Colors.white,
      body: chatRoomList(),

      floatingActionButton: FloatingActionButton(child: Icon(Icons.add_rounded,size: 29,),
        onPressed: (){
        Navigator.push(context,MaterialPageRoute(builder: (context)=> SearchScreen()));
        },),
      
    );
  }
}


class ChatRoomsTile extends StatefulWidget{
  // final String userName;
  // final String name;
  final String email;
  final String chatRoomId;
  ChatRoomsTile(this.email,this.chatRoomId);

  @override
  _ChatRoomsTileState createState() => _ChatRoomsTileState();
}

class _ChatRoomsTileState extends State<ChatRoomsTile> {
  String tileImageUrl="";

  String username="";
  String name="";

//get user_name
  getUsernameByEmail(String email) async {
    var ref = await FirebaseFirestore.instance.collection('Users').get();
    for(int i =0;i<ref.docs.length;i++){
      if(email.compareTo(ref.docs[i].get('Email').toString())==0){
        if (this.mounted) {
          setState(() {
            username = ref.docs[i].get('Username');
            name = ref.docs[i].get('Name');
          });
        }
        break;
      }
    }
  }

  getImageURL() async {
    int index=0;
    var ref= await FirebaseFirestore.instance.collection("Users").get();

    for(int i =0;i<ref.docs.length;i++){
      if(ref.docs[i].get('Email').toString().contains(widget.email)){
        index=i;
        break;
      }
    }
    setState(() {
      tileImageUrl=ref.docs[index].get("ImageURL");
    });
  }

  @override
  Widget build(BuildContext context) {
    getImageURL();
    getUsernameByEmail(widget.email);
    return Column(
      children: [
        GestureDetector(
          onTap: (){
            Navigator.push(context,MaterialPageRoute(builder: (context)=> Chat_Window(widget.chatRoomId)));
          },
          child: Container(padding: EdgeInsets.symmetric(horizontal: 15,vertical: 12),
            color: Colors.grey.shade50,
            child: Row(children: [
              Container(child: CircleAvatar(
                backgroundColor: Colors.teal,
                backgroundImage: (tileImageUrl==null||tileImageUrl=="")?null:NetworkImage(tileImageUrl),
                radius: 27,
                child: (tileImageUrl==null||tileImageUrl=="")?Text("${username.substring(0,1).toUpperCase()}",//userName.substring(0,1).toUpperCase()
                  style: TextStyle(color: Colors.white,fontSize: 24),):null,/*
                  Text("${username.substring(0,1).toUpperCase()}",//userName.substring(0,1).toUpperCase()
                    style: TextStyle(color: Colors.white,fontSize: 20),)*/
              ),),
              SizedBox(width: 8,),
              Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${name}",style: TextStyle(color: Colors.black87,fontSize: 21,fontWeight: FontWeight.bold),),
                  Text("@${username}",style: TextStyle(color: Colors.blueGrey,fontSize: 21,fontWeight: FontWeight.normal),),
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

//get user's name
getNameByEmail(String email) async {
  var ref = await FirebaseFirestore.instance.collection('Users').get();
  for(int i =0;i<ref.docs.length;i++){
    if(email.compareTo(ref.docs[i].get('Email').toString())==0){
      return ref.docs[i].get('Name');
    }
  }
}
*/
