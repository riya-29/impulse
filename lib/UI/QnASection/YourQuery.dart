import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:impulse/UI/QnASection/AnswerPage.dart';
import 'package:impulse/UI/QnASection/AskQuestion.dart';
import 'package:impulse/UI/QnASection/ViewUserProfile.dart';
import 'package:impulse/UI/dashboard.dart';
import 'package:impulse/helper/constants.dart';

class YourQuery extends StatefulWidget{
  @override
  _YourQueryState createState() => _YourQueryState();
}

class _YourQueryState extends State<YourQuery> {
  List<String> question=[];
  List<String> qImage=[];
  List<dynamic> time=[];
  List<String> askedBy=[];

  @override
  void initState() {
    getQuestions();
    super.initState();
  }

  getQuestions() async {
    int len;
    var ref = await FirebaseFirestore.instance.collection('AskedQuestions').orderBy("Time",descending: true).get();
    len = ref.docs.length;
    for(int i=0;i<len;i++) {
        if ( (ref.docs[i].get('AskedBy').toString().compareTo(Constants.myEmail)==0)&&ref.docs[i].get('Subject').toString().compareTo("Post")!=0) {
          String a = ref.docs[i].get('Question');
          String b = ref.docs[i].get('QImage');
          var c = ref.docs[i].get('Time');
          String d = ref.docs[i].get('AskedBy');
          setState(() {
            question.add(a);
            qImage.add(b);
            time.add(c);
            askedBy.add(d);
          });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.teal,title: Text("Queries"),titleTextStyle: TextStyle(fontWeight: FontWeight.bold),),
      drawer: NavDrawer(),
      backgroundColor: Colors.grey.shade50,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            GestureDetector(onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>AskQuestion()));
            },
              child: Container(padding: EdgeInsets.all(6),margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(border: Border.all(color: Colors.blueGrey.shade300,width: 1.5),
                      borderRadius: BorderRadius.all(Radius.circular(25))),
                  child: Row(mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(width: 20,),
                      Text(" Have a question? Ask...",style: TextStyle(color: Colors.grey,fontSize: 18),),
                      Spacer(),
                      Icon(Icons.camera_alt,size: 29,color: Colors.grey,),
                      SizedBox(width: 20,),
                    ],
                  )
              ),
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
          return UnansweredTile(time: time[index],question: question[index],qImage: qImage[index],email: askedBy[index],);
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
  UnansweredTile({this.time,this.question,this.qImage,this.email});
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
        u_name = documentSnapshot['Name'];
        u_username = documentSnapshot['Username'];
        u_image = documentSnapshot['ImageURL'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    getProfileData(widget.email);
    return GestureDetector(
      onLongPress: (){
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text('Delete Post'),
                actions: <Widget>[
                  new TextButton(
                    onPressed: () {
                      FirebaseFirestore.instance.collection("AskedQuestions").where("Question",isEqualTo: widget.question).where("QImage",isEqualTo:widget.qImage).get().then((snapshot) {
                        for (DocumentSnapshot doc in snapshot.docs) {
                          doc.reference.delete();
                        }
                      });
                      //delete post;
                  Navigator.of(context).pop();

                  },
                    // textColor: Colors.teal,
                    child: const Text('Yes',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),),
                  new TextButton(
                    onPressed: () {Navigator.of(context).pop();},
                    // textColor: Colors.teal,
                    child: const Text('No',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                  ),
                ],
            )
        );
      },
      child: Card(
        child: Container(padding: EdgeInsets.all(2),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment:MainAxisAlignment.end,children: [Text("${widget.time.split('.')[0]}",style: TextStyle(color: Colors.grey,fontSize: 14)),SizedBox(width: 15,)],),
              Row(children: [
                SizedBox(width: 3,),
                GestureDetector(onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>UserProfile(email: widget.email)));
                },child: CircleAvatar(backgroundColor:Colors.grey.shade50,
                  backgroundImage: u_image.isNotEmpty?NetworkImage(u_image):null,
                child: u_image.isEmpty?Icon(Icons.person,color: Colors.black87,size: 22,):null,)),
                SizedBox(width: 10,),
                Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                  Text("$u_name",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold)),
                  Text("@$u_username",style: TextStyle(color: Colors.blueGrey,fontSize: 15,)),
                ],),
              ],),
              SizedBox(height: 5,),
              Text("${widget.question}"),
              SizedBox(height: 5,),
              GestureDetector(onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>PhotoView(qImage: widget.qImage)));},
                child: Container(width:widget.qImage.isNotEmpty?MediaQuery.of(context).size.width-5:0,
                  height: widget.qImage.isNotEmpty?MediaQuery.of(context).size.width-5:0,
                  child: widget.qImage.isNotEmpty?Image.network("${widget.qImage}",fit: BoxFit.cover,):Container(),),
              ),
              Row(mainAxisAlignment:MainAxisAlignment.start,children: [
                TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AnswersList(question: widget.question,qImage: widget.qImage,)));

                },
                    child: Text("View Answers",style: TextStyle(color: Colors.teal,fontSize: 15,fontWeight: FontWeight.bold,))
                ),Spacer(),
                TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AnswerPage(u_name: u_name,
                    u_username: u_username,
                    u_image:u_image,
                    question: widget.question,
                    qImage: widget.qImage,
                    time: widget.time,)));
                },
                    child: Text("Reply",style: TextStyle(color: Colors.teal,fontSize: 15,fontWeight: FontWeight.bold,))
                )
              ],)
            ],
          ),
        ),
      ),
    );
  }
}

class AnswersList extends StatefulWidget{
  final String question;
  final String qImage;
  AnswersList({this.question,this.qImage});
  @override
  _AnswersListState createState() => _AnswersListState();
}

