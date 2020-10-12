import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Meeting {
  final title;
  final DateTime date;
  final TimeOfDay time;
  final course;
  final description;
  // final url;
  final mettingUrl;
  final id;

  Meeting(
      {@required this.course,
      @required this.time,
      this.description,
      @required this.title,
      @required this.date,
      @required this.mettingUrl,
      this.id
      });
}

class MeetingsManager with ChangeNotifier {
  List<Meeting> _meetings = [
    Meeting(
        course: 'english',
        time: TimeOfDay.now(),
        title: 'meeting one',
        date: DateTime.now(),
        mettingUrl:
            'https://meet.google.com/qdn-vwjy-rsj?fbclid=IwAR1pPxpROO4-pUN92EJFqmoEdA41oYGUUaMajl_mC1q6Z_Bk95htqT981OM'),
  
  ];
  List<Meeting> get meetings {
    return _meetings.reversed.toList();
  }

  void addMetting(Meeting meeting) {
    _meetings.add(meeting);
    meetings.forEach((element) {
      print(element.title);
    });
    notifyListeners();
  }

  Future<void>removeMeeting(id){
      _meetings.removeWhere((element) => element.id==id);
      notifyListeners();
  }
}
