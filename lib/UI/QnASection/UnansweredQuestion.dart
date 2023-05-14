import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:impulse/UI/QnASection/AnswerPage.dart';
import 'package:impulse/UI/QnASection/ViewUserProfile.dart';
import 'package:impulse/UI/dashboard.dart';
import 'package:impulse/helper/constants.dart';

import 'YourQuery.dart';

class UnansweredQuestion extends StatefulWidget{
  @override
  _UnansweredQuestionState createState() => _UnansweredQuestionState();
}

class _UnansweredQuestionState extends State<UnansweredQuestion> {
  List<dynamic> interest = [];
  List<String> question=[];
  List<String> qImage=[];
  List<dynamic> time=[];
  List<String> askedBy=[];
  List<String> unanswered=[];

  TextEditingController searchTEC = new TextEditingController();

  @override
  void initState() {
    getInterest();
    super.initState();
  }
  
  getInterest() async {
      int docId = 0;
      var ref = await FirebaseFirestore.instance.collection('Users').get();
      for (int i = 0; i < ref.docs.length; i++) {
        if (ref.docs[i].get('Email').toString().compareTo(Constants.myEmail) ==
            0) {
          docId = i;
          break;
        }
      }
      setState(() {
        interest = ref.docs[docId].get('Interest');
      });
    getQuestions();
  }
  getQuestions() async {
    int len;
      var ref = await FirebaseFirestore.instance.collection('AskedQuestions').orderBy("Time",descending: true).get();
      len = ref.docs.length;
      print(len);
    for(int i=0;i<len;i++) {
      for(int j =0;j<interest.length;j++){
        if ( (ref.docs[i].get('Subject').toString().contains(interest[j].toString()))
            && (ref.docs[i].get('Unanswered').toString().compareTo('false')==0)) {
          String a = ref.docs[i].get('Question');
          String b = ref.docs[i].get('QImage');
          var c = ref.docs[i].get('Time');
          String d = ref.docs[i].get('AskedBy');
          String e = ref.docs[i].get('Unanswered').toString();
          setState(() {
            question.add(a);
            qImage.add(b);
            time.add(c);
            askedBy.add(d);
            unanswered.add(e);
          });
        }
      }
    }
  }
  bool searchOn=false;

