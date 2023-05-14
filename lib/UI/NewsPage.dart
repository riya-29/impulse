import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class News_Page extends StatefulWidget{
  News_PageState createState()=>News_PageState();
}
String Nsubject="TRENDING";
class News_PageState extends State<News_Page>{
  var data;
  Stream newsStream;
  List<String> time;
  List<String> location = new List<String>();
  List<String> headline = new List<String>();
  List<String> description = new List<String>();

  int c=1;

  getNews() async{
    var n =FirebaseFirestore.instance.collection("News",).doc("$Nsubject");
    newsStream = n.snapshots();
    var newElement = await FirebaseFirestore.instance.collection("News").doc("$Nsubject").get();
    setState(() {
      data = newElement.data();
      var t = data.keys.toString();
      time = t.substring(1,t.length-1).split(',');
      location = data.values.toString().split('{');
    });
  }

  @override
  void initState() {
    getNews();
    super.initState();
  }

  Widget NewsListTile(){
    return StreamBuilder(stream: newsStream,builder: (context,snapshot){
      return snapshot.hasData? ListView.builder(itemCount: time.length,
        itemBuilder: (BuildContext context,index){
          int len= location.elementAt(index+1).split(':')[1].toString().length;
                    return singleNewsTile(time[index],      //time
                        location.elementAt(index+1).split(':')[0],    //location
                        location.elementAt(index+1).split(':')[1].toString().substring(2, len - 3).toString().split(',')[0],    //headline
                        location.elementAt(index+1).split(':')[1].toString().substring(2, len - 4).toString().split(',')[1]);   //short description
        }):Container();});
  }

  Widget singleNewsTile(String sub,String Location,String headline,String description){
    return Card(margin: EdgeInsets.only(top: 10,left: 5,right: 5),
      child: Container(margin: EdgeInsets.only(top:0,left: 10,right: 10,bottom: 10),
        child:Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            Row(mainAxisAlignment:MainAxisAlignment.end,children: [
              Text("$sub",style: TextStyle(color: Colors.grey.shade500,fontSize: 16),),
            ],),
            Row(mainAxisAlignment:MainAxisAlignment.end,children: [
              Text("$Location",style: TextStyle(color: Colors.grey.shade500,fontSize: 15)),
            ],),
            Text("$headline",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 21)),
            Container(width: MediaQuery.of(context).size.width-40,padding: EdgeInsets.all(8),
                decoration:BoxDecoration(
                    color:Colors.grey.shade200,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child:SingleChildScrollView(child: Text("${description.trim()}",style: TextStyle(fontWeight: FontWeight.normal,fontSize: 19)))),
            SizedBox(height: 10,),
          ],),),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("$Nsubject NEWS"),backgroundColor: Colors.blueAccent,
        actions: [
          Padding(
            padding: EdgeInsets.all(4.0),
            child:Column(
                children: [
                  PopupMenuButton(
                    itemBuilder: (context)=>[
                      PopupMenuItem(
                        child:InkWell(
                          child:Text("TRENDING"),
                          onTap: (){
                            setState(() {
                              Nsubject="TRENDING";
                              Navigator.pop(context);
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>News_Page()));
                            });
                          },
                        ),
                      ),
                      PopupMenuItem(
                        child:
                        InkWell(
                          child:Text("POLITICAL"),
                          onTap: (){
                            setState(() {
                              Nsubject="POLITICAL";
                              Navigator.pop(context);
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>News_Page()));
                            });
                          },
                        ),
                      ),
                      PopupMenuItem(
                        child:
                        InkWell(
                          child:Text("SPORTS"),
                          onTap: (){
                            setState(() {
                              Nsubject="SPORTS";
                              Navigator.pop(context);
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>News_Page()));
                            });
                          },
                        ),
                      ),
                      PopupMenuItem(
                        child:
                        InkWell(
                          child:Text("TECHNOLOGY"),
                          onTap: (){
                            setState(() {
                              Nsubject="TECHNOLOGY";
                              Navigator.pop(context);
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>News_Page()));
                            });
                          },
                        ),
                      ),
                      PopupMenuItem(
                        child:
                        InkWell(
                          child:Text("HEALTH"),
                          onTap: (){
                            setState(() {
                              Nsubject="HEALTH";
                              Navigator.pop(context);
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>News_Page()));
                            });
                          },
                        ),
                      ),
                      PopupMenuItem(
                        child:
                        InkWell(
                          child:Text("BUSINESS"),
                          onTap: (){
                            setState(() {
                              Nsubject="BUSINESS";
                              Navigator.pop(context);
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>News_Page()));
                            });
                          },
                        ),
                      ),
                    ],),
                ]),
          )
        // },icon: Icon(Icons.filter_list_rounded))
      ],),
      backgroundColor: Colors.blueAccent.shade100,
      body:NewsListTile(),
    );
  }
}