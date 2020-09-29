import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/class-itemn.dart';
import '../constants.dart';
import '../widgets/app-bar.dart';
import '../providers/classroom-manager.dart';
import 'chat-login-screen.dart';

class CourseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Stack(children: <Widget>[
          Container(
        height: double.infinity,
        alignment: Alignment.bottomCenter,
        child: Image.asset('assets/images/success2.png',),
      ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TheAppBar(size: size),
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  "Math",
                  style: kHeadingextStyle,
                ),
              ),
              //Text("Find a course you want to learn", style: kSubheadingextStyle),
              //end appbar
              Container(
                padding: EdgeInsets.only(left: 15, top: 20, right: 15),
                height: size.height * 0.75,
                child: GridView.count(
                  crossAxisCount: size.width < 500 ? 2 : 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: <Widget>[
                    InkWell(
                      child: ClassItem(
                        svg: 'assets/icons/teaching.svg',
                        title: 'Materials',
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed('material-screen',
                            arguments: '24269433570');
                      },
                    ),
                    InkWell(
                      child: ClassItem(
                        svg: 'assets/icons/assignment.svg',
                        title: 'Assignments',
                      ),
                      onTap: () async {
                        await Provider.of<ClassroomManager>(context)
                            .fetchAssignments('24269433570');
                      },
                    ),
                    InkWell(
                      child: ClassItem(
                        svg: 'assets/icons/exam.svg',
                        title: 'Exams',
                      ),
                      onTap: () async {
                        await Provider.of<ClassroomManager>(context)
                            .getCourses();
                      },
                    ),
                    ClassItem(
                      svg: 'assets/icons/meeting.svg',
                      title: 'Comming lectures',
                    ),
                    InkWell(
                        child: ClassItem(
                        svg: 'assets/icons/chat3.svg',
                        title: 'chat with teacher',
                      ),
                      onTap: () {Navigator.push(
          context, MaterialPageRoute(builder: (context) => ChatLoginScreen()));}
                    ),
                    ClassItem(
                      svg: 'assets/icons/attendance.svg',
                      title: 'Attendance',
                    ),
                  ],
                ),
              )
            ],
          ),
        ]),
      ),
    );
  }
}
