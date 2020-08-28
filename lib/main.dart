import 'package:elearning4/screens/classroom-screen.dart';
import 'package:elearning4/screens/login-screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
      routes: {
        'classroom-screen':(ctx)=>ClassRoomScreen(),
      },
    
    );
    
  }
}
