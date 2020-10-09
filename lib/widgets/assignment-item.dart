import 'package:elearning4/providers/classroom-manager.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:googleapis/classroom/v1.dart' as gc;
import 'package:provider/provider.dart';
import '../widgets/hand-in.dart';

class AssignmentItem extends StatefulWidget {
  final title;
  final date;
  final description;
  final List<gc.Material> materials;
  final assignmentId;
  final dueDate;
  AssignmentItem(
      {@required this.title,
      @required this.date,
      @required this.description,
      @required this.materials,
      @required this.assignmentId,
      @required this.dueDate});
  @override
  _AssignmentItemState createState() => _AssignmentItemState();
}

class _AssignmentItemState extends State<AssignmentItem> {
  bool _isExpanded = false;
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      final submissions =
          await Provider.of<ClassroomManager>(context, listen: false)
              .getSubmissions('148352686559', widget.assignmentId);
      submissions.forEach((element) {
        print(element.id);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool _isteacher = true;
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(width: 0.3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(widget.title),
            subtitle: Text(widget.date),
            trailing: _isteacher
                ? IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              title: Text('Delete Assignment '),
                              content:
                                  Text('Are you sure to delete Assignment ?'),
                              actions: <Widget>[
                                FlatButton(
                                    onPressed: () async {
                                      Navigator.of(ctx).pop(true);
                                      try {
                                        await Provider.of<ClassroomManager>(
                                                context)
                                            .deleteAssignment(
                                                widget.assignmentId);
                                      } catch (e) {
                                        print(e);
                                        Scaffold.of(context).showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'network error please try again')),
                                        );
                                      }
                                    },
                                    child: Text('Yes')),
                                FlatButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop(false);
                                    },
                                    child: Text('No'))
                              ],
                            );
                          });
                    })
                : _isExpanded
                    ? Icon(Icons.arrow_drop_up)
                    : Icon(Icons.arrow_drop_down),
            // FlatButton(
            //     onPressed: () {
            //       showModalBottomSheet(
            //           context: context,
            //           builder: (context) {
            //             List submissions = [];
            //             return HandIn(
            //               courseWorkId:widget.assignmentId,
            //               courseId: '148352686559',
            //               submissions: submissions,
            //             );
            //           });
            //     },
            //     child: Text(
            //       'Hand In',
            //       style: TextStyle(
            //           color: Colors.blue, fontWeight: FontWeight.bold),
            //     )),
            //
            leading: Image.asset(
              'assets/icons/assignment5.png',
              width: 100,
            ),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
          ),
          AnimatedContainer(
            padding: EdgeInsets.symmetric(horizontal: 10),
            duration: Duration(milliseconds: 500),
            height: _isExpanded ? 120 : 0,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Divider(),
                  SizedBox(
                    height: 10,
                  ),
                  widget.description == null
                      ? Container()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.description),
                            SizedBox(
                              height: 10,
                            ),
                            Divider(),
                          ],
                        ),

                  widget.materials == null || widget.materials.isEmpty
                      ? Container()
                      : Container(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: widget.materials
                                .map((e) => FlatButton(
                                    onPressed: () {
                                       if (e.driveFile != null) {
                                              launch(e.driveFile.driveFile
                                                  .alternateLink);
                                            } else if (e.youtubeVideo != null) {
                                              launch(
                                                  e.youtubeVideo.alternateLink);
                                            } else if(e.link!=null) {
                                              launch(e.link.url);
                                            }
                                            else{
                                              Scaffold.of(context).showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        'undefined attachement')),
                                              );
                                            }
                                    },
                                    child: Image.asset(
                                      'assets/icons/book3.png',
                                      height: 50,
                                    )))
                                .toList(),
                          ),
                        ),
                        widget.dueDate!=null?Container(
                          padding: EdgeInsets.only(bottom: 5),
                          alignment: Alignment.bottomRight,
                          child: Text('required at ${widget.dueDate.day}/${widget.dueDate.month}/${widget.dueDate.year}',style: TextStyle(color: Colors.blueAccent),)):Container()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
