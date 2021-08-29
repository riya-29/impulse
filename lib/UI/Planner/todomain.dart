import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'ToDolist.dart';
import 'loading.dart';

class MyToDo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(child: Text(snapshot.error.toString())),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          }
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: ToDoList(),
              theme: ThemeData(
                scaffoldBackgroundColor: Colors.white,
                primarySwatch: Colors.teal,)
          );
        }
    );
  }
}
