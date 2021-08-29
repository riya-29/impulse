import 'package:flutter/material.dart';
import 'package:impulse/UI/SignIn.dart';
import 'package:impulse/UI/SignUp.dart';

class Authenticate extends StatefulWidget{
  _AuthenticateState createState()=> _AuthenticateState();
}
bool showSignIn = true;
class _AuthenticateState extends State<Authenticate>{

  void toggleView(){
    setState(() {
      showSignIn = !showSignIn;
    });
  }
  @override
  Widget build(BuildContext context) {
     if(showSignIn){
       /*bool key;
       HelperFunction.getUserLoggedInSharedPreference().then((value) => {key=value});
       print("LOGINKEY $key");
       try {
         if(key!=null){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home_Page()));}
       } on Exception catch (e) {
         // TODO
       }*/
       return Sign_In(toggleView);
     }else{
       return Sign_Up(toggleView);
     }
  }
}