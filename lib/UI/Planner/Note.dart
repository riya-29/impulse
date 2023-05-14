import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:impulse/Services/database-1.dart';
import 'package:impulse/helper/constants.dart';

class Note extends StatefulWidget{
  final String title;
  Note({this.title});

  @override
  _NoteState createState() => _NoteState();
}

class _NoteState extends State<Note> {
  TextEditingController TTEC = new TextEditingController();

  TextEditingController TextTEC = new TextEditingController();
  bool newNote =true;
  @override
  void initState() {
    newNote = (widget.title)=="";
    if (widget.title.isNotEmpty) {
      TTEC.text="${widget.title.split("::")[0]}";
      TextTEC.text="${widget.title.split("::")[1]}";
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("Notes"),
      actions: [IconButton(
          onPressed: () async{
            String s = TTEC.text + "::" + TextTEC.text;
            if (newNote) {
              if(s.isNotEmpty){
                await DatabaseService()
                    .createNewTodo(s,"${Constants.myEmail}");
                // Navigator.pop(context);
              }
            }else{
              var n = await FirebaseFirestore.instance.collection("Todos").where("title",isEqualTo: widget.title).get();
              String docId=n.docs[0].id;
              await FirebaseFirestore.instance.collection("Todos").doc(docId).update({"title":s});
            }
          },
          icon: Icon(Icons.save_rounded))],),
      body: Card(
        color:Colors.blueGrey.shade50,
        child: Container(padding: EdgeInsets.all(5),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(children: [
              Container(
                child: TextField(controller: TTEC,
                  decoration: InputDecoration(
                    hintText: "Title Here",
                    focusedBorder: InputBorder.none,
                    border: InputBorder.none
                  ),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),),
              ),
              Divider(),
              Container(
                child: TextFormField(controller: TextTEC,maxLines: 80,
                  decoration: InputDecoration(
                      hintText: "Text Here",
                      focusedBorder: InputBorder.none,
                      border: InputBorder.none
                  ),
                  style: TextStyle(

                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ],),
          ),
        ),
      ),
    );
  }
}