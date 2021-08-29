import'package:flutter/material.dart';
import'package:cloud_firestore/cloud_firestore.dart';
import 'package:auth_buttons/auth_buttons.dart';
import 'package:impulse/UI/users.dart';

import 'dashboard.dart';
final _firestore=FirebaseFirestore.instance;
class Google extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child:GoogleAuthButton(
          onPressed: (){
            signInWithGoogle().then((onvalue) {
              _firestore.collection('Users').doc(email)
                  .set({'Email': email, 'ImageURL': imageURL, 'Name': name});
            }).catchError((e){
              print(e);
            }).then((onvalue)
            {
              Navigator.push(context, MaterialPageRoute(builder:(context)=>DashboardPage()));
            }).catchError((e){print((e));});
          },)
    );



  }
}
