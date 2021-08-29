import 'package:flutter/material.dart';
import 'package:impulse/UI/QuizSection/quiz.dart';
import 'package:impulse/UI/TimeLine&Section/editprofile.dart';
import 'package:impulse/helper/authenticate.dart';
import '../dashboard.dart';
import '../invites.dart';
import 'QuizScreen.dart';
import 'ResultScreen.dart';

class QuizMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      drawer: NavDrawer(),
      appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.teal,
          title: Text('Quiz me',
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),

          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios,
              size: 20,
              color: Colors.white,),

          ),
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
            /*Padding(
              padding: EdgeInsets.all(4.0),
              child: Column(
                  children: [
                    PopupMenuButton(
                      itemBuilder: (context) =>
                      [
                        PopupMenuItem(
                          child: InkWell(
                            child: Text("View Profile"),
                          ),
                        ),
                        PopupMenuItem(
                          child:
                          InkWell(
                              child: Text("Edit Profile"),
                              onTap: ()=>{Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => EditProfile())),}
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
                            onTap: () =>
                            {Navigator.push(context, MaterialPageRoute(
                                builder: (context) => Authenticate()))
                            },
                          ),

                        ),
                      ],
                    ),
                  ]),

            ),*/
            Padding(padding: EdgeInsets.all(8),
            child: IconButton(icon: Icon(Icons.leaderboard_rounded),onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Leaderboard()));
            },),)
          ],
    ),
      body: Quiz(),
    );
  }
}
