import 'package:flutter/material.dart';

/*AppBar*/
Widget AppBarMain(BuildContext context){
  return AppBar(title: Text('Impulse',
  ),backgroundColor: Colors.teal,
  );
}

/*InputDecoration for TextField*/
InputDecoration textFieldInputDecoration(String hintText,String labelText){
  return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.blueGrey),
      labelText: labelText,
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal,width: 1.8)),
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black87))
  );
}
/*Normal TextStyle for TextField*/
TextStyle simpleTextStyle(){
  return TextStyle(color: Colors.black,
      fontSize: 19,
      fontWeight: FontWeight.normal
  );
}
/*TextStyle medium 16*/
TextStyle mediumTextStyle(){
  return TextStyle(color: Colors.black,
      fontSize: 16
  );
}
/*TextStyle for hintText*/
TextStyle hintTextStyle(){
  return TextStyle(color: Colors.grey,
      fontSize: 19
  );
}