import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Var.dart';

Future<void> get_Question() async {
  try {
    DocumentSnapshot documentSnapshot;
    documentSnapshot = await FirebaseFirestore.instance.collection('Questions').doc('$subject').get();
    Map<dynamic,dynamic> QMap=documentSnapshot.get("$subject");
    Q_total = QMap.keys.length;
    int No = ((Question_No%Q_total));
    // print(QMap.values.elementAt(No));
    // print("No $No");
    question=QMap.keys.elementAt(No);
    print(question);
    List<dynamic> op = QMap.values.elementAt(No); //options list
    options.insert(0, op[0].trim());
    options.insert(1, op[1].trim());
    options.insert(2, op[2].trim());
    options.insert(3, op[3].trim());
    options.removeRange(4, options.length);
    Question_No++;
  } catch (e) {
    //print("CATCH here $e");
  }
}

/*https://medium.com/flutterdevs/using-sharedpreferences-in-flutter-251755f07127*/

addIntToSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('Q_key', Question_No);
  //bool CheckValue = prefs.containsKey('value');
  //print("Q_key: ${prefs.getInt('Q_key')} bool:$CheckValue");
}       //Store Question no in shared preferences

getIntValuesSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return int
  int Q_key = prefs.getInt('Q_key');
  //print("Q_key: $Q_key");
  if(Q_key==null){ Question_No=1; }
  else{ Question_No = Q_key; }
}   //to get Question no from shared preferences

assignQuizVariables()  {
  getIntValuesSF();  //to assign the Question_No with value to continue from last question
  time=15;
  timeTaken=0;
  Q_counter=1;
  points = 0;
  get_Question();
}       //Assign all Quiz variables before new quiz starts