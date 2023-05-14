import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:impulse/Services/auth.dart';
import 'package:impulse/Services/database.dart';
import 'package:impulse/UI/QnASection/SearchUserProfile.dart';
import 'package:impulse/UI/QnASection/ViewUserProfile.dart';
import 'package:impulse/UI/QnASection/YourQuery.dart';
import 'package:impulse/helper/authenticate.dart';
import 'package:impulse/helper/constants.dart';
import 'package:impulse/helper/helperFunctions.dart';
import '../dashboard.dart';
import '../invites.dart';
import '../users.dart';
import 'editprofile.dart';

class ViewProfile extends StatefulWidget {
  @override
  _ViewProfileState createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  String name="";
  String description="";
  String interests="";
  String username="";
  String location="";
  String gender="";

  @override
  void initState() {
    getProfileData();
    super.initState();
  }

  getProfileData() async {
    String docId="";
    var n = await FirebaseFirestore.instance.collection("Users").get();
    for(int i=0;i<n.docs.length;i++){
      if("${Constants.myEmail}".contains(n.docs[i].get('Email'))){
        docId=n.docs[i].id;
        break;
      }
    }
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection("Users").doc("$docId").get();
    setState(() {
      name = documentSnapshot['Name'];
      username = documentSnapshot['Username'];
    });
      if(documentSnapshot['Location'].toString().startsWith('_')){
        location="";
      }else {
        setState(() {
          location = documentSnapshot['Location'].toString().replaceAll('_', ', ');
        });
      }
      setState(() {
        description=documentSnapshot['Description'];
        gender =documentSnapshot['Gender'];
        interests = documentSnapshot['Interest'].toString().substring(1,documentSnapshot['Interest'].toString().length-1).toString();
      });
    getUserInfo();//get groups
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 4,

      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          drawer: NavDrawer(),
          appBar: AppBar(elevation: 0, backgroundColor: Colors.teal,
            title: GestureDetector(onTap: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ViewProfile()));
            },
              child: Text('Profile', textAlign: TextAlign.left,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
            ),
            leading: IconButton(onPressed: () { Navigator.pop(context);},
              icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.white,),),
            actions: [
              /*Padding(
                padding: EdgeInsets.all(5.0),
                child: Icon(Icons.notifications,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Icon(Icons.account_circle_outlined,
                ),),*/
              Padding(
                padding: EdgeInsets.all(4.0),
                child: Column(
                    children: [
                      PopupMenuButton(
                        itemBuilder: (context) =>
                        [
                          PopupMenuItem(
                            child:
                            InkWell(
                              child: Text("Edit Profile"),
                                onTap: (){
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => EditProfile()));}
                            ),

                          ),

                          PopupMenuItem(
                            child:
                            InkWell(
                              child: Text("Invite Friends"),
                              onTap: () =>
                              {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => InviteFriends()))
                              },
                            ),

                          ),
                          PopupMenuItem(
                            child:
                            InkWell(
                              child: Text("Logout"),
                              onTap: (){
                                HelperFunction.saveUserLoggedInSharedPreference("false");
                                while(Navigator.canPop(context)){
                                  Navigator.pop(context);
                                  print(Navigator.canPop(context));
                                }
                                AuthMethod auth = new AuthMethod();
                                auth.signOut();
                                signOutGoogle();
                                Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>Authenticate()));
                              },
                            ),

                          ),
                        ],
                      ),
                    ]),

              ),
            ], systemOverlayStyle: SystemUiOverlayStyle.dark),
          body:SingleChildScrollView(
            child: Column(children: <Widget>[
              Container(padding: EdgeInsets.symmetric(vertical: 25),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors:[Colors.teal,Colors.teal],)),
                child: Container(width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(backgroundColor: Colors.grey.shade100,
                            backgroundImage: (Constants.imageURL!="")?NetworkImage(Constants.imageURL):null,
                            child: (Constants.imageURL.length==0)?Icon(Icons.person,color: Colors.black87,size: 30,):null, radius: 50.0,),
                          SizedBox(height: 10.0,),
                          Text("$name", style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.white,),),
                          SizedBox(height:10),
                          Text("$description",style:TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white,)),
                        ]),
                  ),),
              ),
              Container(color:Colors.grey.shade100,
                height: 50,
                child: TabBar(labelColor: Colors.black,
                  tabs: [
                    Tab(text: 'About',
                      icon: Icon(Icons.account_box_outlined,
                        color: Colors.teal,),
                      iconMargin: EdgeInsets.only(bottom: 0.0),),
                    Tab(text: 'Posts',
                      icon: Icon(Icons.post_add,
                        color: Colors.teal,),
                      iconMargin: EdgeInsets.only(bottom: 0.0),),
                    Tab(text: 'Query',
                        icon: Icon(Icons.question_answer,
                          color: Colors.teal,),
                        iconMargin: EdgeInsets.only(bottom: 0.0)),
                    Tab(text: 'Projects',
                        icon: Icon(Icons.feed,
                          color: Colors.teal,),
                        iconMargin: EdgeInsets.only(bottom: 3.0))
                  ],),),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                  child: TabBarView(dragStartBehavior:DragStartBehavior.start,
                    children: [
                      aboutContainer(),
                      UserPosts(),
                      YourProfileQuery(),
                      ViewProject(),
                    ],)
              ),
              ],),
          ),),
    );

  }

  DatabaseMethods databaseMethods = new DatabaseMethods();
  //About
  Stream chatRoomStream;
  getUserInfo() async {
    //print(Constants.myName);
    databaseMethods.getGroupChatRooms("${Constants.myName}"+"_"+"${Constants.myEmail.split('@')[0]}").then((value){
      setState(() {
        chatRoomStream = value;
      });
    });
  } //For Group

  Widget chatRoomList(){
    return Container(width: MediaQuery.of(context).size.width/2+30,height: MediaQuery.of(context).size.width/2+150,
      child: StreamBuilder(
          stream: chatRoomStream,
          builder: (context, snapshot) {
            if(snapshot.hasData==false){return Container();}
            int count = snapshot.data.docs.length;
            return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: count,
                itemBuilder: (context, index) {
                  if (snapshot.data == null) {
                    Loading();
                  }
                  return Container(padding: EdgeInsets.symmetric(vertical: 8),
                    child: SingleChildScrollView(scrollDirection: Axis.horizontal,
                      child: Row(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey.shade100,
                            backgroundImage: snapshot.data.docs[index].get('GPhoto').toString().length!=0?NetworkImage(snapshot.data.docs[index].get('GPhoto')
                                .toString()):null,
                          ),
                          SizedBox(width: 15,),
                          Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${snapshot.data.docs[index].get('GName')}", style: TextStyle(color: Colors.blueGrey.shade700, fontWeight: FontWeight.bold,fontSize: 18)),
                              Text("${snapshot.data.docs[index].get('Category')}", style: TextStyle(color: Colors.blueGrey.shade700, fontWeight: FontWeight.normal,fontSize: 18),),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                });
          }),
    );
  } //For Group


  aboutContainer(){
    return Container(padding: EdgeInsets.symmetric(horizontal: 20,vertical: 0),alignment: Alignment.topCenter,
      height: MediaQuery.of(context).size.height-300,
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height:20),
            Text("Username",style:TextStyle(fontWeight: FontWeight.normal, color:Colors.blueGrey, fontSize:14,)),
            SizedBox(height: 5,),
            Text("@$username",style:TextStyle(fontWeight: FontWeight.normal, color:Colors.black, fontSize:19,)),
            Divider(),
            Text("Location",style:TextStyle(fontWeight: FontWeight.normal, color:Colors.blueGrey, fontSize:14,)),
            SizedBox(height: 5,),
            Text("$location",style:TextStyle(fontWeight: FontWeight.normal, color:Colors.black, fontSize:19,)),
            Divider(),
            Text("Gender",style:TextStyle(fontWeight: FontWeight.normal, color:Colors.blueGrey, fontSize:14,)),
            SizedBox(height: 5,),
            Text("$gender",style:TextStyle(fontWeight: FontWeight.normal, color:Colors.black, fontSize:19,)),
            Divider(),
            Text("Interests",style:TextStyle(fontWeight: FontWeight.normal, color:Colors.blueGrey, fontSize:14,)),
            SizedBox(height: 5,),
            SingleChildScrollView(scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  interests.split(',').length>0?interestContainer(interests.split(',')[0]):Container(),
                  SizedBox(width: 10,),
                  interests.split(',').length>1?interestContainer(interests.split(',')[1]):Container(),
                  SizedBox(width: 10,),
                ],
              ),
            ),
            SizedBox(height: 10,),
            SingleChildScrollView(scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  interests.split(',').length>2?interestContainer(interests.split(',')[2]):Container(),
                  SizedBox(width: 10,),
                  interests.split(',').length>3?interestContainer(interests.split(',')[3]):Container(),
                  SizedBox(width: 10,),
                ],
              ),
            ),SizedBox(height: 10,),
            SingleChildScrollView(scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  interests.split(',').length>4?interestContainer(interests.split(',')[4]):Container(),
                  SizedBox(width: 10,),
                  interests.split(',').length>5?interestContainer(interests.split(',')[5]):Container(),
                  SizedBox(width: 10,),
                ],
              ),
            ),
            SizedBox(height: 10,),
            SingleChildScrollView(scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  interests.split(',').length>6?interestContainer(interests.split(',')[6]):Container(),
                  SizedBox(width: 10,),
                  interests.split(',').length>7?interestContainer(interests.split(',')[7]):Container(),
                  SizedBox(width: 10,),
                ],
              ),
            ),
            Divider(),
            SizedBox(height:10),
            Text("Groups ",style: TextStyle(color: Colors.black,fontSize:20,fontWeight: FontWeight.bold),),
            chatRoomList()
          ],),
      ),
    );
  }

  Widget interestContainer(String interest){
    return Container(padding: EdgeInsets.all(8),
        decoration: BoxDecoration(color:Colors.grey.shade100,
          borderRadius: BorderRadius.all(Radius.circular(20)),),
        child: Text("$interest",style:TextStyle(fontWeight: FontWeight.normal, color:Colors.black, fontSize:18,)));
  }
}




