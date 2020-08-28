import 'package:flutter/material.dart';
import '../providers/classroom-manager.dart';
class ClassRoomScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final client=ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(onPressed:()=>ClassroomManager.createCoure(client), child: Text('create course')),
        ],
      ),),
    );
  }
}