class _AnswersListState extends State<AnswersList> {
  String q;
  String img;
  List<dynamic> answerString=[];
  int NoOfAns=0;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    getQuestion();
    super.initState();
  }

  getQuestion() async {
    int len;
    var ref = await FirebaseFirestore.instance.collection('AskedQuestions').orderBy('Time',descending: true).get();
    len = ref.docs.length;
    for(int i=0;i<len;i++) {
      //(ref.docs[i].get('AskedBy').toString().compareTo(Constants.myEmail)==0)&&
      if ((ref.docs[i].get('Question').toString().compareTo(widget.question)==0)&&(ref.docs[i].get('QImage').toString().compareTo(widget.qImage)==0)) {
        String a = ref.docs[i].get('Question');
        String b = ref.docs[i].get('QImage');
        // print(answerString[0]);
        // var c = ref.docs[i].get('Time');
        // String d = ref.docs[i].get('AskedBy');
        setState(() {
          q=a;
          img=b;
          answerString = ref.docs[i].get('Answer');
          NoOfAns= ref.docs[i].get('Answer').length;
        });
        setState(() {
          id = ref.docs[i].id;
          askBy = ref.docs[i].get('AskedBy');
          subject = ref.docs[i].get('Subject');

        });
      }
    }
  }
  String id="";
  String askBy="";
  String subject="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(title: Text("Replies")),
      floatingActionButton: (askBy.compareTo(Constants.myEmail)==0 && subject.compareTo("Post")!=0)?Container(
        child: FloatingActionButton.extended(
          onPressed: () async {
            FirebaseFirestore.instance.collection("AskedQuestions").doc(id).update({"Unanswered":true});
            final snackBar = SnackBar(content: Text("Discussion Closed"),backgroundColor: Colors.green,duration: Duration(milliseconds: 2500),);
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          label: Text("Close Discussion"),
        ),
      ):Container(),
      body: Container(
        child: Column(
          children: [
            /*Container(
              child: Column(
                children: [
                  SizedBox(height: 5,),
                  Row(mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 10,),
                      Text('Question',style: TextStyle(fontSize: 20,color: Colors.red,fontWeight: FontWeight.bold),),
                    ],
                  ),
                  Container(padding: EdgeInsets.all(4),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5,),
                        Text("${widget.question}",style: TextStyle(fontSize: 18),),
                        SizedBox(height: 5,),
                        GestureDetector(onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>PhotoView(qImage: widget.qImage)));},
                          child: Container(width:widget.qImage.isNotEmpty?MediaQuery.of(context).size.width-5:0,
                            height: widget.qImage.isNotEmpty?MediaQuery.of(context).size.width-5:0,
                            child: widget.qImage.isNotEmpty?Image.network("${widget.qImage}",fit: BoxFit.cover,):Container(),),
                        ),],
                    ),
                  ),
                  SizedBox(height: 5,),
                  Row(mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 10,),
                      Text('Answers...',style: TextStyle(fontSize: 20,color: Colors.red,fontWeight: FontWeight.bold),),
                    ],
                  ),
                  Divider(),
                ],
              ),
            ),*/
            SizedBox(height: 5,),
            NoOfAns==0?Container(height:MediaQuery.of(context).size.height/2-60,alignment:Alignment.bottomCenter,child: Text("No Replies Yet ◔_◔",style: TextStyle(fontSize: 27,color: Colors.blueGrey,fontStyle: FontStyle.italic),))
                :answeredList(),

          ],
        ),
      ),
    );
  }

  answeredList() {
    return Container(
      child: Expanded(
        child: ListView.builder(itemCount: NoOfAns,itemBuilder: (context,index){
          return AnsweredTile(question:q,qImage: img,answerString: answerString[index].toString(),);
        }),
      ),
    );
  }
}

class AnsweredTile extends StatefulWidget{
  final String question;
  final String qImage;
  final String answerString;
  AnsweredTile({this.question,this.qImage,this.answerString});
  @override
  _AnsweredTileState createState() => _AnsweredTileState();
}

class _AnsweredTileState extends State<AnsweredTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(padding: EdgeInsets.all(2),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Row(children: [
                  SizedBox(width: 3,),
                  CircleAvatar(backgroundColor:Colors.grey.shade50,
                    backgroundImage: widget.answerString.split('|')[4].isNotEmpty?NetworkImage(widget.answerString.split('|')[4]):null,
                    child: (widget.answerString.split('|')[4]).isEmpty?Icon(Icons.person,color: Colors.black87,size: 22,):null,
                  ),
                  SizedBox(width: 10,),
                  Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                    Text("${widget.answerString.split('|')[2]}",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold)),
                    Text("@${widget.answerString.split('|')[3]}",style: TextStyle(color: Colors.blueGrey,fontSize: 15,)),
                  ],),
                ],),
                Spacer(),
                /*IconButton(onPressed: (){
                  //delete answer
                 }, icon: Icon(Icons.delete_rounded,color: Colors.red,))*/
              ],
            ),
            SizedBox(height: 7,),
            Padding(
              padding: const EdgeInsets.only(left: 8.0,right: 5),
              child: Text("${widget.answerString.split('|')[0]}",style: TextStyle(fontSize: 17,)),
            ),
            SizedBox(height: 5,),
            GestureDetector(onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>PhotoView(qImage: widget.answerString.split('|')[1])));},
              child: Container(width:widget.answerString.split('|')[1].isNotEmpty?MediaQuery.of(context).size.width-5:0,
                height: widget.answerString.split('|')[1].isNotEmpty?MediaQuery.of(context).size.width-5:0,
                child: widget.answerString.split('|')[1].isNotEmpty?Image.network("${widget.answerString.split('|')[1]}",fit: BoxFit.cover,):Container(),),
            ),
            Divider(),
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