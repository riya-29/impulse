import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:impulse/Services/database.dart';
import 'package:impulse/UI/QnASection/ViewUserProfile.dart';
import 'package:impulse/UI/search.dart';
import 'package:impulse/Widgets/widgets.dart';
import 'package:impulse/helper/constants.dart';

class Chat_Window extends StatefulWidget{
  final String chatRoomId;
  Chat_Window(this.chatRoomId);
  Chat_WindowState createState()=> Chat_WindowState();
}

class Chat_WindowState extends State<Chat_Window>{

  TextEditingController messageTEC = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  String personEmail;
  Stream chatMessageStream;

  Widget chatMessageList(){
      return StreamBuilder(
        stream: chatMessageStream,
        builder: (context,snapshot){
        return snapshot.hasData? ListView.builder(reverse:true,itemCount:snapshot.data.docs.length,itemBuilder: (context,index){
          return MessageTile(snapshot.data.docs[index].get("message"),
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
        databaseMethods.addConversation(widget.chatRoomId, messageMap);
      }
      setState(() {
      messageTEC.text = "";
    });
  }
  String username="";
  String name="";
  String ImageUrl="";
  @override
  void initState() {
        databaseMethods.getConversation(widget.chatRoomId).then((value){
        if (value!=null) {
              setState(() {
                chatMessageStream = value;
              });
        }
        });
        //get email
        String email=widget.chatRoomId.replaceAll(Constants.myEmail.split('@')[0], "").replaceAll("_", "")+"@gmail.com";
        getUsernameByEmail(email);    //gets username,name
        getImageURL(email);     //gets image url
    super.initState();
  }

  getImageURL(String email) async {
    int index=0;
    var ref= await FirebaseFirestore.instance.collection("Users").get();

    for(int i =0;i<ref.docs.length;i++){
      if(ref.docs[i].get('Email').toString().contains(email)){
        index=i;
        break;
      }
    }
    setState(() {
      ImageUrl=ref.docs[index].get("ImageURL");
    });
  }

  getUsernameByEmail(String email) async {
    var ref = await FirebaseFirestore.instance.collection('Users').get();
    for(int i =0;i<ref.docs.length;i++){
      if(email.compareTo(ref.docs[i].get('Email').toString())==0){
        setState(() {
          username = ref.docs[i].get('Username');
          name = ref.docs[i].get('Name');
        });
        break;
      }
    }
  }

  //Delete Chat Messages
  deleteMessages(chatRoomId){
    FirebaseFirestore.instance.collection("ChatRoom").doc("$chatRoomId").collection("chats").get().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //Person username you are chatting with
  personEmail = widget.chatRoomId.replaceAll(Constants.myEmail.split("@")[0],"").replaceAll("_","");
  // print("${Constants.myEmail}");
    return Scaffold(
      appBar: AppBar(title:GestureDetector(onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>UserProfile(email: personEmail+"@gmail.com",)));},
        child: Row(crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${name}",style: TextStyle(fontSize: 20),),
                Text("@${username}",style: TextStyle(fontSize: 18,color: Colors.blueGrey.shade50),),
              ],
            ),
          ],
        ),
      ),
        leading: Row(
          children: [Spacer(),
            Container(
              child: CircleAvatar(
                backgroundColor: Colors.grey.shade100,
                backgroundImage: (ImageUrl==null||ImageUrl=="")?null:NetworkImage(ImageUrl),
                radius: 23,
                child: (ImageUrl==null||ImageUrl=="")?Text("${username.substring(0,1).toUpperCase()}",//userName.substring(0,1).toUpperCase()
                  style: TextStyle(color: Colors.black87,fontSize: 25,),):null,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(icon: Icon(Icons.more_vert,),
          onPressed: (){
            showDialog(context: context,
              builder: (BuildContext context) => deleteChat(context));
            },)],),
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
  Widget deleteChat(BuildContext context) {   //Pop-up Dialog
    return new AlertDialog(
      actionsPadding: EdgeInsets.symmetric(horizontal: 35),
      title: Text('Delete Chat'),
      actions: <Widget>[
        new FlatButton(onPressed: () {deleteMessages(widget.chatRoomId);
        Navigator.of(context).pop();
          },
          textColor: Colors.teal,
          child: const Text('Yes',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),),
        new FlatButton(onPressed: () {Navigator.of(context).pop();},
          textColor: Colors.teal,
          child: const Text('No',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
        ),
      ],
    );
  }
}

class MessageTile extends StatelessWidget{

  final String message;
  final bool isSendByMe ;
  final int ttime;
  MessageTile(this.message,this.isSendByMe,this.ttime);


  @override
  Widget build(BuildContext context) {
    //decode
    List lis = message.split("x");
    print(lis);

    String msg="";
    for(int i=0;i<lis.length-1;i++){
      msg = msg+String.fromCharCode(int.parse(lis[i]));
    }
    // print(msg.trim());

    var time = DateTime.fromMillisecondsSinceEpoch(ttime).toString();
    return Container(//crossAxisAlignment: isSendByMe?CrossAxisAlignment.end:CrossAxisAlignment.start,
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe?Alignment.centerRight:Alignment.centerLeft,
      padding: EdgeInsets.all(5),
      child:
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color:isSendByMe?Colors.teal:Colors.grey.shade200,
                borderRadius: isSendByMe?BorderRadius.only(
                        topLeft:Radius.circular(17),
                        bottomLeft:Radius.circular(17),
                        topRight:Radius.circular(17),)
                    :BorderRadius.only(
                        topLeft:Radius.circular(17),
                        bottomRight:Radius.circular(17),
                        topRight:Radius.circular(17),)),
          child: isSendByMe?Column(crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("$msg",style: TextStyle(color: isSendByMe?Colors.white:Colors.black,fontWeight: FontWeight.normal,fontSize: 19)),
              SizedBox(height: 3,),
              Text("${time.split('.')[0].substring(0,time.split('.')[0].substring(0).length-3)}",style: TextStyle(color: Colors.white70,fontSize: 12),),
            ],
          ):Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("$msg",style: TextStyle(color: isSendByMe?Colors.white:Colors.black,fontWeight: FontWeight.normal,fontSize: 19)),
              SizedBox(height: 3,),
              Text("${time.split('.')[0].substring(0,time.split('.')[0].substring(0).length-3)}",style: TextStyle(color: Colors.grey.shade700,fontSize: 12),),
            ],
          ),),
    );
  }

}

