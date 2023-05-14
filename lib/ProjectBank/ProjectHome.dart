import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:impulse/Services/database.dart';
import 'package:impulse/UI/GroupSection/ConversationScreen.dart';
import 'package:impulse/UI/QnASection/UnansweredQuestion.dart';
import 'package:impulse/helper/constants.dart';
class ProjectPage extends StatefulWidget {
  final int index;
  ProjectPage(this.index);
  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  List<String> title = new List<String>();
  List<String> category = new List<String>();
  List<String> abstract = new List<String>();
  List<String> images = new List<String>();
  List<String> summary = new List<String>();
  List<String> content=new List<String>();
  List<String> name=new List<String>();
  List<String> email=new List<String>();

  @override
  void initState() {
    getProjects();
    super.initState();
  }

  getProjects() async {
    var n = await FirebaseFirestore.instance.collection("ProjectBank").orderBy("date",descending: true).get();
    setState(() {
      for (int i = 0; i < ((n.docs.length>40)?40:(n.docs.length)); i++) {
        String a = n.docs[i].get('title').toString();
        title.add(a);
        String b = n.docs[i].get('category').toString();
        category.add(b);
        String c = n.docs[i].get('abstract').toString();
        abstract.add(c);
        String d = n.docs[i].get('image').toString();
        images.add(d);
        String e = n.docs[i].get('summary').toString();
        summary.add(e);
        String f = n.docs[i].get('content').toString();
        content.add(f);
        String g = n.docs[i].get('name').toString();
        name.add(g);
        String h = n.docs[i].get('email').toString();
        email.add(h);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Project"),),
       body:Padding(
         padding: const EdgeInsets.symmetric(horizontal: 8.0),
         child: SingleChildScrollView(
           child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.center,
             children: [
               SizedBox(height: 20,),
               Text("${(widget.index!=null)?title[widget.index]:""}",
                 style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold),),
               SizedBox(height: 15,),
               Text("${(widget.index!=null)?summary[widget.index]:""}",
                 style: TextStyle(fontSize: 16,color: Colors.black,)),
               SizedBox(height: 20,),
               Text("Project Abstract:",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
               SizedBox(height: 20,),
               Text("${(widget.index!=null)?abstract[widget.index]:""}",
                 style: TextStyle(fontSize: 16,color: Colors.blueGrey.shade700),),
               SizedBox(height:20),
           images[widget.index]!=""?GestureDetector(onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>PhotoView(qImage: images[widget.index],)));},
                 child: Container(width: MediaQuery.of(context).size.width-8,height: MediaQuery.of(context).size.width,
                     child: Image.network(images[widget.index],fit: BoxFit.cover,)),
               ):Text(""),
               SizedBox(height: 20,),
               Text("Contents of Project:",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
               SizedBox(height: 20,),
               Text("${(widget.index!=null)?content[widget.index]:""}",
                 style: TextStyle(fontSize: 16,color: Colors.blueGrey.shade700),),
               SizedBox(height: 20,),
             ],
           ),
         ),
       ),
      floatingActionButton: FloatingActionButton(
    child: Icon(Icons.mail),
    backgroundColor:Colors.teal,
    onPressed: (){
    StartConversation(username: name[widget.index],userEmail: email[widget.index].split('@')[0]);
    }),
    );
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
      Navigator.push(context, MaterialPageRoute(builder: (context) => Chat_Window(chatRoomId)));

      // chatUserName = username;  //global
      // chatUserEmail = userEmail;  //global
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

}
