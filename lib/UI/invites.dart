import 'package:flutter/material.dart';
import 'package:impulse/UI/TimeLine&Section/ViewProfile.dart';
import 'package:impulse/helper/authenticate.dart';
import 'package:impulse/helper/helperFunctions.dart';
import'package:share/share.dart';
// import 'package:impulse/dashboard.dart';
import 'package:impulse/main.dart';

import 'TimeLine&Section/editprofile.dart';
import 'dashboard.dart';
class InviteFriends extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        drawer: NavDrawer(),
        appBar: AppBar(elevation: 0, brightness: Brightness.light, backgroundColor: Colors.teal,
            actions: [
              Padding(
                padding: EdgeInsets.all(4.0),
                child: Column(
                    children: [
                      PopupMenuButton(itemBuilder: (context) =>
                        [
                          PopupMenuItem(child: InkWell(child: Text("Invite Friends"),
                            onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => InviteFriends()))},),),
                          PopupMenuItem(child: InkWell(child: Text("Logout"),
                              onTap: () {HelperFunction.saveUserLoggedInSharedPreference("false");
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Authenticate()));},),),
                        ],),
                    ]),
              ),]),
        body: Column(
          children: [
            SizedBox(height: 30,),
            Text("Lets Grow Impulse Family",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                )),
            SizedBox(height: 8),
            Text("Invite your friends to join Impulse Family",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,),),
            SizedBox(height: 20,),
            Card(
              child: Container(
                alignment: Alignment.center,
                child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      _getCard(),
                      _getAvtar(),
                    ]),
              ),
            ),
            SizedBox(height: 20,),
            MaterialButton(
              elevation: 5.0,
                height:50,
                minWidth: 150,
                color: Colors.teal.shade300,
                child:Icon(Icons.share),
                onPressed: ()=>{
                  Share.share("Please visit Impulse the global community for students"
                     " and young professionals to join like minded people like you")}),
            SizedBox(height: 5,),
            Text("Invite Friends",style: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.bold),),
          ],)
    );
  }

  Container _getCard() {
    return Container(
      width: 350,
      height: 200,
      margin:EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.teal,
        borderRadius: BorderRadius.circular(14.5),

      ),
      child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Invite your friends"
            ,style:TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ))
          ],
        )
    );

  }
  Container _getAvtar()
  {
    return Container(
      width:100,
      height:100,
      decoration:BoxDecoration(
        color:Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(50.0)),
        border: Border.all(color: Colors.deepPurpleAccent,width:1.2),
          image: DecorationImage(
              image: AssetImage("asset/images/friends.png")

          )

      )


    );

  }
}