import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:impulse/Services/database.dart';
import 'package:impulse/UI/GroupSection/GroupInfoPage.dart';
import 'package:impulse/UI/search.dart';
import 'package:impulse/Widgets/widgets.dart';
import 'package:impulse/helper/constants.dart';

class GroupChatWindow extends StatefulWidget{
  final String groupName;
  GroupChatWindow(this.groupName);
  GroupChatWindowState createState()=> GroupChatWindowState();
}

class GroupChatWindowState extends State<GroupChatWindow>{

  TextEditingController messageTEC = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  String personEmail;
  Stream chatMessageStream;
  String admin="";
  String GImage="";

  Widget chatMessageList(){
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context,snapshot){
        return snapshot.hasData? ListView.builder(reverse:true,itemCount:snapshot.data.docs.length,itemBuilder: (context,index){
          return MessageTile(
              snapshot.data.docs[index].get("message"),
              snapshot.data.docs[index].get("sendBy"),
              snapshot.data.docs[index].get("sendBy")==Constants.myEmail,
              snapshot.data.docs[index].get("time"));
        }):Container();
      },);

  }

  sendMessage(){
    if ((messageTEC.text).isNotEmpty) {

      //code
      String s= messageTEC.text;
      var v="";
      for(int i=0;i<s.length;i++){
        v = v+s[i].codeUnitAt(0).toString()+"x";
      }
      // print(v);

      Map<String, dynamic> messageMap = {
        "message": v,
        "sendBy": Constants.myEmail,
        "time": DateTime.now().millisecondsSinceEpoch
      };
      databaseMethods.addGroupConversation(widget.groupName, messageMap);
    }
    setState(() {
      messageTEC.text = "";
    });
  }

  @override
  void initState() {
    databaseMethods.getGroupConversation(widget.groupName).then((value){
      if (value!=null) {
        setState(() {
          chatMessageStream = value;
        });
      }
    });
    getGroupAdmin(widget.groupName);
    super.initState();
  }

  getGroupAdmin(String groupName) async {
    var documentSnapshot = await FirebaseFirestore.instance.collection('Groups').doc('$groupName').get();
    setState(() {
      admin = documentSnapshot['Admin'];
      GImage = documentSnapshot['GPhoto'];
    });
  }
  //Delete Chat Messages
  deleteMessages(chatRoomId){
    FirebaseFirestore.instance.collection("Groups").doc("$chatRoomId").collection("chats").get().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
  }
  //exit group
  exitGroup(String groupName){
    List<String> member=["${Constants.myName}_${Constants.myEmail.split('@')[0]}"];
    FirebaseFirestore.instance.collection('Groups').doc('$groupName')
        .update({ "Members":FieldValue.arrayRemove(member) });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>GroupInfo(groupName: widget.groupName)));
            },
            child: Column(
              children: [Text("${widget.groupName}",style: TextStyle(fontSize: 20),),],)),backgroundColor: Colors.teal,
        leading: Row(children: [Spacer(),//Group Icon
            Container(child: CircleAvatar(radius:22,backgroundColor: Colors.grey.shade100,backgroundImage: NetworkImage("$GImage"),)),
          ],),
        actions: [
          //if admin then can delete chat
          (Constants.myEmail.compareTo(admin)==0)? IconButton(icon: Icon(Icons.more_vert,),    /* if */
            onPressed: (){
              showDialog(context: context,
                  builder: (BuildContext context) => alertDialogShow(context,"Delete Chat"));
            },): IconButton(onPressed: (){
            showDialog(context: context,
                builder: (BuildContext context) => alertDialogShow(context,"Exit Group"));
             }, icon: Icon(Icons.more_horiz))  /* else */

        ],),
      backgroundColor: Colors.white,
      body: Container( child: Stack(
        children: [
          Container( padding: EdgeInsets.all(7), color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container( color: Colors.white,
                    height: MediaQuery.of(context).size.height-160,
                    width: MediaQuery.of(context).size.width,
                    child: chatMessageList(),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container( padding: EdgeInsets.all(4),
                            child: TextField(
                              controller: messageTEC,
                              style: simpleTextStyle(),
                              cursorColor: Colors.teal,
                              decoration: InputDecoration(
                                hintText: 'Message...',
                                hintStyle: hintTextStyle(),
                                border: InputBorder. none,
                                focusedBorder: InputBorder. none,
                                enabledBorder: InputBorder. none,
                              ),),
                          ),
                        ),
                        IconButton(icon: Icon(Icons.send_sharp,size: 30,color: Colors.black,),
                            onPressed: (){
                              try {
                                setState(() {
                                  sendMessage();
                                });
                              } on Exception catch (e) {
                                print("Error: $e");
                              }
                            })  //send button
                      ],),
                  ),
                ],),
            ),
          ),
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
        new FlatButton(
          onPressed: () {
          (Constants.myEmail.compareTo(admin)==0)?
          deleteMessages(widget.groupName):exitGroup(widget.groupName);
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          },
          textColor: Colors.teal,
          child: const Text('Yes',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),),
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Colors.teal,
          child: const Text('No',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
        ),
      ],
    );
  }
}

