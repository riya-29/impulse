import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:impulse/NewsSection/helper/data.dart';
import 'package:impulse/NewsSection/models/categorie_model.dart';
import 'dart:math' as math;
import 'package:impulse/NewsSection/views/homepage.dart';
import 'package:impulse/ProjectBank/ProjectBank.dart';
import 'package:impulse/Services/auth.dart';
import 'package:impulse/Services/database.dart';
import 'package:impulse/UI/GroupSection/GroupsPage.dart';
import 'package:impulse/UI/Planner/todomain.dart';
import 'package:impulse/UI/QnASection/SearchUserProfile.dart';
import 'package:impulse/UI/QnASection/UnansweredQuestion.dart';
import 'package:impulse/UI/QnASection/YourQuery.dart';
import 'package:impulse/UI/QuizSection/quizmain.dart';
import 'package:impulse/UI/TimeLine&Section/ViewProfile.dart';
import 'package:impulse/UI/TimeLine&Section/editprofile.dart';
import 'package:impulse/UI/users.dart';
import 'package:impulse/helper/authenticate.dart';
import 'package:impulse/helper/constants.dart';
import 'package:impulse/helper/helperFunctions.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'AboutUs.dart';
import 'Contactus.dart';
import 'GroupSection/CreateGroup.dart';
import 'GroupSection/groupChatWindow.dart';
import 'QnASection/ViewUserProfile.dart';
import 'QuizSection/Database/Services.dart';
import 'QuizSection/Database/Var.dart';
import 'QuizSection/QuizDashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'QuizSection/QuizScreen.dart';
import 'invites.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}
int selectedIndex=0;

class _DashboardPageState extends State<DashboardPage> {
  AuthMethod auth = new AuthMethod();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  List<CategorieModel> categories = List<CategorieModel>(); //news

  Stream chatRoomStream;
  getUserInfo() async {
    //print(Constants.myName);
    databaseMethods.getGroupChatRooms("${Constants.myName}"+"_"+"${Constants.myEmail.split('@')[0]}").then((value){
      setState(() {
        chatRoomStream = value;
      });
    });
    getProjects();
  } //For Group

