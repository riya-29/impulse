import 'dart:io';
import 'package:bordered_text/bordered_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:impulse/UI/QuizSection/Database/Services.dart';
import 'package:impulse/helper/constants.dart';
import 'package:intl/intl.dart';
import 'Database/Var.dart';
import 'QuizScreen.dart';
import 'dart:math' as math;

class Result extends StatefulWidget{
  _Result createState() =>_Result();
}

class _Result extends State<Result> with SingleTickerProviderStateMixin{

  @override
  void initState() {
    uploadPoints();
    super.initState();
  }
  uploadPoints() async {
    var ref = await FirebaseFirestore.instance.collection('Quiz').doc('${Constants.myEmail}').get();
    try {
      points = ref.get('Points')+points;
      timeTaken = ref.get('Time')+timeTaken;
    } catch (e) {
      points = points;
      timeTaken = timeTaken;
    }
    Map<String,dynamic> data={"Points":points,"Time":timeTaken,"Email":Constants.myEmail};
    try {
      FirebaseFirestore.instance.collection('Quiz').doc("${Constants.myEmail}").set(data);
    } on Exception catch (e) {
      FirebaseFirestore.instance.collection('Quiz').doc("${Constants.myEmail}").update(data);
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigoAccent,
      body: Column(
        children: [
          Spacer(),
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.celebration_rounded,size: 90,color: Colors.amber.shade600,),
              Icon(Icons.celebration_rounded,size: 90,color: Colors.redAccent,),
              Icon(Icons.celebration_rounded,size: 90,color: Colors.amber.shade600,),
            ],
          ),
          Center(
            child: Container(
              height: 450,
              width: 300,
              child:Center(child:
                Column(mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      BorderedText(strokeColor:Colors.white10,strokeWidth: 6,
                          child: Text("You won $points points !!",style: TextStyle(color: Colors.white,fontSize: 28,),)),
                      SizedBox(height: 15,),
                      BorderedText(strokeColor:Colors.white10,strokeWidth: 6,
                          child: Text("Time Taken: ${timeTaken}s",style: TextStyle(color: Colors.white,fontSize: 28,),)),
                      SizedBox(height: 15,),
                      FlatButton(onPressed: (){
                        addIntToSF();
                        assignQuizVariables();
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>QuizScreen()));
                      },
                        child: Container(
                        width: 160,
                        height:60,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.indigo,width: 5),
                                borderRadius: BorderRadius.circular(15),
                                shape: BoxShape.rectangle,
                                color: Colors.indigo),
                        child: Center(child:
                        BorderedText(strokeColor:Colors.black38,strokeWidth: 8,
                            child: Text("Play Again",style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),))
                        )),
                      ),
                      SizedBox(height: 10,),
            ]),),),
          ),
          Transform.rotate(
              angle: 270 * math.pi / 180,
              child: Icon(Icons.double_arrow,size: 30,color: Colors.white,)),
          GestureDetector(onLongPressUp: (){
            //print("hi");
            addIntToSF();
            assignQuizVariables();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Leaderboard()));
          },
            child: Container(
                width: 200,
                height:60,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.indigoAccent,width: 5),
                    borderRadius: BorderRadius.circular(15),
                    shape: BoxShape.rectangle,
                    color: Colors.indigoAccent),
                child: Center(child:
                  BorderedText(strokeColor:Colors.white,strokeWidth: 7,
                    child: Text("Leaderboard",style: TextStyle(color: Colors.amber.shade800,fontSize: 25,fontWeight: FontWeight.bold),))
                )),
          ),
        ],
      ),
    );
  }
}


