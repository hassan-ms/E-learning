import 'package:elearning4/providers/auth-manager.dart';
import 'package:elearning4/providers/classroom-manager.dart';
import 'package:elearning4/providers/meetings.dart';
import 'package:elearning4/screens/Home-screen.dart';
import 'package:elearning4/screens/add-assignment-screen.dart';
import 'package:elearning4/screens/add-materials-screen.dart';
import 'package:elearning4/screens/assignments-screen.dart';
import 'package:elearning4/screens/chat-home-screen.dart';
import 'package:elearning4/screens/chat-settings-screen.dart';
import 'package:elearning4/screens/course-screen.dart';
import './screens/invitations-screen.dart';
import 'package:elearning4/screens/login-screen.dart';
import 'package:elearning4/screens/materials-screen.dart';
import 'package:elearning4/screens/meetings-screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/profile-screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  // TODO: Skip login if already logged in
  // SharedPreferences prefs;
  // bool isSignedIn = false;
  // void initState() {
  //   startfunction();
  // }
  // void startfunction() async{
  //   prefs = await SharedPreferences.getInstance();
  //   isSignedIn = prefs.getBool('isSignedIn');
  //   print(isSignedIn.toString());
  // }

  // Widget checkSignInforScreen(){
  //   if(isSignedIn){
  //     return CourseScreen();
  //   }else{
  //     return CourseScreen();
  //   }
  // }

  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider.value(value: MeetingsManager()),
      ChangeNotifierProvider.value(value:AuthManager()),
      ChangeNotifierProxyProvider<AuthManager,ClassroomManager>(create:(_)=>ClassroomManager() ,update:(_,auth,classroom)=>classroom..setClient(auth.client),
      ),
      //ChangeNotifierProvider.value(value:ClassroomManager()),
      ],
    child:MaterialApp(
      debugShowCheckedModeBanner:false,
      title: 'e-learning',
      
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
      routes: {
        'login-screen':(ctx)=>LoginScreen(),
        'home-screen':(ctx)=>HomeScreen(),
        'course-screen':(ctx)=>CourseScreen(),
        'material-screen':(ctx)=>MaterialsScreen(),
        'add-materials':(ctx)=>AddMaterials(),
        'assignments-screen':(ctx)=>AssignmentScreen(),
        'add-assignment':(ctx)=>AddAssignment(),
        'meetings-screen':(ctx)=>MeetingsScreeen(),
        'profile-screen':(ctx)=>ProfileScreen(),
       'invitations-screen':(ctx)=>InvitationsScreen(),
       'chat-setting-screen':(ctx)=>ChatSettings(),
       'chat-home-screen':(ctx)=>ChatHomeScreen(),
      },
    
    )
    );
  }
}
