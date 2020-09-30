import 'package:elearning4/providers/meetings.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../constants.dart';

class AddMeetingScreen extends StatefulWidget {
  final courseId;

  const AddMeetingScreen({this.courseId});
  @override
  _AddMeetingScreenState createState() => _AddMeetingScreenState();
}

class _AddMeetingScreenState extends State<AddMeetingScreen> {
  DateTime _pickedDate;
  TimeOfDay _pickedtime;
  String _title;
  void _pickDate(ctx) async {
    final date = await showDatePicker(
        context: ctx,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 1));
    if (date != null) {
      setState(() {
        _pickedDate = date;
      });

      print(date);
    }
    TimeOfDay t =
        await showTimePicker(context: ctx, initialTime: TimeOfDay.now());

    if (t != null) {
      setState(() {
        _pickedtime = t;
      });
    }
  }

  void _save()async {
    if (_pickedtime == null || _pickedDate == null || _title == null) {
      return;
    }
    await Provider.of<MeetingsManager>(context).addMetting(Meeting(
        course: widget.courseId,
        time: _pickedtime,
        title: _title,
        date: _pickedDate,
        mettingUrl: ''));
        Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 420,
        color: Color(0xFF737373),
        child: Container(
          alignment: Alignment.center,
          decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                topRight: const Radius.circular(10.0),
                topLeft: const Radius.circular(100.0),
              )),
          child: Column(
            children: [
              Text(
                "New Lecture",
                style: kSubheadingextStyle.copyWith(
                    fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                child: TextFormField(
                  onChanged: (val) {
                    _title = val;
                  },
                  decoration: const InputDecoration(labelText: 'title'),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Date',
                        style: TextStyle(
                          fontSize: 20,
                        )),
                    (_pickedDate == null || _pickedtime == null)
                        ? FlatButton(
                            child: Text(
                              'Pick Date',
                              style: TextStyle(color: Colors.blue),
                            ),
                            onPressed: () {
                              _pickDate(context);
                            })
                        : Text(
                            '${DateFormat("dd/MM/yyyy").format(_pickedDate)}   ${_pickedtime.hour}:${_pickedtime.minute}'),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20, right: 10),
                alignment: Alignment.center,
                child: FlatButton(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    // width:,

                    //margin: EdgeInsets.only(top: 20),

                    child: Text(
                      'Add lecture',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  onPressed: _save,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
