import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:googleapis/classroom/v1.dart' as gc;

import '../constants.dart';
class CourseItem extends StatelessWidget {
  final gc.Course course;

  const CourseItem(this.course);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 10,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              'assets/images/grad.svg',
              height: 100,
              
            ),
            Text(
              course.name,
              style: kSubheadingextStyle.copyWith(
                  fontSize: 17, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}