import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:impulse/Services/database.dart';
import 'package:impulse/Widgets/widgets.dart';
import 'package:impulse/helper/constants.dart';


class SearchGroups extends StatefulWidget{
  @override
  _SearchGroupsState createState() =>_SearchGroupsState();
}

class _SearchGroupsState extends State<SearchGroups>{
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTEC = new TextEditingController();

  QuerySnapshot searchSnapshot;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  initiateSearch() async {
    databaseMethods.getGroupByGroupName(searchTEC.text).then((val){
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  @override
  void initState() {
    initiateSearch();
    super.initState();
  }

  Widget searchList(){
    return searchSnapshot!= null?ListView.builder(
        itemCount: searchSnapshot.docs.length,
        shrinkWrap: true,
        itemBuilder: (context,index){
          bool val=true;
          searchSnapshot.docs[index]["Admin"].toString()==Constants.myEmail?val=false:val=true;
          return  val?SearchTile( groupName:  searchSnapshot.docs[index]["GName"],
            category: searchSnapshot.docs[index]["Category"],
              admin: searchSnapshot.docs[index]["Admin"],
          image: searchSnapshot.docs[index]["GPhoto"].toString(),
          scaffoldKey:_scaffoldKey):Container();
        }):Container();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text("Search Groups"),),
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white24,
        child: Column(
          children: [
            Row(children: [
              Expanded(
                child:
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: searchTEC,
                    style: simpleTextStyle(),
                    decoration: InputDecoration(
                      hintText: 'Search by Group Category',
                      labelText: 'Search',
                      hintStyle: hintTextStyle(),
                      suffixIcon: GestureDetector(
                        onTap: (){
                          initiateSearch();
                        },
                        child: Icon(Icons.search_rounded,size: 30,),),
                    ),),
                ),
              ),
            ],),
            searchList(),
          ],),
      ),);
  }

}

class SearchTile extends StatefulWidget{
  final String groupName;
  final String category;
  final String admin;
  final String image;
  final scaffoldKey;
  SearchTile({this.groupName,this.category,this.admin,this.image,this.scaffoldKey});
  @override
  _SearchTileState createState() => _SearchTileState();
}

class _SearchTileState extends State<SearchTile> {
  String username="";
  //get user_name

  sendRequest({ String groupName,String category}) async {
    var ref = await FirebaseFirestore.instance.collection('Groups').doc(groupName).get();
    var mem=ref.get("Members").toString().replaceAll('[',"").replaceAll(']','').split(',');
    int len=ref.get("Members").toString().replaceAll('[',"").replaceAll(']','').split(',').length;
    List<String> member=[];
    for(int i=0;i<len;i++){
      member.add(mem[i].trim());
    }
    if(member.toString().contains("${Constants.myName}_${Constants.myEmail.split('@')[0]}")){
      final snackBar = SnackBar(content: Text("Already a group member!!"),backgroundColor: Colors.red,duration: Duration(milliseconds: 4000),);
      widget.scaffoldKey.currentState.showSnackBar(snackBar);
    }else{
      member.add("${Constants.myName}_${Constants.myEmail.split('@')[0]}");
      final snackBar = SnackBar(content: Text("You joined $groupName group!!"),backgroundColor: Colors.green,duration: Duration(milliseconds: 4000),);
      widget.scaffoldKey.currentState.showSnackBar(snackBar);
    }
    Map<String,dynamic> addNewMembers = {"GName":"$groupName","Members":member};
    await FirebaseFirestore.instance.collection('Groups').doc('$groupName').update(addNewMembers);
  }

  getUsernameByEmail(String email) async {
    var ref = await FirebaseFirestore.instance.collection('Users').get();
    for(int i =0;i<ref.docs.length;i++){
      if(email.compareTo(ref.docs[i].get('Email').toString())==0){
        if(this.mounted){
          setState(() {
            username = ref.docs[i].get('Username');
          });
        }
        break;
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    getUsernameByEmail(widget.admin);
    return Container(padding: EdgeInsets.all(10),
      decoration: BoxDecoration(border: Border.all(color: Colors.white,style: BorderStyle.solid,width: 1.2),color: Colors.grey.shade100),
      child: Row(mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(radius: 23,
            backgroundImage: NetworkImage(widget.image),
            child: widget.image.length==0?Icon(Icons.group_rounded,):Text(""),
          ),
          SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("${widget.groupName}",style: TextStyle(color: Colors.black,
                      fontSize: 21,
                      fontWeight: FontWeight.bold),),
                ],
              ),
              Text("(Admin: @$username)",style: TextStyle(color: Colors.grey.shade600,
                  fontSize: 18,
                  fontWeight: FontWeight.normal),),
              Text(widget.category,style: TextStyle(color: Colors.black,
                  fontSize: 19,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal),)
            ],),
          Spacer(),
          GestureDetector(
            onTap: (){
              sendRequest(groupName: widget.groupName,category: widget.category);
            },
            child: Container(
              decoration: BoxDecoration(color: Colors.blueGrey.shade100,
                  borderRadius: BorderRadius.circular(30.0)),
              padding: EdgeInsets.symmetric(horizontal: 8.0,vertical: 8.0),
              child: Icon(Icons.group_add_rounded,color: Colors.black,size: 28,),
              //Text("Request\nto Join",style: TextStyle(fontSize: 16,color: Colors.white),),
            ),
          ),
        ],),
    );
  }
}


