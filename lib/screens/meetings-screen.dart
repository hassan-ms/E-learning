import 'package:elearning4/widgets/MeetingItem.dart';
import 'package:elearning4/widgets/app-bar.dart';
import 'package:elearning4/widgets/teacher-meeting-item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/meetings.dart';
import '../constants.dart';
import '../widgets/add-meeting.dart';

class MeetingsScreeen extends StatelessWidget {
  final bool _isteacher = true;
  @override
  Widget build(BuildContext context) {
    final courseID = ModalRoute.of(context).settings.arguments;
    List meetings = Provider.of<MeetingsManager>(context).meetings;

    meetings.reversed.toList();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TheAppBar(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/graduate.jpg',
                  width: 50,
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 10, right: 10, left: 10),
                  alignment: Alignment.center,
                  child: Text(
                    "Lectures",
                    style: kSubheadingextStyle.copyWith(
                        fontWeight: FontWeight.bold, fontSize: 26),
                    textAlign: TextAlign.center,
                  ),
                ),
                Image.asset(
                  'assets/icons/graduate.jpg',
                  width: 50,
                ),
              ],
            ),
            _isteacher
                ? Container(
                    decoration: BoxDecoration(
                      //border: Border.all(width: 0.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    margin: EdgeInsets.only(
                        top: 20, bottom: 12, left: 11, right: 11),
                    padding: EdgeInsets.only(bottom: 5, left: 15, right: 11),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Create Lecture',
                          style: kSubheadingextStyle.copyWith(fontSize: 20),
                        ),
                        IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) => AddMeetingScreen(
                                        courseId: courseID,
                                      ));
                            }),
                      ],
                    ),
                  )
                : Container(),
            Container(
              height: 500,
              alignment: Alignment.center,
              child: (meetings.isEmpty || meetings == null)
                  ? Text('no Lectures added')
                  : ListView.builder(
                      itemBuilder: (ctx, index) => _isteacher
                          ? TeacherMeetingItem(meetings[index])
                          : MeetingItem(meetings[index]),
                      itemCount: meetings.length,
                    ),
            )
          ],
        ),
      ),
    );
  }
}
