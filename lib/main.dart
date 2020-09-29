import 'package:elearning4/providers/auth-manager.dart';
import 'package:elearning4/providers/classroom-manager.dart';
import 'package:elearning4/screens/chat-login-screen.dart';
import 'package:elearning4/screens/classroom-screen.dart';
import 'package:elearning4/screens/course-screen.dart';
import 'package:elearning4/screens/login-screen.dart';
import 'package:elearning4/screens/materials-screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
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
        'classroom-screen':(ctx)=>ClassRoomScreen(),
        'course-screen':(ctx)=>CourseScreen(),
        'material-screen':(ctx)=>MaterialsScreen(),
      },
    
    )
    );
  }
}
