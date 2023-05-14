import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:impulse/Services/database.dart';
import 'package:impulse/Widgets/widgets.dart';
import 'package:impulse/helper/constants.dart';

import 'groupChatWindow.dart';


class CreateGroup extends StatefulWidget{
  @override
  CreateGroupState createState() =>CreateGroupState();
}

class CreateGroupState extends State<CreateGroup>{
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTEC = new TextEditingController();
  TextEditingController gNameTEC = new TextEditingController();
  TextEditingController categoryTEC = new TextEditingController();
  TextEditingController adminNameTEC = new TextEditingController();

  bool nameTaken= false;
  bool isLoading = false;

  final formKey =GlobalKey<FormState>();
  QuerySnapshot searchSnapshot;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> memberMails = [];

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
    if(username!= Constants.myEmail.split('@')[0]) {
      print("chatRoomId${gNameTEC.text}");
      List<String> users = [];
      for(int i=0; i<memberMails.length;i++){
          users.add(memberMails[i]);
       }
      users.add("${Constants.myName}"+"_"+"${Constants.myEmail.split('@')[0]}");
      Map<String,dynamic> chatRoomMap={
        "GName": gNameTEC.text,
        "Category": categoryTEC.text,
        "Admin": Constants.myEmail,
        "GPhoto": "",
        "Members": users,
        "Report":[]
      };
      DatabaseMethods().createGroupChatRoom(gNameTEC.text.trim(), chatRoomMap);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => GroupChatWindow(gNameTEC.text.trim())));
    }
  }

  Widget searchList(){
    return searchSnapshot!= null?ListView.builder(
        itemCount: searchSnapshot.docs.length,
        shrinkWrap: true,
        itemBuilder: (context,index){
          bool val=true;
          searchSnapshot.docs[index]["Email"].toString()==Constants.myEmail?val=false:val=true;
          return  val?SearchTile( username:  searchSnapshot.docs[index]["Name"],
            userEmail: searchSnapshot.docs[index]["Username"],):Container();
        }):Container();
  }

  Widget SearchTile({String username, String userEmail}){
    return Container(padding: EdgeInsets.all(15),
      decoration: BoxDecoration(border: Border.all(color: Colors.white,style: BorderStyle.solid,width: 1.2),color: Colors.grey.shade100),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(username,style: TextStyle(color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),),
              Text("@$userEmail",style: TextStyle(color: Colors.black,
                  fontSize: 19,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal),)
            ],),
          Spacer(),
          IconButton(onPressed: (){
            setState(() {
              if(memberMails.contains("$username" + "_" + "$userEmail")!=true){
                memberMails.add("$username" + "_" + "$userEmail");
              }
              print("$memberMails");
            });
          },
              icon: Icon(Icons.add_box,size: 32,)),
        ],),
    );
  }

  checkGroupName() async {
    nameTaken=false;
    var n = await FirebaseFirestore.instance.collection("Groups").get();
    for(int i =0;i<n.docs.length;i++){
      if(gNameTEC.text.contains(n.docs[i].id)){
        nameTaken=true;
        break;
      }else{
        print("fornameTaken$nameTaken");
        nameTaken=false;
      }
    }
    if(nameTaken==true){
      print("ifnameTaken$nameTaken");
      final snackBar = SnackBar(content: Text("Group Name Taken. Try another name!!"),backgroundColor: Colors.redAccent,duration: Duration(milliseconds: 5000),);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }else{
      nameTaken=false;
      StartConversation();
    }// print("n ${n.docs[0].id}");
  }

  Widget GroupList(){
    return ListView.builder(itemCount: memberMails.length,
        shrinkWrap: true,
        itemBuilder: (context,index){
          return Container(
            child: Card(
              child: Container(padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Column(
                      children: [
                        Text("${memberMails[index].split('_')[0]}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 19),),
                        Text("@${memberMails[index].split('_')[1]}",style: TextStyle(fontWeight: FontWeight.normal,fontSize: 18)),
                      ],
                    ),
                    Spacer(),
                    GestureDetector(onTap:(){
                      setState(() {
                        memberMails.remove(memberMails[index]);
                      });
                    },
                        child: Text("Remove",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: Colors.blueAccent)))
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text("Create Group"),),
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white24,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height:30),
                    Text("Group Admin: @${Constants.username}", style:TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.normal)),
                    // SizedBox(height: 30,),
                    TextFormField(
                      controller: gNameTEC,
                      validator: (val){return gNameTEC.text.isNotEmpty?null:"Required";},
                      decoration: const InputDecoration(icon:const Icon(Icons.group_rounded),
                        hintText: "Enter Group Name",
                        labelText:'Group Name',
                      ),
                    ),
                    SizedBox(height:20),
                    TextFormField(
                      controller: categoryTEC,
                      validator: (val){
                        return categoryTEC.text.isNotEmpty?null:"Required";
                      },
                      decoration: const InputDecoration(
                        icon:const Icon(Icons.category),
                        hintText: "Enter Group Category",
                        labelText:'Category',
                      ),
                    ),
                    SizedBox(height:30),
                  ],),
              ),
              Divider(),
              Column(
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
                            hintText: 'Search by Name',
                            labelText: 'Add Group Members',
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
              SizedBox(height: 10,),
              Center(
                child: Container(
                  color: Colors.blueAccent,
                  height: 50,
                  child: TextButton(

                    child: Text("Create Group",style:TextStyle(color:Colors.white,fontSize: 15)),
                    onPressed: (){
                      if(formKey.currentState.validate()){
                        setState(() {
                          isLoading = true;
                          checkGroupName();
                          print("scaffnameTaken$nameTaken");
                          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AddMembers()));
                        });

                        //nameTEC.text="";emailTEC.text="";subjectTEC.text="";messageTEC.text="";
                        // final snackBar = SnackBar(content: Text("Mail Sent!!"),backgroundColor: Colors.redAccent,duration: Duration(milliseconds: 5000),);
                        // _scaffoldKey.currentState.showSnackBar(snackBar);
                      }},
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Divider(),
              Text("Group Members",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueGrey,fontSize: 18),),
              Divider(),
              GroupList(),
              SizedBox(height: 50,)
            ],
          ),
        ),
      ),);
  }
}



