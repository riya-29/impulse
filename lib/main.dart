import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:impulse/UI/dashboard.dart';
import 'package:impulse/helper/authenticate.dart';
import 'package:impulse/helper/helperFunctions.dart';
import 'helper/authenticate.dart';

bool USE_FIRESTORE_EMULATOR = false;

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'id', 'name', 'description',importance: Importance.high,playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async{
  await Firebase.initializeApp();
  print('New Message: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  ErrorWidget.builder = (FlutterErrorDetails details) {   //to override error red screen
    return Container(
      color: Colors.white,
    );
  };
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true);

  runApp(new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primaryColor: Colors.teal,
          primarySwatch: Colors.teal),
      home:HomePage()));
}

class HomePage extends StatefulWidget{
  HomePageState createState()=>HomePageState();
}
class HomePageState extends State<HomePage> {

  @override
  void initState() {
    /*FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification =message.notification;
      AndroidNotification android = message.notification?.android;
        if(notification!= null && android != null){
          flutterLocalNotificationsPlugin.show(
          notification.hashCode,notification.title, notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,channel.name,channel.description,color: Colors.blue,playSound: true,icon:'@mipmap/ic_launcher',
                )
              ));
        }
    });*/
    loginInfo();
    super.initState();
  }

  showNotification(){
    flutterLocalNotificationsPlugin.show(
      0,"Testing",'New Message' ,
      NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,channel.name,channel.description,importance: Importance.high,
            color: Colors.blue,playSound: true,icon:'@mipmap/ic_launcher',
          )
      )
    );
  }

  loginInfo() async{
    String login;
    await HelperFunction.getUserLoggedInSharedPreference()
        .then((value) => {login = value});
    if(login=="true"){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DashboardPage()));}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
              //getting media query height
              //double infinity makes it as big as the parent allows it
              //while mediaquery makes it as big as screen
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.symmetric(horizontal: 30,vertical: 50),
              child:
              Column(//even space distribution
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        "Welcome",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      SizedBox(
                        height:20,
                      ),
                      Text("Impulse provides a global community for students and young professionals to interact",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 15,
                        ),)
                    ],
                  ),

                  Container(
                    height: MediaQuery.of(context).size.height/3,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("asset/images/welcome.jpg"))),),
                  Column(
                    children: <Widget>[
                      //the login button
                      MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        onPressed: (){
                          showSignIn=true;
                          Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>Authenticate()));
                        },
                        //defining the shape
                        shape: RoundedRectangleBorder(
                            side:BorderSide(
                                color: Colors.black
                            ),
                            borderRadius: BorderRadius.circular(50)),
                        child: Text(
                          "Sign In",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize:18,),),
                      ),
                      //signup button
                      SizedBox(height: 20),
                      MaterialButton(
                        minWidth:double.infinity,
                        height: 60,
                        onPressed: () {
                          showSignIn=false;
                          Navigator.pushReplacement(context, MaterialPageRoute(
                              builder: (context) => Authenticate()));
                        },
                        color: Colors.teal,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)
                        ),
                        child: Text("Sign Up",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize:18,),),
                      ),
                    ],
                  )
                ],),
            )
        )
    );
  }
}

