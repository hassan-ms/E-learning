import 'package:elearning4/providers/classroom-manager.dart';
import 'package:elearning4/widgets/app-bar.dart';
import 'package:elearning4/widgets/course-item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final classroom = Provider.of<ClassroomManager>(context);
    final md = MediaQuery.of(context);
    final height = md.size.height - md.padding.top - 180;
    final width = md.size.width;
    bool _isLandScape = md.orientation == Orientation.landscape;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
            height: double.infinity,
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              'assets/images/success2.png',
            ),
          ),
            Column(
              children: [
                TheAppBar(),
                Container(
                    padding: EdgeInsets.only(top: 5, bottom: 12, left: 10),
                    child: Text("Courses",
                        style: kSubheadingextStyle.copyWith(
                            fontWeight: FontWeight.bold))),
                FutureBuilder(
                    future: classroom.fetchCourses(),
                    builder: (ctx, snapshop) =>
                        snapshop.connectionState == ConnectionState.waiting
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Container(
                                height: height,
                                child: (classroom.courses.isEmpty ||
                                        classroom.courses == null)
                                    ? Center(
                                        child: Text('no courses found'),
                                      )
                                    : GridView.builder(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2),
                                        itemBuilder: (ctx, index) =>
                                            CourseItem(classroom.courses[index]),
                                        itemCount: classroom.courses.length,
                                      ))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
