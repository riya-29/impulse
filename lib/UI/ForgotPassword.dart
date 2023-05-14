import 'package:flutter/material.dart';
import 'package:impulse/Services/auth.dart';
import 'package:impulse/Widgets/widgets.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController emailTEC = new TextEditingController();

  final formKey =GlobalKey<FormState>();
  bool isLoading = false;

  AuthMethod auth = new AuthMethod();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text("Reset Password"),),
      backgroundColor: Colors.white,
      body: Container(alignment: Alignment.center,
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(child: Form(key: formKey,
          child: Column(
            children: [
              TextFormField(
                  validator: (val){
                    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ?
                    null : "Invalid Email";
                  },
                  controller:emailTEC,
                  style: simpleTextStyle(),
                  decoration: textFieldInputDecoration('Email','Email')
              ),
              SizedBox(height:  16,),
              GestureDetector(
                onTap: (){
                  if(formKey.currentState.validate()){
                    setState(() {
                      isLoading = true;
                    });
                    auth.resetPassword(emailTEC.text.trim());
                    final snackBar = SnackBar(content: Text("A link has been sent to your email to reset password."),backgroundColor: Colors.redAccent,duration: Duration(milliseconds: 5000),);
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }},
                child: Container(
                  alignment:  Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  width: MediaQuery.of(context).size.width/2,
                  decoration: BoxDecoration(
                    //borderRadius: BorderRadius.circular(24.0),
                      gradient: LinearGradient(colors: [Colors.teal,Colors.teal.shade400,])
                  ),
                  child: Text('Submit',style: TextStyle(color: Colors.white,
                      fontSize: 19),),),
              )
            ],),),
        ),),
    );
  }

}