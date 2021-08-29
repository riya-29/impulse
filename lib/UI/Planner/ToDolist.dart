import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:impulse/Model/todo.dart';
import 'package:impulse/Services/database-1.dart';
import 'package:impulse/UI/Planner/Note.dart';
import 'package:impulse/helper/helperFunctions.dart';
import 'loading.dart';

class ToDoList extends StatefulWidget {
  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  int tab=0;
  String mail;
  bool isComplete=false;
  TextEditingController todoTitleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    HelperFunction.getUserEmailSharedPreference().then((val)=>mail=val);
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 27,),
              Container(color:Colors.grey.shade100,
                height: 50,
                child: TabBar(labelColor: Colors.black,
                  onTap: (index){
                  setState(() {
                    tab=index;
                  });
                  },
                  tabs: [
                    Tab(text: 'To-do',),
                    Tab(text: 'Notes',)
                  ],),),
              SizedBox(
                  height: MediaQuery.of(context).size.height-100,
                  child: TabBarView(
                    children: [
                      todoList(),
                      notesList()],)
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor:Theme.of(context).primaryColor,
          onPressed: (){
            if (tab==1) {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Note(title: "",)));
            }else{
              showDialog(
                  context: context,
                  builder:(BuildContext context)=>SimpleDialog(
                    contentPadding: EdgeInsets.symmetric(horizontal: 25,vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: Row(
                      children: [
                        Text("Add Tasks"),
                        Spacer(),
                        IconButton(onPressed:()=>{
                          Navigator.pop(context),
                        }, icon: Icon(Icons.cancel,color:Colors.black,
                            size:30))
                      ],
                    ),
                    children: [
                      Divider(),
                      TextFormField(
                          controller: todoTitleController,
                          style:TextStyle(
                            fontSize: 18,
                            height: 1.5,
                          ),
                          autofocus: true,
                          decoration:InputDecoration(hintText: "Task",
                            border: InputBorder.none,
                          )
                      ),
                      SizedBox(height: 24,),
                      SizedBox(
                        width:MediaQuery.of(context).size.width ,
                        height:50,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text("Add",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 19),),
                          color: Theme.of(context).primaryColor,
                          onPressed: () async{
                            if(todoTitleController.text.isNotEmpty){
                              await DatabaseService()
                                  .createNewTodo(todoTitleController.text.trim(),"$mail");
                              Navigator.pop(context);
                            }
                          },
                        ),
                      )],
                  )
              );
            }
          },
        ),
      ),
    );
  }

  todoList(){
    return SafeArea(
        child:StreamBuilder<List<Todo>>(
            stream: DatabaseService().listTodos(),
            builder: (context, snapshot) {
          if (!snapshot.hasData) {return Loading();}
          List<Todo> todos = snapshot.data;
          return Padding(padding: EdgeInsets.symmetric(horizontal: 5),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("All Tasks", style:TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold,)),
                Divider(),
                Expanded(
                  child: ListView.separated(separatorBuilder: (context, index) => Divider(height:0,color: Colors.white54,),
                      shrinkWrap:true,
                      itemCount: todos.length,
                      itemBuilder: (context,index)
                      {bool val;
                      todos[index].mail==mail?val=true:val=false;
                      return val&&todos[index].title.contains("::")==false?Dismissible(
                        key:Key(todos[index].title),
                        background: Container(
                            padding: EdgeInsets.only(left:20),
                            alignment:Alignment.centerLeft,
                            child:Icon(Icons.delete,),
                            color:Colors.redAccent
                        ),
                        onDismissed: (direction)async{
                          await DatabaseService()
                              .removeTodo(todos[index].uid);
                        },
                        child:ListTile(
                          onTap: (){
                            DatabaseService().completTask(todos[index].uid,!todos[index].isComplete);
                          },
                          leading: Container(
                            height: 30,
                            width: 30,
                            padding: EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child:todos[index].isComplete
                                ? Icon(
                              Icons.check,
                              color: Colors.white,
                            )
                                : Container(),
                          ),
                          title: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(todos[index].title,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),),
                              Divider(),
                              Container(alignment: Alignment.centerRight,child: Text("${todos[index].time.split('.')[0].substring(0,todos[index].time.split('.')[0].length-3)}",style: TextStyle(color: Colors.blueGrey),))
                            ],
                          ),
                        ),
                      ):Text("");
                      }),
                )
              ],
            ),
          );
        }
        )
    );
  }

  notesList(){
    return SafeArea(
        child:StreamBuilder<List<Todo>>(
            stream: DatabaseService().listTodos(), builder: (context, snapshot) {
          if (!snapshot.hasData) {return Loading();}
          List<Todo> todos = snapshot.data;
          return Padding(padding: EdgeInsets.symmetric(horizontal: 0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.separated(separatorBuilder: (context, index) => Divider(height:0,color: Colors.white54,),
                      shrinkWrap:true,
                      itemCount: todos.length,
                      itemBuilder: (context,index)
                      {bool val;
                      todos[index].mail==mail?val=true:val=false;
                      return val&&todos[index].title.contains("::")==true?Dismissible(
                        key:Key(todos[index].title),
                        background: Container(
                            padding: EdgeInsets.only(left:20),
                            alignment:Alignment.centerLeft,
                            child:Icon(Icons.delete,),
                            color:Colors.redAccent
                        ),
                        onDismissed: (direction)async{
                          await DatabaseService()
                              .removeTodo(todos[index].uid);
                        },
                        child:GestureDetector(
                          onTap: (){
                            if (todos[index].title.contains("::")) {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>Note(title: todos[index].title,)));
                            }
                          },
                          child: Card(color:Colors.blueGrey.shade50,
                            child: Container(padding: EdgeInsets.symmetric(horizontal: 7,vertical: 5),
                              height: 80,width: MediaQuery.of(context).size.width,
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(todos[index].title.split("::")[0],
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),),
                                  ),
                                  Divider(),
                                  Container(alignment: Alignment.centerRight,child: Text("${todos[index].time.split('.')[0].substring(0,todos[index].time.split('.')[0].length-3)}",style: TextStyle(color: Colors.blueGrey),))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ):Container();
                      }),
                )
              ],
            ),
          );
        }
        )
    );
  }
}



//

//to do