class Leaderboard extends StatefulWidget{
  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  Stream stream;
  @override
  void initState() {
    getPoints();
    super.initState();
  }
  getPoints(){
    setState(() {
      stream = FirebaseFirestore.instance.collection('Quiz').orderBy("Points",descending: true).snapshots();
    });
    print(stream);
  }
  // DateFormat format = DateFormat(DateFormat.MONTH);
  String formatDate(DateTime date) => new DateFormat("MMMM").format(date);

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 20,),
          Stack(
            children: [
              Container(height: 100,width: MediaQuery.of(context).size.width,
                child: Image.asset('asset/images/leaderboard.png',fit: BoxFit.cover,),),
              Container(padding:EdgeInsets.only(top: 60),
                child: Center(child: Column(children: [
                  Card(
                    child: Column(
                      children: [
                        Container(decoration: BoxDecoration(color:Colors.indigoAccent,borderRadius: BorderRadius.only(topLeft:Radius.circular(3),topRight: Radius.circular(3))),
                            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                            child: Text(formatDate(DateTime.now()),style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold),)),
                        Container(decoration: BoxDecoration(color:Colors.white,borderRadius: BorderRadius.only(topLeft:Radius.circular(12),topRight: Radius.circular(12))),
                            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                            child: Text(DateTime.now().day.toString(),style: TextStyle(color: Colors.black,fontSize: 20),)),
                      ],
                    ),
                  ),
                ],),),
              ),
            ],
          ),
          Container(color: Colors.grey.shade50,padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
              SizedBox(width: 20,),
              Container(width:95,child: Text("Rank",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),)),
              Container(width:130,child: Text("Name",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),)),
              Spacer(),
              Container(width:60,child: Text("Points",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),)),
              SizedBox(width: 20,)
            ],),
          ),
          boardList(),
        ],
      ),
    );
  }

  Widget boardList(){
    return Expanded(
      child: StreamBuilder(stream: stream,builder: (context,snapshot){
        return snapshot.hasData?ListView.builder(itemCount: snapshot.data.docs.length,itemBuilder: (context,index){
          return LeaderBoardCard(index: index,
                                points: snapshot.data.docs[index].get("Points"),
                                email: snapshot.data.docs[index].get("Email"));
      }):Container();}),
    );
  }


}

class LeaderBoardCard extends StatefulWidget{
  final int index;
  final int points;
  final String email;
  LeaderBoardCard({this.index,this.points,this.email});

  @override
  _LeaderBoardCardState createState() => _LeaderBoardCardState();
}

class _LeaderBoardCardState extends State<LeaderBoardCard> {
  String username="";

  getUsername(String email) async {
    int docId=0;
    var ref = await FirebaseFirestore.instance.collection('Users').get();
    for(int i=0;i<ref.docs.length;i++) {
      if(ref.docs[i].get('Email').toString().compareTo(email)==0){
        docId = i;
        break;
      }
    }
    if(this.mounted){
      setState(() {
        username = ref.docs[docId].get('Username');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    getUsername(widget.email);
    return Container(padding: EdgeInsets.all(7),
      color: Constants.myEmail.compareTo(widget.email)==0?Colors.green:Colors.transparent,
      child: Row(mainAxisAlignment: MainAxisAlignment.start,children: [
        SizedBox(width: 10,),
        Container(width:100,child: Text("#${widget.index+1}",style: TextStyle(color: Constants.myEmail.compareTo(widget.email)==0?Colors.white:Colors.black,fontSize: 18,fontWeight: FontWeight.bold),)),
        Container(width:130,child: Column(crossAxisAlignment:CrossAxisAlignment.start,children: [Text("@$username",style: TextStyle(color: Constants.myEmail.compareTo(widget.email)==0?Colors.white:Colors.black,fontSize: 18,fontWeight: FontWeight.normal),),],)),
        Spacer(),
        Container(width:60,child: Column(children: [Text("${widget.points}",style: TextStyle(color: Constants.myEmail.compareTo(widget.email)==0?Colors.white:Colors.black87,fontSize: 18,fontWeight: FontWeight.normal),),],)),
        SizedBox(width: 20,)
      ],),
    );
  }
}
