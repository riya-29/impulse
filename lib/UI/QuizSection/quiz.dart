import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Database/Services.dart';
import 'Database/Var.dart';
import 'QuizScreen.dart';
class Quiz extends StatefulWidget {
  @override
  _QuizState createState() => _QuizState();
}
class _QuizState extends State<Quiz> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body:SingleChildScrollView(
          child: Container(
            width: double.infinity,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              Text("  Quizzes Archive",
              style:TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black
              )),
              SizedBox(height: 8,),
              Text("  Challenge yourself! Take the quiz and check your score!",
                  style:TextStyle(
                      fontSize: 14,
                      color: Colors.black
                  )),
              SizedBox(height: 20,),
              quizCard("asset/images/gk.jpg", "General Knowledge Quiz","GK WORLD"),
              SizedBox(height: 10,),
              quizCardNetwork("https://leverageedu.com/blog/wp-content/uploads/2020/05/English-Quiz.png", "English", "ENGLISH"),
              SizedBox(height: 10,),
              quizCard("asset/images/math.png", "Mathematics","MATHEMATICS"),
              SizedBox(height: 10,),
              quizCard("asset/images/cs.png", "General Computer Quiz","COMPUTER"),
              SizedBox(height: 10,),
              quizCard("asset/images/simple science.jpg", "Basic Science","SCIENCE"),
              SizedBox(height: 10,),
              quizCard("asset/images/verbal.png", "Verbal Aptitude and Reasoning","REASONING"),
              SizedBox(height: 10,),
              quizCard("asset/images/random.png", "Random Subjects Quiz","RANDOM QUIZ"),
            ]
      ),
    ),
    )
    );
  }

  Widget quizCard(String image,String subjectText,String sub){
    return Card(
      elevation: 7,
      shadowColor: Colors.indigo,
      child: InkWell(
        splashColor: Colors.teal,
        onTap: (){
          subject = sub;
          print("in");
          get_Question();
          Navigator.push(context,MaterialPageRoute(builder: (context)=>QuizScreen()));
        },
        child: Column(
          children: [
            SizedBox(height: 10,),
            Container(height: MediaQuery.of(context).size.width-120,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(image,fit: BoxFit.fill,
              ),
            ),
            SizedBox(height:10),
            Text(subjectText,
                style:TextStyle(
                  fontWeight:FontWeight.bold,
                  fontSize: 18,
                )),
            SizedBox(height: 10,),
            ],
        ),
      ),
    );
  }

  Widget quizCardNetwork(String image,String subjectText,String sub){
    return Card(
      elevation: 7,
      shadowColor: Colors.indigo,
      child: InkWell(
        splashColor: Colors.teal,
        onTap: (){
          subject = sub;
          print(subject);
          get_Question();
          Navigator.push(context,MaterialPageRoute(builder: (context)=>QuizScreen()));
        },
        child: Column(
          children: [
            SizedBox(height: 10,),
            Container(height: MediaQuery.of(context).size.width-120,
              width: MediaQuery.of(context).size.width,
              child: Image.network(image,fit: BoxFit.fill,
              ),
            ),
            SizedBox(height:10),
            Text(subjectText,
                style:TextStyle(
                  fontWeight:FontWeight.bold,
                  fontSize: 18,
                )),
            SizedBox(height: 10,),
            ],
        ),
      ),
    );
  }
}
