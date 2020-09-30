import 'package:elearning4/providers/meetings.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';

class MeetingItem extends StatelessWidget {
  final Meeting meeting;

  const MeetingItem(this.meeting);

  @override
  Widget build(BuildContext context) {
    final isLive = (meeting.date.day == DateTime.now().day &&
        meeting.time.hour == TimeOfDay.now().hour);
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(left: 15.0, right: 15,bottom: 20),
      decoration: BoxDecoration(
        border: Border.all(
          width: 0.5,
        ),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8.0,
            offset: Offset(0.0, 3.0),
          ),
        ],
      ),
      child: Stack(
        children: [
          isLive
              ? Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/icons/live.png',
                    width: 70,
                  ))
              : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(meeting.title,
                  style: kSubheadingextStyle.copyWith(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              isLive
                  ? FlatButton(
                      child: Image.asset(
                        'assets/icons/join.png',
                        width: 100,
                      ),
                      onPressed: () {
                        launch(meeting.mettingUrl);
                      })
                  : Text(
                      '${DateFormat("dd/MM/yyyy").format(meeting.date)}   ${meeting.time.hour}:${meeting.time.minute}'),
            ],
          ),
        ],
      ),
    );
  }
}