  Widget chatRoomList(){
    return Container(
          height: 100,
          child: StreamBuilder(
              stream: chatRoomStream,
              builder: (context, snapshot) {
                if(snapshot.hasData==false){return Container();}
                int count = snapshot.data.docs.length + 1;
                return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: count > 6 ? 6 : count,
                    itemBuilder: (context, index) {
                      //print("index$index ${snapshot.data.docs.length+1}");
                      if (snapshot.data == null) {
                        Loading();
                      }
                      return index != (snapshot.data.docs.length)
                          ? Container(
                              padding: EdgeInsets.symmetric(horizontal: 13),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  GroupChatWindow(snapshot
                                                      .data.docs[index]
                                                      .get('GName'))));
                                    },
                                    child: CircleAvatar(
                                      radius: 40,
                                      backgroundColor: Colors.grey.shade100,
                                      backgroundImage: snapshot.data.docs[index].get('GPhoto').toString().length!=0?NetworkImage(snapshot.data.docs[index].get('GPhoto').toString()):null,
                                    ),
                                  ),
                                  Text(
                                    "${snapshot.data.docs[index].get('GName')}",
                                    style: TextStyle(
                                        color: Colors.blueGrey.shade700,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            )
                          : Container(
                              padding: EdgeInsets.symmetric(horizontal: 13),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CreateGroup()));
                                    },
                                    child: CircleAvatar(
                                      radius: 40,
                                      backgroundColor: Colors.grey.shade100,
                                      child: Icon(
                                        Icons.add_rounded,
                                        size: 50,
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Create',
                                    style: TextStyle(
                                        color: Colors.blueGrey.shade700,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            );
                    });
              }),
        );
  } //For Group

  //INIT
  @override
  void initState() {
  getConstName();
    super.initState();
  }

  getConstName() async{
    int val=0;
    var n = await FirebaseFirestore.instance.collection("Users").get();
    for(int i=0;i<n.docs.length;i++) {
      if(n.docs[i].get('Email').toString().contains(Constants.myEmail)){
        val=i;
        break;
      }
    }
    setState(() {
      Constants.myName=n.docs[val].get('Name');
      Constants.imageURL=n.docs[val].get('ImageURL');
      Constants.username=n.docs[val].get('Username');
    });

    categories = getCategories();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    HelperFunction.getUserEmailSharedPreference().then((value) => Constants.myEmail=value);
    //getUserInfo();
    return Scaffold(
      drawer:NavDrawer(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.teal,
       title: Text('App Dashboard', textAlign: TextAlign.left,
         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
       ),
       actions:[
         Padding(
           padding: EdgeInsets.all(4.0),
         child:Column(
           children: [
             PopupMenuButton(
                  itemBuilder: (context)=>[
                  PopupMenuItem(
                    child:InkWell(
                           child:Text("View Profile"),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => ViewProfile()));
                      },
                           ),
                  ),
                  PopupMenuItem(
                    child:
                    InkWell(
                      child:Text("Edit Profile"),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => EditProfile()));
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child:
                    InkWell(
                      child:Text("Invite Friends"),
                    onTap: ()=>{
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
                  ],),
           ]),
         ),
       ], systemOverlayStyle: SystemUiOverlayStyle.dark),
      backgroundColor: Colors.white,
      bottomNavigationBar: homeBottomNavigationBar(context),
      body:SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 15,),
            Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child: Icon(Icons.format_quote),
                ),
                SizedBox(width: 5,),
                Center(child: Text("A clear vision, backed by definite plans, gives "
                    "\n you a tremendous feeling of confidence and "
                    "\n                              personal power. ",
                  style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueGrey),),
                ),
                SizedBox(width: 5,),
                Icon(Icons.format_quote),
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("— Brian Tracy"),SizedBox(width: 30,)
              ],
            ),
            SizedBox(height: 15,),
            Row(children: [
              SizedBox(width: 15,),
              Text("Browse News ",style: TextStyle(color: Colors.black,fontSize:22,fontWeight: FontWeight.bold),),
              Icon(Icons.arrow_forward_ios_rounded,color: Colors.black,)],),
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16,),
              height: 120,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return CategoryCard(
                      imageAssetUrl: categories[index].imageAssetUrl,
                      categoryName: categories[index].categorieName,
                    );
                  }),
            ),
            SizedBox(height: 15,),
            Row(children: [
              SizedBox(width: 15,),
              Text("Browse Quizzes ",style: TextStyle(color: Colors.black,fontSize:22,fontWeight: FontWeight.bold),),
              Icon(Icons.arrow_forward_ios_rounded,color: Colors.black,)],),
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16,),
              height: 120,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: quizDashes.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(onTap:(){ subject=subjectList[index];
                    get_Question();
                    assignQuizVariables();
                     Navigator.push(context,MaterialPageRoute(builder: (context)=>QuizScreen()));},
                    child:quizDashes[index]
                    );
                  }),
            ),
            SizedBox(height: 15,),
            Row(children: [
              SizedBox(width: 15,),
              Text("Groups ",style: TextStyle(color: Colors.black,fontSize:22,fontWeight: FontWeight.bold),),
              Icon(Icons.arrow_forward_ios_rounded,color: Colors.black,)],),
            SizedBox(height: 10,),
            chatRoomList(), //For Group
            SizedBox(height: 15,),
            Row(children: [
              SizedBox(width: 15,),
              Text("Latest Projects ",style: TextStyle(color: Colors.black,fontSize:22,fontWeight: FontWeight.bold),),
              Icon(Icons.arrow_forward_ios_rounded,color: Colors.black,)],),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10,),
              height: 230,
              child: ListView.builder(scrollDirection: Axis.horizontal,
                  itemCount: (title.length != null) ? title.length : 0,
                  itemBuilder: (context, index) {
                    return ProjectTile(index, title[index], abstract[index], images[index],
                        MediaQuery.of(context).size.width * 0.5, category[index]);
                  }),
            ),
            SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }

  //project tile
  List<String> title = new List<String>();
  List<String> category = new List<String>();
  List<String> abstract = new List<String>();
  List<String> images = new List<String>();
  List<String> summary = new List<String>();
  List<String> name = new List<String>();

  getProjects() async {
    var n = await FirebaseFirestore.instance.collection("ProjectBank").orderBy('date',descending: true).get();

    for (int i = 0; i < (n.docs.length>7?7:n.docs.length); i++) {
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

  Widget ProjectTile(int ind, String title, String abstract, String img, double width, String category,) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ProjectPg(title,abstract)));
      },
      child: Card(
        color: Colors.white70,
        child: SingleChildScrollView(scrollDirection: Axis.horizontal,
          child: Row(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
            children: [
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

            Container(color: Colors.white,
              padding: const EdgeInsets.all(10.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${title.trim()}", style: TextStyle(color: Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),),
                  SizedBox(height: 10),

                  Container(color: Colors.white,
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

Widget homeBottomNavigationBar(BuildContext context){
  return BottomNavigationBar(currentIndex: selectedIndex,selectedItemColor: Colors.black,unselectedItemColor: Colors.blueGrey,
    onTap: (val){
      if(val==0){
          selectedIndex=0;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DashboardPage()));
      }
      if(val==1){
          selectedIndex=1;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SearchUser()));
      }
      if(val==2){
        selectedIndex=val;
        Navigator.push(context, MaterialPageRoute(builder: (context)=>UnansweredQuestion()));
      }
      if(val==3){
          selectedIndex=val;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>NewsHomePage()));
      }
    },
    type: BottomNavigationBarType.shifting,
    items: [
      BottomNavigationBarItem(icon: Icon(Icons.home),label: "Home"),
      BottomNavigationBarItem(icon: Icon(Icons.search,),label: "Search"),
      BottomNavigationBarItem(icon: Icon(Icons.forum_outlined),label: "Query"),
      BottomNavigationBarItem(icon: Icon(Icons.web,),label: "News")
    ],

  );
}

class NavDrawer extends StatefulWidget {
  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  void show(){
    showDialog(
        context:context,
        builder:(context){
          return new RatingDialog(
            image: Icon(Icons.celebration,color: Colors.red,size: 100,),
            title:Text("Rate Us "),
            message: Text('Tap a star to set your rating. Add more description here if you want.'),
            onCancelled: () => print('cancelled'),
            onSubmitted: (response) {
              int s=response.rating as int;
              String c=response.comment;
              FirebaseFirestore.instance.collection('Rating').doc(Constants.myEmail).set({'Rating': s, 'Comment': c,'Email':Constants.myEmail});
              if (response.rating <=3.0) {
                return showDialog(
                  context:context,
                  builder:(context){
                    return AlertDialog(
                      title:Text("Write to us "),
                      actions: [
                        TextButton(
                          child:Text("Get in touch"),
                          onPressed:() {Navigator.push(context, MaterialPageRoute(builder:(context)=>ContactUs()));},),
                        TextButton(
                            child:Text("Cancel"),
                            onPressed:() {Navigator.pop(context);}
                            )],);
                  },
                );
              } else {
                return showDialog(
                  context:context,
                  builder:(context){
                    return AlertDialog(
                      title:Text("Thanks For Rating "),
                      content:Text("For any queries do contact us"),
                    );},);}},
            submitButtonText: 'Submit',
          );/*,*/
          });
    /*showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _ratingDialog,
    );*/
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding:EdgeInsets.zero,
        children: [
          DrawerHeader(child: Container(height: 50,
            width: MediaQuery.of(context).size.width/1.5,
            child: Column(mainAxisAlignment: MainAxisAlignment.end,crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5,),
                GestureDetector(onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ViewProfile()));
                  },
                  child: CircleAvatar(radius: 40,
                    backgroundColor: Colors.grey.shade100,
                    backgroundImage: (Constants.imageURL!="")?NetworkImage(Constants.imageURL):null,
                    child: (Constants.imageURL!="")?Container():Icon(Icons.person,color: Colors.black87,size: 30,),
                  ),
                ),
                Spacer(),
                Text("${Constants.myName}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                SizedBox(height: 3,),
                Text("${Constants.myEmail}",style: TextStyle(fontWeight: FontWeight.normal,fontSize: 18,color: Colors.black87),)
              ],
            ),
          )),
          ListTile(
            leading: Icon(Icons.dashboard),
            title:Text('Dashboard'),
            onTap: (){Navigator.pop(context);Navigator.push(context, MaterialPageRoute(builder: (context)=>DashboardPage()));},
          ),
          ListTile(
            leading: Icon(Icons.question_answer_rounded),
            title:Text('Your Query'),
            onTap: (){Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context)=>YourQuery()));
            },
          ),
          ListTile(
            leading:Icon(Icons.all_inbox_outlined),
            title: Text('Groups'),
            onTap: (){
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context)=>GroupChatRooms()));},
          ),
          ListTile(
            leading: Icon(Icons.app_registration),
            title: Text('Planner'),
            onTap: ()=>{Navigator.push(context, MaterialPageRoute(builder: (context)=>MyToDo()))},
          ),
          ListTile(
            leading:Icon(Icons.dns),
            title: Text('Quiz'),
            onTap: (){Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context)=> QuizMain()));},
          ),
          ListTile(
            leading: Icon(Icons.auto_awesome_motion),
            title: Text('Project Bank'),
            onTap: (){
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context)=> ProjectBank()));
            },
          ),
          ListTile(
            leading:Icon(Icons.contact_support_outlined) ,
            title: Text('Write to us'),
            onTap: ()=>{Navigator.push(context,MaterialPageRoute(builder: (context)=>ContactUs()))},
          ),
          ListTile(
            leading: Icon(Icons.star_rate_sharp),
            title: Text("Rate Us"),
            onTap: () =>{show()
            },
          ),
          ListTile(
            leading:Icon(Icons.subject) ,
            title: Text('About us'),
            onTap: (){
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context)=>AboutUsPage()));},
          ),
          ListTile(
            leading:Icon(Icons.logout) ,
            title: Text('Sign out'),
            onTap: (){
              HelperFunction.saveUserLoggedInSharedPreference("false");
              while(Navigator.canPop(context)){
                Navigator.pop(context);
                print(Navigator.canPop(context));
              }
              AuthMethod auth = new AuthMethod();
              auth.signOut();
              signOutGoogle();
              Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>Authenticate()));},
          ),
        ],),
    );
  }
}

