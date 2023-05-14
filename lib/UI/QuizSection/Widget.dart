import 'dart:io';
import 'package:flutter/material.dart';
import 'package:impulse/UI/QuizSection/Database/Services.dart';
import 'Database/Var.dart';
import 'QuizScreen.dart';
import 'ResultScreen.dart';

Container pointsContainer(String amt,int loc,BuildContext context){
  if(Q_counter==loc) {
    return Container( alignment:  Alignment.center,
      width: 35,
      height: 33,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black87,width: 3),
        color: Colors.white,
      ),
      child: Text(amt, style: TextStyle(
            color: Colors.black87, fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }else {
    return Container(
    alignment:  Alignment.center,
    width: 30,
    height: 28,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.black87,
    ),
    child: Text(amt,style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),);
  }
}

Container optionContainer(String option,double s){
  try {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      alignment:  Alignment.centerLeft,
      padding: EdgeInsets.all(7),
      width: (s/1.2), //MediaQuery.of(context).size.width
      height: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.0),
          color: Colors.white,
          ),

      child: Text("$option",style: TextStyle(color: Colors.blueGrey,fontSize: 18,fontWeight: FontWeight.bold),),);
  } on Exception {
    // TODO
  }
}

Container WrongContainer(String option,double s){
  timeTaken = timeTaken+(15-time);
  try {
    time=15;//Q_counter = 0;    //initializing to ZERO after wrong answer
    points = points-1;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      alignment:  Alignment.centerLeft,
      padding: EdgeInsets.all(7),
      width: (s/1.2), //MediaQuery.of(context).size.width
      height: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.0),
          color: Colors.red),
      child: Text("$option",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),);
  } on Exception {
    // TODO
  }
}

Container RightContainer(String option,double s){
  points = points+1;
  timeTaken = timeTaken+(15-time);
  time=15;
  try {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      alignment:  Alignment.centerLeft,
      padding: EdgeInsets.all(7),
      width: (s/1.2), //MediaQuery.of(context).size.width
      height: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.0),
          color: Colors.green),
      child: Text("$option",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),);
  } on Exception {
    //print("Catch ${e.toString()}");
  }
}

TextButton PointsTextButton(BuildContext context){
  sleep(Duration(milliseconds: 500));
  if(next==1){
    //print("RUN");
    addIntToSF();
    next=0;
    A = true;
    B = true;
    C = true;
    D = true;
    if(Q_counter!=0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>QuizScreen()));
      });
      /*}else if(Q_counter==0){
      addIntToSF();
      WidgetsBinding.instance.addPostFrameCallback((_) {

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Result()));
      });*/
    }else{
      //addIntToSF();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Result()));
      });
    }
  }
  return TextButton(onPressed:(){},child: Text("  Points: $points",style: TextStyle(color: Colors.grey.shade500,fontSize: 15),));
}

Widget dashboardContainer(String subject,double heightWidth,String image,){
    try {
      return Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        height: heightWidth,
        width: heightWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            image!=''?Image.asset("$image",
              height: heightWidth - 50,
              width: heightWidth - 50,
            ):Container(),
            Spacer(),
            Text("$subject",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
          ],
        ),
      );
    }catch (e) {
      //print("$e");
    }
}

Widget customizedDashboardContainer(String subject,double height,double width,String image,){
  try {
    return Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      height: height,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          image!=''?Image.asset("$image",
            height: height - 50,
            width: width - 50,
          ):SizedBox(height: 0,),
          Text("$subject",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
        ],
      ),
    );
  }catch (e) {
    //print("$e");
  }
}

Widget customizedDashContainer(String subject,double height,double width,String image,){
  try {
    return Container(padding: EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(5))),
      height: height,
      width: width+15,
      child: Stack(
        children: [
          image!=''?ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Image.asset(image,
        height: 120,
        width: 160,
        fit: BoxFit.cover,
      ),
    ):SizedBox(height: 0,),
          Container(
            alignment: Alignment.center,
            height: 120,
            width: 160,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.black26
            ),
            child: Text(
              subject,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }catch (e) {
    //print("$e");
  }
}