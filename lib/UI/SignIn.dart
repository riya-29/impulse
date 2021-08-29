import 'package:auth_buttons/auth_buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:impulse/Model/user.dart';
import 'package:impulse/Services/auth.dart';
import 'package:impulse/Services/database.dart';
import 'package:impulse/UI/ForgotPassword.dart';
import 'package:impulse/UI/dashboard.dart';
import 'package:impulse/UI/google_sign_in.dart';
import 'package:impulse/UI/users.dart';
import 'package:impulse/Widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:impulse/helper/constants.dart';
import 'package:impulse/helper/helperFunctions.dart';

import 'GlobalVars.dart';
import 'TimeLine&Section/editprofile.dart';


class Sign_In extends StatefulWidget{
  final Function toggle;
  Sign_In(this.toggle);
  @override
  State<Sign_In> createState() =>_SignIn();
}

class _SignIn extends State<Sign_In>{
  //bool signed = false;
  DatabaseMethods databaseMethods = new DatabaseMethods();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false;
  QuerySnapshot snapshotUserInfo;
  TextEditingController emailTEC = new TextEditingController();
  TextEditingController passwordTEC = new TextEditingController();

  final formKey =GlobalKey<FormState>();

  @override
  void initState(){   //to set email stored in SharedPrefereence in Email_textField
    if(HelperFunction.getUserEmailSharedPreference().toString()!=null){
      HelperFunction.getUserEmailSharedPreference().then((value) => {emailTEC.text=value});
    }
    super.initState();
  }

  AuthMethod authMethod = new AuthMethod();
  signMeIn(){
    if(formKey.currentState.validate()){
      setState(() {
        HelperFunction.saveUserEmailSharedPreference(emailTEC.text);
        isLoading = true;
      });
      databaseMethods.getUserByUserEmail(emailTEC.text).then((val){
        snapshotUserInfo = val;
        //HelperFunction.saveUserEmailSharedPreference(snapshotUserInfo.docs[0].get("Users"));
        HelperFunction.saveUserEmailSharedPreference(emailTEC.text);
      });
      authMethod.signInWithEmailAndPassword(emailTEC.text, passwordTEC.text,context).then((value) {
        print("Value:${value}");
        if (value != null) {
          String login;
          HelperFunction.saveUserLoggedInSharedPreference("true");
          HelperFunction.getUserLoggedInSharedPreference().then((val){login= val;});
          print("Login ${login}");
          HelperFunction.getUserEmailSharedPreference().then((val){Constants.myEmail= val;});
          print("Login ${login}");
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => DashboardPage()));
        }
        else{
          final snackBar = SnackBar(content: Text("$Err"),backgroundColor: Colors.redAccent,duration: Duration(milliseconds: 2500),);
          _scaffoldKey.currentState.showSnackBar(snackBar);
        }
      });
      }

    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBarMain(context),
      backgroundColor: Colors.white,
      body: Builder(
      builder: (BuildContext context)=> SingleChildScrollView(
        child: Container(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(children: [
                    SizedBox(height: 40,),
                    Text("Welcome", style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,),),
                    SizedBox(height:20,),
                    Text("Impulse provides a global community for students and young professionals to interact",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[700], fontSize: 15,),)
                  ],
                ),
                SizedBox(height: 100,),
                Form(key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                        validator: (val){
                          return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ?
                          null : "Invalid Email";
                        },
                        controller:emailTEC,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration('Email','Email')
                    ),TextFormField(
                        validator: (val){
                          return val.length < 6?"Password must have at least 6 characters":null;
                        },
                        obscureText: true,
                        controller:passwordTEC,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration('Password','Password')
                    ),
                  ],),
              ),
                SizedBox(height: 8,),
                Row(mainAxisAlignment: MainAxisAlignment.end,
                  children:[
                    GestureDetector( onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPassword()));
                    },
                        child: Text('Forget Password?',style: simpleTextStyle(),))],),
                SizedBox(height:  16,),
                GestureDetector(
                  onTap: (){
                    signMeIn();
                    },
                  child: Container(
                    alignment:  Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        //borderRadius: BorderRadius.circular(24.0),
                        gradient: LinearGradient(colors: [Colors.teal,Colors.teal.shade400,])
                    ),
                    child: Text('Sign In',style: TextStyle(color: Colors.white,
                        fontSize: 19),),),
                ),
                SizedBox(height: 16,),
                Row(mainAxisAlignment:MainAxisAlignment.center,
                    children:[
                      Text("Don't have an account? ", style: mediumTextStyle(),),
                      GestureDetector(
                        onTap: (){
                          widget.toggle();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text("Register Now", style: TextStyle(color: Colors.black,
                              fontSize: 14,
                              decoration: TextDecoration.underline)),
                        ),
                      )]),
                SizedBox(height: 10,),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(width: MediaQuery.of(context).size.width/2-50,
                        child: Divider(color: Colors.blueGrey.shade200,)),
                    Text(" Or ",style: TextStyle(color: Colors.teal,fontWeight: FontWeight.bold),),
                    Container(width: MediaQuery.of(context).size.width/2-50,
                        child: Divider(color: Colors.blueGrey.shade200,)),
                  ],
                ),
                SizedBox(height: 10,),
                Container(width: MediaQuery.of(context).size.width ,
                    child:GoogleAuthButton(
                      onPressed: (){
                        String docId="xx";
                        signInWithGoogle().then((onvalue) async {
                            // print("hiii before");
                            var n = await FirebaseFirestore.instance.collection("Users").where("Email",isEqualTo: email).get();
                            // print("hiii ${n.docs.isEmpty}");
                            if(n.docs.isNotEmpty) {
                                docId = n.docs[0].get('Email').toString();
                              }

                          // print("hiii $docId $email");
                          if(n.docs.isNotEmpty){

                          }else {
                            // print("hiii");
                            await FirebaseFirestore.instance.collection('Users')
                                  .doc(email).set({'Email': email, 'ImageURL': imageURL, 'Name': name,"Location":"","Interest":[],"Gender":"","Username":"","Report":[]
                              });
                            }
                          }).catchError((e){
                          print(e);
                        }).then((onvalue)
                        {
                          HelperFunction.saveUserLoggedInSharedPreference("true");
                          HelperFunction.saveUserEmailSharedPreference(email);
                          HelperFunction.saveUserNameSharedPreference(name);
                          Constants.myEmail = email;
                          Constants.imageURL = imageURL;
                          Constants.myName = name;
                          if(docId.compareTo(email)==0){
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardPage()));
                          }else {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EditProfile()));
                            }
                          }).catchError((e){print((e));});
                      },)
                ),
                SizedBox(height: 10,),
              ],
            ),
          ),
        ),
      ),),);
  }
}