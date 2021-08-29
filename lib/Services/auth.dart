import 'package:flutter/material.dart';
import 'package:impulse/Model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:impulse/UI/GlobalVars.dart';

class AuthMethod{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User_Firebase _userFromFirebaseUser(User user){
    return user!=null? User_Firebase(UserId: user.uid):null;
  }

  Future signInWithEmailAndPassword(String email, String password,BuildContext context) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email,password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e){
      Err=e.toString().split(']').removeLast();
      print("Error:${Err.split(']').removeLast()}");
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e){
      Err=e.toString().split(']').removeLast();
      print(e.toString());
    }
  }

  Future resetPassword(String email) async {
    try{
      return await _auth.sendPasswordResetEmail(email: email);
    }catch(e){
      print(e.toString());
    }
  }

  Future signOut() async {
    return await _auth.signOut();
  }
}