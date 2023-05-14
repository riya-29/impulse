import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:impulse/Services/auth.dart';
import 'package:impulse/UI/TimeLine&Section/editprofile.dart';
import 'package:impulse/UI/users.dart';
import 'package:impulse/helper/authenticate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:impulse/helper/helperFunctions.dart';
import 'TimeLine&Section/ViewProfile.dart';
import 'dashboard.dart';
import 'invites.dart';
class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  TextEditingController emailTEC = new TextEditingController();
  TextEditingController nameTEC = new TextEditingController();
  TextEditingController subjectTEC = new TextEditingController();
  TextEditingController messageTEC = new TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  final formKey =GlobalKey<FormState>();

  sendMail() async {
    Map<String,dynamic> mailDataMap={
      "Name": nameTEC.text,
      "Email": emailTEC.text,
      "Subject": subjectTEC.text,
      "Message": messageTEC.text,
      "read":false,
      "open":true,
      "DateTime":DateTime.now().toString()
    };
    await FirebaseFirestore.instance.collection("feedback").add(mailDataMap).then((value) => print(value));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      drawer: NavDrawer(),

      appBar: AppBar(elevation: 0,
          backgroundColor: Colors.teal,
          title: Text('Contact Us',
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.all(4.0),
              child: Column(
                  children: [
                    PopupMenuButton(itemBuilder: (context) =>
                      [
                        PopupMenuItem(child: InkWell(child: Text("View Profile"),
                              onTap: ()=>{Navigator.push(context, MaterialPageRoute(builder: (context) => ViewProfile())),}
                          ),),
                        PopupMenuItem(child: InkWell(child: Text("Edit Profile"),
                            onTap: ()=>{Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile())),}
                            ),),
                        PopupMenuItem(child: InkWell(child: Text("Invite Friends"),
                            onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => InviteFriends()))},),),
                        PopupMenuItem(
                          child:
                          InkWell(
                            child: Text("Logout"),
                            onTap: (){
                              HelperFunction.saveUserLoggedInSharedPreference("false");
                              while(Navigator.canPop(context)){
                                Navigator.pop(context);
                                print(Navigator.canPop(context));
                              }
                              AuthMethod auth = new AuthMethod();
                              auth.signOut();
                              signOutGoogle();
                              Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>Authenticate()));
                            },
                          ),

                        )],),
                  ]),
            ),
          ], systemOverlayStyle: SystemUiOverlayStyle.dark),

      body:SingleChildScrollView(
        child: Form(key: formKey,
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height:20),
            Center(child: Text("Get in Touch", style:TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),),
            SizedBox(height: 30,),
            TextFormField(
              controller: nameTEC,
              validator: (val){return nameTEC.text.isNotEmpty?null:"Name Required";},
              decoration: const InputDecoration(icon:const Icon(Icons.person),
                hintText: "Enter your name",
                labelText:'Name',
              ),
            ),
            SizedBox(height:20),
            TextFormField(
              controller: emailTEC,
              validator: (val){
                return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ?
                null : "Invalid Email";},
              decoration: const InputDecoration(
                icon:const Icon(Icons.email),
                hintText: "Enter your email",
                labelText:'Email',
              ),
            ),
            SizedBox(height:20),
            TextFormField(
              controller: subjectTEC,
              validator: (val){return subjectTEC.text.isNotEmpty?null:"Subject Required";},
              decoration: const InputDecoration(
                icon:const Icon(Icons.subject),
                hintText: "Enter subject",
                labelText:'Subject',
              ),
            ),
            SizedBox(height:20),
            Container(margin: EdgeInsets.all(10),color: Colors.grey.shade50,
              child: TextFormField(
                controller: messageTEC,
                validator: (val){return messageTEC.text.isNotEmpty?null:"Enter Message";},
                maxLines: 5,
                decoration: const InputDecoration(
                  icon:const Icon(Icons.message),
                  hintText: "Enter your message",
                  labelText:'Message',
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none),
              ),
            ),
             SizedBox(height:20),
             Center(
               child: Container(
                   height: 40,
                 decoration: BoxDecoration(
                   color: Colors.teal,
                   borderRadius: BorderRadius.circular(5),
                    ),
                 child: TextButton(//height: 50, minWidth: 120,
                  // shape: RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.circular(1),
                  // ),
                  child: Text("Submit",style:TextStyle(color:Colors.white,fontSize: 15)),
                  // color: Colors.teal,
                  onPressed: (){
                        if(formKey.currentState.validate()){
                        setState(() {
                        isLoading = true;
                        });
                        sendMail();
                        nameTEC.text="";emailTEC.text="";subjectTEC.text="";messageTEC.text="";
                        final snackBar = SnackBar(content: Text("Mail Sent!!"),backgroundColor: Colors.redAccent,duration: Duration(milliseconds: 5000),);
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }},
                  ),
               ),
             ),
            SizedBox(height: MediaQuery.of(context).size.height/2.5,)
          ],),
      ),),
    );
  }
}

