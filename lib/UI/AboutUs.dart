import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("About Us"),),
      body: Container(
        height: MediaQuery.of(context).size.height-40,
        width: MediaQuery.of(context).size.width-20,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child:Column(
                  children: [
                    SizedBox(height:30),
                    Center(
                        child:Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Our Mission",
                                style:TextStyle(
                                  fontWeight:FontWeight.bold,
                                  fontSize: 22,

                                )),
                            SizedBox(height: 5,),
                            Text("Imuplse is a platform for students and young professionals to"
                                " feel,see and claim their power and have discussions",
                                textAlign: TextAlign.center,
                                style:TextStyle(

                                  fontSize: 17,
                                )
                            ),
                          ],
                        )
                    ),
                    SizedBox(height: 40,),

                    Center(
                        child:Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Our Essence",
                                style:TextStyle(
                                  fontWeight:FontWeight.bold,
                                  fontSize: 22,

                                )),
                            SizedBox(height: 5,),
                            Text("At our core,Impulse operates on Inclusitivity,Impact,Individuality and Imagination",
                                textAlign: TextAlign.center,
                                style:TextStyle(

                                  fontSize: 17,
                                )
                            ),
                          ],
                        )
                    ),
                    SizedBox(height:40),

                    Center(
                        child:Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            Text("Our Promise",
                                style:TextStyle(
                                  fontWeight:FontWeight.bold,
                                  fontSize: 22,

                                )),
                            SizedBox(height: 5,),
                            Text("We plan to provide you with optimistic and diverse discussions and oppourtunites to interact with one another"
                                "and experiences and points of view to our audience",
                                textAlign: TextAlign.center,
                                style:TextStyle(

                                  fontSize: 17,
                                )
                            ),
                          ],
                        )
                    ),
                    SizedBox(height:40),
                    Center(
                        child:Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            Text("Our Vibe",
                                style:TextStyle(
                                  fontWeight:FontWeight.bold,
                                  fontSize: 22,

                                )),
                            SizedBox(height: 5,),
                            Text("At Impulse we make magic-you dream it and live it together -with others everyday"
                                " reinventing ad discovering whats possible",
                                textAlign: TextAlign.center,
                                style:TextStyle(
                                  fontSize: 17,)),
                          ],)),
                  ],),),
                SizedBox(height: 50,),
                /*Container(alignment: Alignment.bottomRight,
                  child: GestureDetector(onTap:(){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminSign_In()));
                },
                    child: Text("xxx",style: TextStyle(color: Colors.blueAccent),)),
              ),*/
            ],),
        ),
      ),
    );
  }

}