class MessageTile extends StatefulWidget{

  final String message;
  final String sendersMail;
  final bool isSendByMe ;
  final int time;
  MessageTile(this.message,this.sendersMail,this.isSendByMe,this.time);

  @override
  _MessageTileState createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  String username="";

  getUsernameByEmail(String email) async {
    var ref = await FirebaseFirestore.instance.collection('Users').get();
    for(int i =0;i<ref.docs.length;i++){
      if(email.compareTo(ref.docs[i].get('Email').toString())==0){
        if(this.mounted){
          setState(() {
            username = ref.docs[i].get('Username');
          });
        }
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    //decode
    List lis = (widget.message).split("x");
    // print(lis);

    String message="";
    for(int i=0;i<lis.length-1;i++){
      message = message+String.fromCharCode(int.parse(lis[i]));
    }
    // print(message.trim());

    getUsernameByEmail(widget.sendersMail);
    var time = DateTime.fromMillisecondsSinceEpoch(widget.time).toString();
    return Container(
      //crossAxisAlignment: isSendByMe?CrossAxisAlignment.end:CrossAxisAlignment.start,

      width: MediaQuery.of(context).size.width,
      alignment: widget.isSendByMe?Alignment.centerRight:Alignment.centerLeft,

      padding: EdgeInsets.all(5),
      child:
      Column(crossAxisAlignment: widget.isSendByMe?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color:widget.isSendByMe?Colors.teal:Colors.grey.shade200,
                  borderRadius: widget.isSendByMe?BorderRadius.only(
                    topLeft:Radius.circular(17),
                    bottomLeft:Radius.circular(17),
                    topRight:Radius.circular(17),)
                      :BorderRadius.only(
                    topLeft:Radius.circular(17),
                    bottomRight:Radius.circular(17),
                    topRight:Radius.circular(17),)),
              child: widget.isSendByMe?Column(crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("$message",style: TextStyle(color: widget.isSendByMe?Colors.white:Colors.black,fontWeight: FontWeight.normal,fontSize: 19)),
                  SizedBox(height: 3,),
                  Text("${time.split('.')[0].substring(0,time.split('.')[0].substring(0).length-3)}",style: TextStyle(color: Colors.white70,fontSize: 12),),
                ],
              ):Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("$message",style: TextStyle(color: widget.isSendByMe?Colors.white:Colors.black,fontWeight: FontWeight.normal,fontSize: 19)),
                  SizedBox(height: 3,),
                  Text("${time.split('.')[0].substring(0,time.split('.')[0].substring(0).length-3)}",style: TextStyle(color: Colors.grey.shade700,fontSize: 12),),
                ],
              ),),
          Text("@${username}",style: TextStyle(color: Colors.blueGrey),),
        ],
      ),
    );
  }
}

