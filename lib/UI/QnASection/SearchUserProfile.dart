import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:image_picker/image_picker.dart';
import 'package:impulse/Services/database.dart';
import 'package:impulse/UI/GroupSection/ConversationScreen.dart';
import 'package:impulse/helper/constants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math' as math;
import 'dart:io' as i;
import '../dashboard.dart';
import 'AnswerPage.dart';
import 'ViewUserProfile.dart';
import 'YourQuery.dart';


class SearchUser extends StatefulWidget{
  @override
  _SearchUserState createState() =>_SearchUserState();
}

class _SearchUserState extends State<SearchUser>{
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTEC = new TextEditingController();

  List<dynamic> interest = [];
  List<String> question=[];
  List<String> qImage=[];
  List<dynamic> time=[];
  List<String> askedBy=[];

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
    //initiateSearch();
    interest.add("Post");
    getQuestions();
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
      Navigator.push(context, MaterialPageRoute(builder: (context) => Chat_Window(chatRoomId)));

      // chatUserName = username;  //global
      // chatUserEmail = userEmail;  //global
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
              username: searchSnapshot.docs[index]["Username"],
              email: searchSnapshot.docs[index]["Email"],
              url: searchSnapshot.docs[index]["ImageURL"]):Container();
        }):Container();
  }

  Widget SearchTile({String name, String username,String email,String url}){
    return Container(padding: EdgeInsets.all(15),
      decoration: BoxDecoration(border: Border.all(color: Colors.white,style: BorderStyle.solid,width: 1.2),color: Colors.grey.shade100),
      child: Row(
        children: [
          GestureDetector(
            onTap: (){/*GO TO PROFILE*/
              Navigator.push(context, MaterialPageRoute(builder: (context)=>UserProfile(email: email,)));},
            child: Container(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.blueGrey.shade100,
                    backgroundImage: NetworkImage(url),
                    child: url.length==0?Icon(Icons.person,color: Colors.black87,size: 28,):Text(""),
                  ),
                  SizedBox(width: 15,),
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
                ],
              ),
            ),
          ),
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
  bool searchOn=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>Post()));},
        child: Icon(Icons.add_box),),
      appBar: AppBar(
        title: Container(alignment: Alignment.topLeft,
          child: TextField(
            controller: searchTEC,
            style: TextStyle(color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.normal
            ),
            cursorColor: Colors.white,
            decoration: InputDecoration(
              hintText: 'Search',
              hintStyle: TextStyle(color: Colors.white60,fontSize: 17),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal,width: 1.8)),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              suffixIcon: GestureDetector(
                onTap: (){
                  searchOn=true;
                  initiateSearch();
                },
                child: Icon(Icons.search_rounded,size: 25,color: Colors.white,),),
            ),),
        ),
        backgroundColor: Colors.teal,),
      backgroundColor: Colors.white,
      bottomNavigationBar: homeBottomNavigationBar(context),
      drawer: NavDrawer(),
      body: Container(
        color: Colors.white24,
        child: Column(
          children: [
            searchOn?searchList():
            unansweredList(),
          ],),
      ),);

  }


  getQuestions() async {
    int len;
    var ref = await FirebaseFirestore.instance.collection('AskedQuestions').orderBy("Time",descending: true).get();
    len = ref.docs.length;
    DateTime now = DateTime.now();
    for(int i=0;i<len;i++) {
      for(int j =0;j<interest.length;j++){
        DateTime date = DateTime.parse((ref.docs[i].get('Time')).toString());
        // print(DateTime(date.year, date.month, date.day).difference(DateTime(now.year, now.month, now.day)).inDays);
        if ( (ref.docs[i].get('Subject').toString().contains(interest[j].toString()))
            && (ref.docs[i].get('Unanswered').toString().compareTo('false')==0)
            && (DateTime(date.year, date.month, date.day).difference(DateTime(now.year, now.month, now.day)).inDays)>=-7) {
          String a = ref.docs[i].get('Question');
          String b = ref.docs[i].get('QImage');
          var c = ref.docs[i].get('Time');
          String d = ref.docs[i].get('AskedBy');
          setState(() {
            question.add(a);
            qImage.add(b);
            time.add(c);
            askedBy.add(d);
          });
        }
      }
    }
  }

  unansweredList() {
    return Container(
      child: Expanded(
        child: ListView.builder(itemCount: askedBy.length,itemBuilder: (context,index){
          return PostTile(time: time[index],question: question[index],qImage: qImage[index],email: askedBy[index],);
        }),
      ),
    );
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


//View POST FEED


class PostTile extends StatefulWidget{
  final String time;
  final String question;
  final String qImage;
  final String email;
  PostTile({this.time,this.question,this.qImage,this.email});
  @override
  PostTileState createState() => PostTileState();
}

class PostTileState extends State<PostTile> {
  String u_name="";
  String u_username="";
  String u_image="";
  getProfileData(String email) async {
    String docId="";
    var n = await FirebaseFirestore.instance.collection("Users").get();
    for(int i=0;i<n.docs.length;i++){
      if("$email".compareTo(n.docs[i].get('Email'))==0){
        docId=n.docs[i].id;
        break;
      }
    }
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection("Users").doc("$docId").get();
    if (this.mounted) {
      setState(() {
        u_name=documentSnapshot['Name'];
        u_username=documentSnapshot['Username'];
        u_image= documentSnapshot['ImageURL'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    getProfileData(widget.email);
    return GestureDetector(
      onLongPress: (){
        if (Constants.myEmail.compareTo(widget.email)==0) {
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text('Delete Post'),
                actions: <Widget>[
                  new FlatButton(
                    onPressed: () {
                      FirebaseFirestore.instance.collection("AskedQuestions").where("Question",isEqualTo: widget.question).where("QImage",isEqualTo:widget.qImage).get().then((snapshot) {
                        for (DocumentSnapshot doc in snapshot.docs) {
                          doc.reference.delete();
                        }
                      });
                      //delete post;
                      Navigator.of(context).pop();

                    },
                    textColor: Colors.teal,
                    child: const Text('Yes',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),),
                  new FlatButton(
                    onPressed: () {Navigator.of(context).pop();},
                    textColor: Colors.teal,
                    child: const Text('No',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                  ),
                ],
              )
          );
        }
      },
      child: Card(
        child: Container( padding: EdgeInsets.symmetric(vertical: 3),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment:MainAxisAlignment.end,children: [Text("${widget.time.split('.')[0].substring(0,widget.time.split('.')[0].length-3)}",style: TextStyle(color: Colors.grey,fontSize: 14)),SizedBox(width: 15,)],),
              Row(children: [
                SizedBox(width: 3,),
                GestureDetector(onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>UserProfile(email: widget.email)));
                },child: CircleAvatar(backgroundColor:Colors.grey.shade50,
                  backgroundImage: u_image.isNotEmpty?NetworkImage(u_image):null,
                  child: u_image.isEmpty?Icon(Icons.person,color: Colors.black87,size: 22,):null,
                )
                ),
                SizedBox(width: 10,),
                Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                  Text("$u_name",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold)),
                  Text("@$u_username",style: TextStyle(color: Colors.blueGrey,fontSize: 15,)),
                ],),
              ],),
              SizedBox(height: 5,),
              Text("${widget.question}"),
              SizedBox(height: 5,),
              GestureDetector(onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>PhotoView(qImage: widget.qImage)));},
                child: Container(width:widget.qImage.isNotEmpty?MediaQuery.of(context).size.width-5:0,
                  height: widget.qImage.isNotEmpty?MediaQuery.of(context).size.width-5:0,
                  child: widget.qImage.isNotEmpty?Image.network("${widget.qImage}",fit: BoxFit.cover,):Container(),),
              ),
              Row(mainAxisAlignment:MainAxisAlignment.start,children: [
                FlatButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AnswersList(question: widget.question,qImage: widget.qImage,)));

                },
                    child: Text("View Replies",style: TextStyle(color: Colors.teal,fontSize: 15,fontWeight: FontWeight.bold,))
                ),Spacer(),
                FlatButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AnswerPage(u_name: u_name,
                    u_username: u_username,
                    u_image:u_image,
                    question: widget.question,
                    qImage: widget.qImage,
                    time: widget.time,)));
                },
                    child: Text("Reply",style: TextStyle(color: Colors.teal,fontSize: 15,fontWeight: FontWeight.bold,))
                )
              ],)
            ],
          ),
        ),
      ),
    );
  }
}