  searchQuestion() async {
    setState(() {
      question=[];
      qImage=[];
      time=[];
      askedBy=[];
      unanswered=[];
    });
    int len;
    var ref = await FirebaseFirestore.instance.collection('AskedQuestions').orderBy("Time",descending: true).get();
    len = ref.docs.length;
    for(int i=0;i<len;i++) {
      // for(int j =0;j<interest.length;j++){
        if ( (ref.docs[i].get('Question').toString().toLowerCase().contains(searchTEC.text.toLowerCase()))) {
          String a = ref.docs[i].get('Question');
          String b = ref.docs[i].get('QImage');
          var c = ref.docs[i].get('Time');
          String d = ref.docs[i].get('AskedBy');
          String e = ref.docs[i].get('Unanswered').toString();
          setState(() {
            question.add(a);
            qImage.add(b);
            time.add(c);
            askedBy.add(d);
            unanswered.add(e);
          });
        // }
      }
    }
    /*return Expanded(child: ListView.builder(itemCount: askedBy.length,itemBuilder: (context,index){
      return ;
    }));*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("Queries"),backgroundColor: Colors.teal,),
      drawer: NavDrawer(),
      backgroundColor: Colors.grey.shade50,
      bottomNavigationBar: homeBottomNavigationBar(context),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(width: 20,),
                  Container(width: MediaQuery.of(context).size.width/1.5+50,
                    child: TextFormField(
              controller: searchTEC,
              decoration: InputDecoration(
                hintText: "Search queries..."
              ),
            ),
                  ),
                  Spacer(),
                  GestureDetector(
                      onTap: (){
                    searchQuestion();
                    },child: Icon(Icons.search_rounded,size: 29,color: Colors.teal,)),
                  SizedBox(width: 20,),
                ],
              ),
            SizedBox(height: 10,),
            unansweredList(),
          ],
        ),
      ),
    );
  }

  unansweredList() {
    return Container(
      child: Expanded(
        child: ListView.builder(itemCount: askedBy.length,itemBuilder: (context,index){
          return UnansweredTile(time: time[index],question: question[index],qImage: qImage[index],email: askedBy[index],unanswered: unanswered[index],);
        }),
      ),
    );
  }
}

class UnansweredTile extends StatefulWidget{
  final String time;
  final String question;
  final String qImage;
  final String email;
  final String unanswered;

  UnansweredTile({this.time,this.question,this.qImage,this.email,this.unanswered});
  @override
  _UnansweredTileState createState() => _UnansweredTileState();
}

class _UnansweredTileState extends State<UnansweredTile> {
  String u_name="";
  String u_username="";
  String u_image="";
  getProfileData(String email) async {
    String docId="";
    var n = await FirebaseFirestore.instance.collection("Users").get();
    for(int i=0;i<n.docs.length;i++){
      if("$email".compareTo(n.docs[i].get('Email'))==0){
        docId=n.docs[i].id;
        break;
      }
    }
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection("Users").doc("$docId").get();
    if (this.mounted) {
      setState(() {
        u_name=documentSnapshot['Name'];
        u_username=documentSnapshot['Username'];
        u_image= documentSnapshot['ImageURL'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    getProfileData(widget.email);
    return Card(
      child: Container( padding: EdgeInsets.symmetric(vertical: 3),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment:MainAxisAlignment.end,children: [Text("${widget.time.split('.')[0].substring(0,widget.time.split('.')[0].length-3)}",style: TextStyle(color: Colors.grey,fontSize: 14)),SizedBox(width: 15,)],),
            Row(children: [
              SizedBox(width: 3,),
              GestureDetector(onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>UserProfile(email: widget.email)));
              },child: CircleAvatar(backgroundColor:Colors.grey.shade50,
                backgroundImage: u_image.isNotEmpty?NetworkImage(u_image):null,
              child: u_image.isEmpty?Icon(Icons.person,color: Colors.black87,size: 22,):null,
              )),
              SizedBox(width: 10,),
              Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                Text("$u_name",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold)),
                Text("@$u_username",style: TextStyle(color: Colors.blueGrey,fontSize: 15,)),
              ],),
            ],),
            SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text("${widget.question}"),
            ),
            SizedBox(height: 5,),
            GestureDetector(onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>PhotoView(qImage: widget.qImage)));},
              child: Container(width:widget.qImage.isNotEmpty?MediaQuery.of(context).size.width-5:0,
                        height: widget.qImage.isNotEmpty?MediaQuery.of(context).size.width-5:0,
                child: widget.qImage.isNotEmpty&&widget.qImage!=null?Image.network("${widget.qImage}",fit: BoxFit.cover,):Container(),),
            ),
            Row(mainAxisAlignment:MainAxisAlignment.start,children: [
              TextButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>AnswersList(question: widget.question,qImage: widget.qImage,)));

              },
                  child: Text("View Answers",style: TextStyle(color: Colors.teal,fontSize: 15,fontWeight: FontWeight.bold,))
              ),Spacer(),
              widget.unanswered.compareTo("false")==0?TextButton(onPressed: (){
                print(widget.unanswered);
                Navigator.push(context, MaterialPageRoute(builder: (context)=>AnswerPage(u_name: u_name,
                                                                                    u_username: u_username,
                                                                                    u_image:u_image,
                                                                                    question: widget.question,
                                                                                    qImage: widget.qImage,
                                                                                    time: widget.time,)));
              },
                  child: Text("Reply",style: TextStyle(color: Colors.teal,fontSize: 15,fontWeight: FontWeight.bold,))
              ):Text("")
            ],)
          ],
        ),
      ),
    );
  }
}

class PhotoView extends StatelessWidget{
  final String qImage;
  PhotoView({this.qImage});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(child: Container(
        child: qImage.isNotEmpty?Image.network("$qImage"):Container(),
      ),),
    );
  }
}