//Query
class YourProfileQuery extends StatefulWidget{
  @override
  _YourProfileQueryState createState() => _YourProfileQueryState();
}

class _YourProfileQueryState extends State<YourProfileQuery> {
  // List<dynamic> interest = [];
  List<String> question=[];
  List<String> qImage=[];
  List<dynamic> time=[];
  List<String> askedBy=[];

  @override
  void initState() {
    getQuestions();
    super.initState();
  }

  getQuestions() async {
    int len;
    var ref = await FirebaseFirestore.instance.collection('AskedQuestions').orderBy("Time",descending: true).get();
    len = ref.docs.length;
    for(int i=0;i<len;i++) {
      if ( (ref.docs[i].get('AskedBy').toString().compareTo(Constants.myEmail)==0)&&ref.docs[i].get('Subject').toString().compareTo("Post")!=0) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(body:unansweredList());
  }

  unansweredList() {
    return Container(height: MediaQuery.of(context).size.height/2,
      child: ListView.builder(itemCount: askedBy.length,itemBuilder: (context,index){
        return UnansweredTile(time: time[index],question: question[index],qImage: qImage[index],email: askedBy[index],);
      }),
    );
  }
}


//Posts
class UserPosts extends StatefulWidget{
  @override
  _UserPostsState createState() =>_UserPostsState();
}

class _UserPostsState extends State<UserPosts>{
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTEC = new TextEditingController();