//VIEW POSTS Add
class Post extends StatefulWidget{
  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  TextEditingController questionTEC = new TextEditingController();
  String QImage="";
  String checkedSubject="Post";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Post"),backgroundColor: Colors.teal,),
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(padding: EdgeInsets.all(5),
                child: TextFormField(
                  style: TextStyle(color: Colors.black,fontSize: 19),
                  controller: questionTEC,
                  maxLines: 10,
                  decoration: InputDecoration(
                      hintText: " What's in your mind...?",
                      hintStyle: TextStyle(color: Colors.blueGrey,fontSize: 19)),),
                color: Colors.white,
              ),
              SizedBox(height: 15,),
              GestureDetector(onDoubleTap: (){
                setState(() {
                  QImage="";
                });
              },
                child: Container(padding: EdgeInsets.all(5),
                  color: Colors.white,
                  child: QImage.isNotEmpty?Image.network(QImage):Container(),
                ),
              ),
              QImage.isNotEmpty?Center(child: Text("Double tap to remove the image",style: TextStyle(color: Colors.blueGrey.shade300),),):Container(),
              SizedBox(height: 15,),

              SizedBox(height: 30,),
              Divider(),
              Row(mainAxisAlignment: MainAxisAlignment.end,crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(onTap: (){
                    uploadImage();
                  }, child: Icon(Icons.camera_alt,size: 28,)),
                  SizedBox(width: 25,),
                  GestureDetector(onTap: (){
                    if(questionTEC.text.isNotEmpty||QImage.isNotEmpty) {
                      uploadPost();
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Loading()));
                    }
                  }, child: Text("POST",style: TextStyle(fontWeight:FontWeight.bold,color: Colors.redAccent,fontSize: 18),)),
                  SizedBox(width: 25,)
                ],),
              SizedBox(height: 15,)
            ],
          ),
        ),
      ),
    );
  }

  uploadPost() async {
    Map<String,dynamic> uploadQuestion={
      "Question":questionTEC.text,
      "QImage":QImage,
      "Unanswered":"false",
      "Subject":checkedSubject,
      "AskedBy":Constants.myEmail,
      "Answer":[],
      "Time":DateTime.now().toString()
    };
    await FirebaseFirestore.instance.collection('AskedQuestions').add(uploadQuestion);
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
      print("xxx");
      if (image != null){
        //Upload to Firebase
        var snapshot = await _firebaseStorage.ref()
            .child('QuestionImages/${Constants.myEmail}${DateTime.now()}')
            .putFile(file);
        var downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          QImage = downloadUrl;
          print("IMG$QImage");
        });
      } else {print('No Image Path Received');}
    } else {print('Permission not granted. Try Again with permission access');}
  }
}

class Loading extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Container(child: Text("Post ✓",style: TextStyle(color: Colors.blueGrey,fontSize: 22,),),),),
    );
  }
}