/*
Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            height: 70,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return CategoryCard(
                    imageAssetUrl: categories[index].imageAssetUrl,
                    categoryName: categories[index].categorieName,
                  );
                }),
          ),
*/

/*
Container(decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.white, Colors.teal,],)),
        child: GridView.count(
          crossAxisCount: 2,
          children: [
            Card(
                child:InkWell(
                  onTap: (){subject="RANDOM QUIZ";
                  get_Question();
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>QuizMain()));
                  },
                  splashColor: Colors.blueAccent,
                  child: Center(
                      child:Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset("asset/images/quiz.png",
                              height: 70),
                          Text("Quiz me",
                              style:TextStyle(
                                fontWeight:FontWeight.bold,
                                fontSize: 15,
                              )),
                          SizedBox(height: 5,),
                          Text("Real time quizzes with \npeople round the world",
                              textAlign: TextAlign.center,
                              style:TextStyle(
                                fontSize: 13,
                              )
                          ),
                        ],
                      )
                  ),
                )
            ),
            Card(
                child:InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>GroupChatRooms()));
                  },
                  splashColor: Colors.blueAccent,
                  child: Center(
                      child:Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset("asset/images/Groups.png",
                              height: 70),
                          Text("Groups",
                              style:TextStyle(fontWeight:FontWeight.bold, fontSize: 15,
                              )),
                          SizedBox(height: 5,),
                          Text("Groups for like minded people on variety of topics",
                              textAlign: TextAlign.center,
                              style:TextStyle(fontSize: 13,
                              )
                          ),
                        ],
                      )
                  ),
                )
            ),
            Card(
                child:InkWell(
                  onTap: ()=>{Navigator.push(context, MaterialPageRoute(builder: (context)=>MyToDo()))},
                  splashColor: Colors.blueAccent,
                  child: Center(
                      child:Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset("asset/images/planner.png",
                              height: 60),
                          Text("Planner",
                              style:TextStyle(
                                fontWeight:FontWeight.bold,
                                fontSize: 15,
                              )),
                          SizedBox(height: 5,),
                          Text("Plan and keep track of all your upcoming assignments",
                              textAlign: TextAlign.center,
                              style:TextStyle(

                                fontSize: 13,
                              )
                          ),
                        ],
                      )
                  ),
                )
            ),

            Card(
                child:InkWell(
                  onTap: ()=>{
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>NewsHomePage()))
                  },
                  splashColor: Colors.blueAccent,
                  child: Center(
                      child:Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset("asset/images/news.png",
                              height: 60),
                          Text("News",
                              style:TextStyle(
                                fontWeight:FontWeight.bold,
                                fontSize: 15,
                              )),
                          SizedBox(height: 5,),
                          Text("Round the clock news updates from the world of technology",
                              textAlign: TextAlign.center,
                              style:TextStyle(

                                fontSize: 13,
                              )
                          ),
                        ],
                      )
                  ),
                )
            ),
            Card(
                child:InkWell(
                  onTap: ()=>{},
                  splashColor: Colors.blueAccent,
                  child: Center(
                      child:Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset("asset/images/projectbank.png",
                              height: 60),
                          Text("Project Bank",
                              style:TextStyle(
                                fontWeight:FontWeight.bold,
                                fontSize: 15,
                              )),
                          SizedBox(height: 5,),
                          Text("Find, share and tell projects \nto other members",
                              textAlign: TextAlign.center,
                              style:TextStyle(

                                fontSize: 13,
                              )
                          ),
                        ],
                      )
                  ),
                )
            ),
          ],),
      ),
      */