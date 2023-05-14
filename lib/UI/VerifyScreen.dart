import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:impulse/Services/database.dart';
import 'package:impulse/UI/dashboard.dart';
import 'package:impulse/Widgets/widgets.dart';
import 'package:impulse/helper/constants.dart';
import 'package:impulse/helper/helperFunctions.dart';

class VerifyScreen extends StatefulWidget{
  String email;
  String name;
  String username;
  VerifyScreen({this.email,this.name,this.username});
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen>{
  DatabaseMethods databaseMethods = new DatabaseMethods();
  final auth = FirebaseAuth.instance;
  User user;
  Timer timer;
  String mail="";
  @override
  void initState(){
    user = auth.currentUser;
    timer = Timer.periodic(Duration(seconds: 10), (timer) {
      checkEmailVerified();
    });
    if(!user.emailVerified){
      user.sendEmailVerification();
    }
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {/*
    HelperFunction.getUserEmailSharedPreference().then((value) => mail=value);*/
    return Scaffold(
      appBar: AppBarMain(context),
      body: Center(
        child: Container(height: 60,
        width: 280,
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
        ),
        child: Center(child: Text("An email has been sent to ${widget.email} for verification.",textAlign: TextAlign.center,style: mediumTextStyle(),)),
        ),),
    );
  }

  Future<void> checkEmailVerified() async{
    user = auth.currentUser;
    await user.reload();
    if(user.emailVerified){
      timer.cancel();
      Map<String, dynamic> userMapInfo = {
        "Email": widget.email,
        "Name": widget.name,
        "Username":widget.username,
        "Location":"","Interest":[],"Gender":"","Description":"","ImageURL":"","Report":[]};
      databaseMethods.uploadUserInfo(userMapInfo);
      HelperFunction.saveUserLoggedInSharedPreference("true");
      HelperFunction.saveUserNameSharedPreference(widget.name.trim());
      HelperFunction.getUserNameSharedPreference().then((value) => Constants.myName=value);
      HelperFunction.saveUserEmailSharedPreference(widget.email.trim());
      HelperFunction.getUserEmailSharedPreference().then((value) => Constants.myEmail=value);
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> DashboardPage()));
    }
}
}