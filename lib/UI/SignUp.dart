import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:impulse/Services/auth.dart';
import 'package:flutter/material.dart';
import 'package:impulse/Services/database.dart';
import 'package:impulse/UI/VerifyScreen.dart';
import 'package:impulse/Widgets/widgets.dart';
import 'package:impulse/helper/authenticate.dart';
import 'package:impulse/helper/constants.dart';
import 'package:impulse/helper/helperFunctions.dart';

import 'GlobalVars.dart';


class Sign_Up extends StatefulWidget{
  final Function toggle;
  Sign_Up(this.toggle);

  @override
  State<Sign_Up> createState() => _SignUp();

}

class _SignUp extends State<Sign_Up>{
  DatabaseMethods databaseMethods = new DatabaseMethods();
  HelperFunction helperFunction = new HelperFunction();

  bool isLoading = false;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final formKey =GlobalKey<FormState>();
  TextEditingController nameTEC = new TextEditingController();
  TextEditingController usernameTEC = new TextEditingController();
  TextEditingController emailTEC = new TextEditingController();
  TextEditingController passwordTEC = new TextEditingController();

  AuthMethod authMethod = new AuthMethod();
  //bool usernameTaken=false;

  signMeUp() {
    /*Map<String, String> userMapInfo = {
      "Email": emailTEC.text, "Name": nameTEC.text,"Username":usernameTEC.text,
    };*/

    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      authMethod.signUpWithEmailAndPassword(emailTEC.text, passwordTEC.text).then((value) {
        print(value);
         if(value!=null){
           // print("${emailTEC.text},name: ${nameTEC.text},username: ${usernameTEC.text}");
        Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyScreen(email: emailTEC.text,name: nameTEC.text,username: usernameTEC.text,)));
        }else {
           final snackBar = SnackBar(content: Text("$Err"),backgroundColor: Colors.redAccent,duration: Duration(milliseconds: 2500),);
           _scaffoldKey.currentState.showSnackBar(snackBar);
           setState(() {
             isLoading=false;
           });
           //Navigator.push(context, MaterialPageRoute(builder: (context) => Authenticate()));
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
      body: isLoading?Center(child: CircularProgressIndicator(),):SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50,),
                Text("Welcome", style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,),),
                SizedBox(height:20,),
                Text("Impulse provides a global community for students and young professionals to interact",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[700], fontSize: 15,),),
                SizedBox(height: 50,),
                Form(key: formKey,        //FormKey for validation of form
                  child: Column(children: [
                    TextFormField(
                        validator: (value) {
                          return value.isNotEmpty?RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$').hasMatch(value)?"Only alphabets allowed":null:"Enter Name";
                        },
                        controller: nameTEC,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration('Name','Name')),
                    Row(crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(width: MediaQuery.of(context).size.width-100,
                          child: TextFormField(
                              validator: (val){
                                return RegExp(r"^(?=[a-zA-Z0-9._]{4,20}$)(?!.*[_.]{2})[^_.].*[^_.]$").hasMatch(val)?null:"Invalid username";
                              },
                              controller: usernameTEC,
                              style: simpleTextStyle(),
                              decoration: textFieldInputDecoration('Username','Username')),
                        ),
                        IconButton(onPressed: () async {
                          bool usernameTaken= await checkUsername(usernameTEC.text);
                          if(usernameTaken==false) {
                            final snackBar = SnackBar(content: Text("Username available!!"),backgroundColor: Colors.green,duration: Duration(milliseconds: 2500),);
                            _scaffoldKey.currentState.showSnackBar(snackBar);
                          }else{
                            final snackBar = SnackBar(content: Text("Username not available!!"),backgroundColor: Colors.redAccent,duration: Duration(milliseconds: 2500),);
                            _scaffoldKey.currentState.showSnackBar(snackBar);
                          }
                          }, icon: Icon(Icons.check_circle,size: 28,color: Colors.teal,))
                      ],
                    ),
                    TextFormField(
                        validator: (val){
                          return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ?
                          null : "Invalid Email";
                        },
                        controller: emailTEC,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration('Email','Email')),
                    TextFormField(
                        validator: (val){
                          return val.length < 6?"Password must have at least 6 characters":null;
                        },
                        obscureText: true,
                        controller: passwordTEC,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration('Password','Password')
                    ),],),
                ),
                SizedBox(height:  16,),
                GestureDetector(
                  onTap: () async {
                    bool usernameTaken= await checkUsername(usernameTEC.text);
                    if(usernameTaken==false) {
                      signMeUp();
                    }else{
                      final snackBar = SnackBar(content: Text("Username not available!!"),backgroundColor: Colors.redAccent,duration: Duration(milliseconds: 2500),);
                      _scaffoldKey.currentState.showSnackBar(snackBar);
                    }
                        },
                  child: Container(
                    alignment:  Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        //borderRadius: BorderRadius.circular(24.0),
                        gradient: LinearGradient(colors: [Colors.teal,Colors.teal.shade400,])
                    ),
                    child: Text('Sign Up',style: TextStyle(color: Colors.white,
                        fontSize: 19),),),
                ),
                /*SizedBox(height:  8,),
                Container(
                  alignment:  Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.0),
                      gradient: LinearGradient(colors: [Colors.lightGreen,Colors.amberAccent.shade200,Colors.redAccent.shade200,Colors.amberAccent.shade200,Colors.lightGreen,])
                  ),
                  child: Text('Sign Up with Google',style: TextStyle(color: Colors.white,
                      fontSize: 19),),),*/
                SizedBox(height: 16,),
                Row(mainAxisAlignment:MainAxisAlignment.center,
                    children:[
                      Text("Already have an account? ", style: mediumTextStyle(),),
                      GestureDetector(      /*SIGN IN*/
                        onTap: (){
                          widget.toggle();
                          },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text("Sign In", style: TextStyle(color: Colors.black,
                              fontSize: 14,
                              decoration: TextDecoration.underline)),
                        ),
                      )]),
                SizedBox(height: 50,)],
            ),
          ),
        ),
      ),
    );
  }
}

Future<bool> checkUsername(String username) async {
  var n = await FirebaseFirestore.instance.collection("Users").get();
  for(int i =0;i<n.docs.length;i++){
    if(n.docs[i].get('Username').toString().compareTo(username)==0){
        return true;
        //print("username taken $usernameTaken");
    }
  }
  return false;
}