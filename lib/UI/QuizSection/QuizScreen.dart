import 'dart:async';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:impulse/UI/QuizSection/ResultScreen.dart';
import 'Database/Services.dart';
import 'Database/Var.dart';
import 'Widget.dart';

class QuizScreen extends StatefulWidget{
  _QuizScreenState createState()=> _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>{

  //DatabaseMethods databaseMethods = new DatabaseMethods();
  String _ans ="";
  int audienceA=0;
  int audienceB=0;
  int audienceC=0;
  Timer _timer;

  Container ChangeColorA;
  Container ChangeColorB;
  Container ChangeColorC;
  Container ChangeColorD;

  @override
  void initState() {
    startTimer();
        super.initState();
  }

  void startTimer() {
    _timer = new Timer.periodic( Duration(seconds: 1),(Timer timer)   //Function
      {
        if (time == 0) {
          setState(() { timer.cancel();
            if(Q_counter==10){  Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>Result()));
            }else{
            Q_counter++;
            get_Question();
            time=15;
            addIntToSF();
            // points--;
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context)=>QuizScreen()));
            } });//setState
            }else {
              setState((){ time--; });
            }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        appBar: AppBar(title: Text("Quiz"),centerTitle: true,backgroundColor: Colors.indigoAccent,),
          backgroundColor: Colors.indigoAccent,
          body: SingleChildScrollView(scrollDirection: Axis.vertical,primary: true,
            child: Column(
                children: [
                  SizedBox(height: 15,),
                  DottedBorder(
                    borderType: BorderType.Circle,
                    strokeWidth: 4,
                    strokeCap: StrokeCap.round,
                    dashPattern: [2, 6],
                    color: Colors.indigo.shade600,
                    child: Container( height: 40, width: 40,
                      decoration: BoxDecoration(
                        color: Colors.indigoAccent,
                        shape: BoxShape.circle,
                      ),
                      child: Center(child: Text("${time}s",style: TextStyle(color: Colors.white,fontSize:19,fontWeight: FontWeight.bold),)),
                      ),
                  ),
                  Container(        //  QUIZ CONTAINER
                    margin: EdgeInsets.fromLTRB(7,10,7,0),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height/1.5,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8), 
                      ),
                      child: SingleChildScrollView(scrollDirection: Axis.vertical,
                        child: Column(
                          children:[
                                SizedBox(height: 20,),
                                Container(padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                  // SizedBox(width: 3,),
                                  pointsContainer(winningPoints[1],1,context),
                                  pointsContainer(winningPoints[2],2,context),
                                  pointsContainer(winningPoints[3],3,context),
                                  pointsContainer(winningPoints[4],4,context),
                                  pointsContainer(winningPoints[5],5,context),
                                  pointsContainer(winningPoints[6],6,context),
                                  pointsContainer(winningPoints[7],7,context),
                                  pointsContainer(winningPoints[8],8,context),
                                  pointsContainer(winningPoints[9],9,context),
                                  pointsContainer(winningPoints[10],10,context),
                                ],
                              ),
                            ),
                                SizedBox(height: 15,),
                                Container(
                                  child: Column(
                                    //crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                          //alignment:  Alignment.center,
                                          padding: EdgeInsets.all(10.0),
                                          width: MediaQuery.of(context).size.width-30,
                                          /*decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(8.0),),*/
                                          child: Text("Q$Q_counter. $question",style: TextStyle(color: Colors.blueGrey,fontSize: 22,fontWeight: FontWeight.bold),),), //QUESTION
                                      SizedBox(height: 13,),
                                      GestureDetector(
                                          onTap:(){
                                            try {
                                              setState(() {
                                                  A =false;
                                                  if(checkAnswer(options[0]) == false){
                                                    //print("Wrong INSIDE A");
                                                    ChangeColorA =  WrongContainer("A: ${correctOption(options[0])}",MediaQuery.of(context).size.width);
                                                    if(Q_counter==10){
                                                      Q_counter=0;
                                                    }else{
                                                      Q_counter++;}
                                                  }else{
                                                    //print("Right INSIDE A");
                                                    ChangeColorA =  RightContainer("A: ${correctOption(options[0])}",MediaQuery.of(context).size.width);
                                                    if(Q_counter==10){
                                                      Q_counter=0;
                                                    }else{
                                                      Q_counter++;}
                                                  }
                                                  get_Question();
                                                  next=1;
                                                  //A=!A;

                                              });
                                            } on Exception catch (e) {
                                              //print("A: Error${e.toString()}");
                                            }},
                                              child: A?optionContainer("A: ${correctOption(options[0])}",MediaQuery.of(context).size.width):ChangeColorA),
                                      SizedBox(height: 5,),
                                      GestureDetector(onTap:(){
                                            setState(() {
                                              try {
                                                B = !B;
                                                if(checkAnswer(options[1]) == false){
                                                  ChangeColorB =  WrongContainer("B: ${correctOption(options[1])}",MediaQuery.of(context).size.width);
                                                  if(Q_counter==10){
                                                    Q_counter=0;
                                                  }else{
                                                    Q_counter++;}
                                                }else{
                                                  ChangeColorB =  RightContainer("B: ${correctOption(options[1])}",MediaQuery.of(context).size.width);
                                                  if(Q_counter==10){
                                                    Q_counter=0;
                                                  }else{
                                                    Q_counter++;}
                                                }
                                                get_Question();
                                                next=1;
                                                //B = !B;
                                              } on Exception catch (e) {
                                                //print("B: Error${e.toString()}");
                                              }
                                            });
                                            },
                                            child: B?optionContainer("B: ${correctOption(options[1])}",MediaQuery.of(context).size.width):ChangeColorB,),
                                      SizedBox(height: 5,),
                                      GestureDetector(onTap:(){
                                              setState(() {
                                                C = !C;
                                                if(checkAnswer(options[2]) == false){
                                                ChangeColorC = WrongContainer("C: ${correctOption(options[2])}",MediaQuery.of(context).size.width);
                                                if(Q_counter==10){
                                                  Q_counter=0;
                                                }else{
                                                  Q_counter++;}
                                                }else{
                                                ChangeColorC = RightContainer("C: ${correctOption(options[2])}",MediaQuery.of(context).size.width);
                                                if(Q_counter==10){
                                                  Q_counter=0;
                                                }else{
                                                  Q_counter++;}
                                                }
                                              });
                                              get_Question();
                                              next=1;
                                                //C = !C;
                                              },
                                            child: C?optionContainer("C: ${correctOption(options[2])}",MediaQuery.of(context).size.width):ChangeColorC,),
                                      SizedBox(height: 5,),
                                      GestureDetector(onTap:(){
                                            setState(() {
                                              D =!D;
                                              if(checkAnswer(options[3]) == false){
                                                ChangeColorD = WrongContainer("D: ${correctOption(options[3])}",MediaQuery.of(context).size.width);
                                                if(Q_counter==10){
                                                  Q_counter=0;
                                                }else{
                                                  Q_counter++;}
                                              }else{
                                                ChangeColorD = RightContainer("D: ${correctOption(options[3])}",MediaQuery.of(context).size.width);
                                                if(Q_counter==10){
                                                  Q_counter=0;
                                                }else{
                                                Q_counter++;}
                                              }
                                            });
                                            get_Question();
                                            next=1;
                                              //D =!D;
                                            },
                                            child: D?optionContainer("D: ${correctOption(options[3])}",MediaQuery.of(context).size.width):ChangeColorD,),
                                      SizedBox(height: 5,),
                                      Row(mainAxisAlignment: MainAxisAlignment.end,
                                        mainAxisSize: MainAxisSize.min,
                                        children:[
                                          PointsFlatButton(context),
                                          SizedBox(width: 140,),
                                          FlatButton(onPressed: (){if(Q_counter==10){
                                            Q_counter=0;
                                          }else{
                                            Q_counter++;}
                                          get_Question();
                                          time=15;
                                          next=1;
                                            }, child: Text("SKIP",style: TextStyle(color: Colors.indigoAccent,fontSize: 15),)),]
                                      ),
                                    ],),
                                ),
                          SizedBox(height: 15,)
                          ],),
                      ),
                  ),
                ],),
          ),
        );
    } finally {
      // TODO
    }
  }

  bool checkAnswer(String answer) {   //To check correct answer
    try{if(answer.startsWith('*')){
      return true;
    }else{
      return false;
    }}catch(e){}
  }

  String correctOption(String option){
    try {
      if(option.startsWith('*')){
        _ans = option.substring(1);
        return option.substring(1);
      } else{
        return option;
      }
    } on Exception catch (e) {
      // TODO
    }
  }       //To remove * from correct answer

  Widget _buildPopupDialog(BuildContext context,String message) {
    return new AlertDialog(
      title: Text('$message'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("$_ans"),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
        ),
      ],
    );
  }     //Pop-up Dialog

}