import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/classroom-manager.dart';
import '../constants.dart';
import 'package:googleapis/classroom/v1.dart' as gc;

class HandIn extends StatefulWidget {
  final List submissions;
  final courseId;
  final courseWorkId;

  const HandIn({
    @required this.submissions, @required this.courseId,@required this.courseWorkId,
  });

  @override
  _HandInState createState() => _HandInState();
}

class _HandInState extends State<HandIn> {
  List _files = [];
  bool drive_drop = false;

  String _link;
  Future<void> _turnIn(context) async {
    gc.StudentSubmission submission = gc.StudentSubmission();
    List<gc.Attachment> attachments = [];
    if (_files.isNotEmpty) {
      final dfiles =
          await Provider.of<ClassroomManager>(context).uploadFiles(_files);
      dfiles.forEach((element) {
        attachments.add(gc.Attachment.fromJson({
          "driveFile": {
            "driveFile": {
              "id": element.id,
            },
            "shareMode": "VIEW"
          }
        }));
      });
    }
  if(_link!=null){
    attachments.add(gc.Attachment.fromJson(
      {"link":
      {
        "url":_link,
      }
    }
    ));
  }
 
  submission.assignmentSubmission.attachments=attachments;
    await Provider.of<ClassroomManager>(context).submitAssignment(
        submission: submission,
        courseId: widget.courseId,
        courseWorkId: widget.courseWorkId,
        submissionID: 25);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 500,
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
                "Your Work",
                style: kSubheadingextStyle.copyWith(
                    fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                child: TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Private Comment'),
                ),
              ),
              Card(
                margin: EdgeInsets.all(5),
                elevation: 5,
                child: ListTile(
                  trailing: IconButton(
                      icon: Icon(Icons.attach_file),
                      onPressed: () async {
                        final f = await FilePicker.platform.pickFiles(
                          allowMultiple: false,
                        );

                        if (f != null) {
                          f.files.forEach((element) {
                            setState(() {
                              _files.add(element);
                              // Provider.of<ClassroomManager>(context).uploadFiles(file);
                            });
                          });
                        }
                      }),
                  title: Text('File from phone'),
                  leading: Image.asset(
                    'assets/icons/phonefile.png',
                    height: 40,
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.all(5),
                elevation: 5,
                child: Column(
                  children: [
                    ListTile(
                      trailing: IconButton(
                          icon: drive_drop == false
                              ? Icon(Icons.arrow_drop_down)
                              : Icon(Icons.arrow_drop_up),
                          onPressed: () {
                            setState(() {
                              drive_drop = !drive_drop;
                            });
                          }),
                      title: Text('Link'),
                      subtitle: Text(
                          ' drive file link , youtube video or any other link'),
                      leading: Image.asset(
                        'assets/icons/link.png',
                        height: 40,
                      ),
                    ),
                    AnimatedContainer(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      duration: Duration(milliseconds: 500),
                      height: drive_drop ? 100 : 0.0,
                      child: drive_drop
                          ? TextFormField(
                              onChanged: (val) {
                                _link = val;
                              },
                              decoration:
                                  InputDecoration(labelText: 'link'),
                            )
                          : Container(),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20, right: 10),
                alignment: Alignment.bottomRight,
                child: FlatButton(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    width: 80,

                    //margin: EdgeInsets.only(top: 20),

                    child: Text(
                      'Hand in',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  onPressed: () async {
                     await _turnIn(context);
                  },
                ),
              )
            ],
          ),
        ));
  }
}
