import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:impulse/UI/QuizSection/Database/Services.dart';
import 'package:impulse/UI/QuizSection/QuizScreen.dart';
import 'Database/Var.dart';
import 'Widget.dart';

class Quiz_Dashboard extends StatefulWidget{
  Quiz_DashboardState createState() => Quiz_DashboardState();
}

class Quiz_DashboardState extends State<Quiz_Dashboard>{

  @override
  void initState() {
    Q_counter=1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double heightWidth = MediaQuery.of(context).size.width/2-30;
    return Scaffold(
      appBar: AppBar(title:Text("Quizzes"),backgroundColor: Colors.blueAccent,),
      backgroundColor: Colors.blueAccent.shade100,

      body: SingleChildScrollView(padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(onTap:(){ subject="GK INDIA";
                    get_Question();
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>QuizScreen()));},
                    child: dashboardContainer("GK INDIA",heightWidth,'asset/images/gkindia.png')),  //GK INDIA
                Spacer(),
                GestureDetector(onTap:(){ subject="GK WORLD";
                    get_Question();
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>QuizScreen()));},
                    child: dashboardContainer("GK WORLD",heightWidth,'asset/images/gkworld.png')),  //GK WORLD
              ],
            ),
            SizedBox(height: 15,),
            Row(
              children: [
                GestureDetector(onTap:(){ subject="SCIENCE";
                    get_Question();
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>QuizScreen()));},
                    child: dashboardContainer("SCIENCE",heightWidth,'asset/images/science.png')),  //SCIENCE
                Spacer(),
                GestureDetector(onTap:(){ subject="MATHEMATICS";
                    get_Question();
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>QuizScreen()));},
                    child: dashboardContainer("MATHEMATICS",heightWidth,'asset/images/math.png')),  //MATHEMATICS
              ],
            ),
            SizedBox(height: 15,),
            Row(
              children: [
                GestureDetector(onTap:(){ subject="REASONING";
                    get_Question();
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>QuizScreen()));},
                    child: dashboardContainer("REASONING",heightWidth,'asset/images/logical.png')),  //LOGICAL REASONING
                Spacer(),
                GestureDetector(onTap:(){ subject="ENGLISH";
                    get_Question();
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>QuizScreen()));},
                    child: dashboardContainer("ENGLISH",heightWidth,'asset/images/english.png')),  //ENGLISH
              ],
            ),
            SizedBox(height: 15,),
            Row(
              children: [
                GestureDetector(onTap:(){ subject="COMPUTER";
                    get_Question();
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>QuizScreen()));},
                    child: dashboardContainer("COMPUTER",heightWidth,'asset/images/cs.png')),  //COMPUTER SCIENCE
                Spacer(),
                GestureDetector(onTap:(){ subject="RANDOM QUIZ";
                    get_Question();
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>QuizScreen()));},
                    child: dashboardContainer("RANDOM QUIZ",heightWidth,"asset/images/random.png")),  //-
              ],
            ),
            SizedBox(height: 15,),
            Row(
              children: [
                //dashboardContainer("Subject 5",heightWidth,''),  //-
                Spacer(),
                //dashboardContainer("Subject 6",heightWidth,''),  //-
              ],
            )
          ],
        ),
      ),
    );
  }

}

List<dynamic> subjectList = ["GK WORLD","SCIENCE","MATHEMATICS","ENGLISH","COMPUTER","RANDOM QUIZ","GK INDIA"];

List<dynamic> quizDashes = [
  customizedDashContainer("GK WORLD",120,160,'asset/images/gkworld.png'),
  customizedDashContainer("SCIENCE",120,160,'asset/images/science.png'),
  customizedDashContainer("MATHEMATICS",120,160,'asset/images/math.png'),
  customizedDashContainer("ENGLISH",120,160,'asset/images/english.png'),
  customizedDashContainer("COMPUTER",120,160,'asset/images/cs.png'),
  customizedDashContainer("RANDOM QUIZ",120,160,'asset/images/random.png'),
  customizedDashContainer("GK INDIA",120,160,'asset/images/gkindia.png'),

];