  List<dynamic> interest = [];
  List<String> question=[];
  List<String> qImage=[];
  List<dynamic> time=[];
  List<String> askedBy=[];

  QuerySnapshot searchSnapshot;

  @override
  void initState() {
    interest.add("Post");
    getQuestions();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(height: MediaQuery.of(context).size.height/2,
        color: Colors.white24,
        child: unansweredList(),
      ),);

  }


  getQuestions() async {
    int len;
    var ref = await FirebaseFirestore.instance.collection('AskedQuestions').orderBy("Time",descending: true).get();
    len = ref.docs.length;
    for(int i=0;i<len;i++) {
        if ( (ref.docs[i].get('AskedBy').toString().contains(Constants.myEmail))&&ref.docs[i].get('Subject').toString().contains("Post")) {
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

  unansweredList() {
    return ListView.builder(itemCount: askedBy.length,itemBuilder: (context,index){
      return PostTile(time: time[index],question: question[index],qImage: qImage[index],email: askedBy[index],);
    });
  }

}


//Project Bank
class ViewProject extends StatefulWidget {
  @override
  _ViewProjectState createState() => _ViewProjectState();
}

class _ViewProjectState extends State<ViewProject> {
  List<String> title = new List<String>();
  List<String> category = new List<String>();
  List<String> abstract = new List<String>();
  List<String> images = new List<String>();
  List<String> summary = new List<String>();
  List<String> name = new List<String>();

  String t;
  List filtered = [];
  bool isSearching = false;

  Widget allMailList() {
    double width = MediaQuery.of(context).size.width * 0.5;
    return ListView.builder(shrinkWrap: true,
        itemCount: (title.length != null) ? title.length : 0,
        itemBuilder: (context, index) {
          return ProjectTile(index, title[index], abstract[index], images[index],
              width, category[index]);
        });

  }

  @override
  void initState() {
    getProjects();
    super.initState();
  }

  getProjects() async {
    var n = await FirebaseFirestore.instance.collection("ProjectBank").orderBy('date',descending: true).get();
    for (int i = 0; i < n.docs.length; i++) {
      if(n.docs[i].get('email').toString().compareTo(Constants.myEmail)==0) {
        String a = n.docs[i].get('title').toString();
        String b = n.docs[i].get('category').toString();
        String c = n.docs[i].get('abstract').toString();
        String d = n.docs[i].get('image').toString();
        String e = n.docs[i].get('name').toString();
        setState(() {
          title.add(a);
          category.add(b);
          abstract.add(c);
          images.add(d);
          name.add(e);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( body:Container(height: MediaQuery.of(context).size.height/2+30,
        child: allMailList()));
  }
  
  Widget ProjectTile(int ind, String title, String abstract, String img, double width, String category,) {
    return GestureDetector(
      onLongPress: (){
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text('Delete Project'),
                actions: <Widget>[
                  new TextButton(
                    onPressed: () {
                      FirebaseFirestore.instance.collection("ProjectBank").where("title",isEqualTo: title).where("abstract",isEqualTo:abstract).get().then((snapshot) {
                        for (DocumentSnapshot doc in snapshot.docs) {
                          doc.reference.delete();
                        }
                      });
                      //delete post;
                      Navigator.of(context).pop();

                    },
                    // textColor: Colors.teal,
                    child: const Text('Yes',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),),
                  new TextButton(
                    onPressed: () {Navigator.of(context).pop();},
                    // textColor: Colors.teal,
                    child: const Text('No',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                  ),
                ],
              )
          );
      },
      onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => ProjectPg(title,abstract)));},
      child: Card(
        color: Colors.grey.shade50,
        child: SingleChildScrollView(scrollDirection: Axis.horizontal,
          child: Row(children: [
            Container(
              width: 150,
              height: 150,
              child: (img.length!=4)?Image.network(img,fit: BoxFit.cover,):Column(
                crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image_not_supported_outlined,size: 40,color: Colors.grey,),
                  Text("No Image",style: TextStyle(color: Colors.grey),)
                ],
              ),),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${title.trim()}", style: TextStyle(color: Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),),
                  SizedBox(height: 10),
                  Container(
                      width: width,
                      child: Text("${abstract.trim().substring(0,abstract.length>50?50:abstract.length)}${abstract.length>50?"...":""}", style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 17,
                          fontWeight: FontWeight.normal),)
                  ),
                  SizedBox(height: 5),
                  Container(
                    child: Text("#${category.trim()}", style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),),
                  ),
                  SizedBox(height: 5,),
                  Text("Uploaded by"),
                  SizedBox(height: 5,),
                  Row(
                    children: [
                      Container(
                        child: CircleAvatar(
                          backgroundColor: Colors.teal,
                          radius: 15,
                          child: Text("${name[ind][0]}", //userName.substring(0,1).toUpperCase()
                            style: TextStyle(color: Colors.white, fontSize: 20),),
                        ),),
                      SizedBox(width: 5,),
                      Text("${name[ind]}",style: TextStyle(color: Colors.black87, fontSize: 18)),
                    ],
                  )
                ],
              ),
            )
          ],),
        ),
      ),
    );
  }

}
