import 'package:elearning4/providers/classroom-manager.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../widgets/app-bar.dart';
import 'package:googleapis/classroom/v1.dart' as gc;

class AddAssignment extends StatefulWidget {
  @override
  _AddAssignmentState createState() => _AddAssignmentState();
}

class _AddAssignmentState extends State<AddAssignment> {
  final _formKey = GlobalKey<FormState>();
  String _title;
  String _description = "";
  List<PlatformFile> _files = [];
  String _link;
  DateTime _pickedDate;
  TimeOfDay _pickedTime;
  bool drive_drop = false;
  bool _isLoading = false;

  Future<void> _upload(BuildContext ctx) async {
    final isValid = _formKey.currentState.validate() &&
        (_files.isNotEmpty || _link != null);
    if (!isValid) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    gc.CourseWork assignment = gc.CourseWork();
    List<gc.Material> materials = [];
    if (_files.isNotEmpty) {
      final gfiles = await Provider.of<ClassroomManager>(context).uploadFiles(
          '0BzfsOody00jffkVZY2ZaU0FMMnZLRWs1bmhlY2djcTZqc1V5X1J0eEpxbE1aUm9UTmJnLTg',
          _files);
      gfiles.forEach((element) {
        materials.add(gc.Material.fromJson({
          "driveFile": {
            "driveFile": {
              "id": element.id,
            },
            "shareMode": "VIEW"
          }
        }));
      });
    }
    if (_link != null) {
      materials.add(gc.Material.fromJson({
        "link": {
          "url": _link,
        }
      }));
    }
    assignment.title = _title;
    assignment.description = _description;
    assignment.materials = materials;
    assignment.workType = "ASSIGNMENT";
    assignment.state = "PUBLISHED";
    gc.Date dDate=new gc.Date();
    gc.TimeOfDay dTime=new gc.TimeOfDay();
    dDate.day=_pickedDate.day;
    dDate.month=_pickedDate.month;
    dDate.year=_pickedDate.year;
    assignment.dueDate=dDate;
    dTime.hours=_pickedTime.hour;
    dTime.minutes=_pickedTime.minute;
    assignment.dueTime=dTime;
    try {
      await Provider.of<ClassroomManager>(ctx).createAssignment(assignment);

      Navigator.of(context).pop();
    } catch (e) {
      Scaffold.of(ctx).showSnackBar(
        SnackBar(content: Text('network error please try again')),
      );
      print(e);    }
    setState(() {
      _isLoading = false;
    });
  }

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
      
    }
    TimeOfDay t =
        await showTimePicker(context: ctx, initialTime: TimeOfDay.now());

    if (t != null) {
      setState(() {
        _pickedTime = t;
      });
  }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          Container(
            alignment: Alignment.bottomRight,
            child: Opacity(
                opacity: 0.6,
                child: Image.asset(
                  'assets/icons/ass1.png',
                  height: 150,
                )),
          ),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
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
                        "Create Assignment",
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
                _isLoading
                    ? Container(
                        padding: EdgeInsets.symmetric(vertical: 200),
                        child: Text('uploading...'),
                      )
                    : Container(
                        padding: EdgeInsets.all(5),
                        child: Form(
                            autovalidate: true,
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: size.width * 0.5,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      labelText: 'Title',
                                    ),
                                    onChanged: (val) {
                                      _title = val;
                                    },
                                    validator: (val) {
                                      if (val.isEmpty) {
                                        return 'title can\'t be embty';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  maxLines: 2,
                                  onChanged: (val) => _description = val,
                                  keyboardType: TextInputType.multiline,
                                  decoration:
                                      InputDecoration(labelText: 'description'),
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: 20, top: 10,),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Due date',
                                          style: kSubheadingextStyle.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),),
                                      (_pickedDate == null || _pickedTime==null)
                                          ? FlatButton(
                                              child: Text(
                                                'Pick Date',
                                                style: TextStyle(
                                                    color: Colors.blue),
                                              ),
                                              onPressed: () {
                                                _pickDate(context);
                                              })
                                          : Text(
                                              '${DateFormat("dd/MM/yyyy").format(_pickedDate)}   ${_pickedTime.hour}:${_pickedTime.minute}'),
                                    ],
                                  ),
                                ),
                                Divider(thickness:0.7,color: Colors.grey,),
                                SizedBox(
                                  height: 0,
                                ),
                                Text(
                                  'Files :',
                                  style: kSubheadingextStyle.copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Card(
                                  margin: EdgeInsets.all(5),
                                  elevation: 5,
                                  child: ListTile(
                                    trailing: IconButton(
                                        icon: Icon(Icons.attach_file),
                                        onPressed: () async {
                                          final f = await FilePicker.platform
                                              .pickFiles(
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
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        duration: Duration(milliseconds: 500),
                                        height: drive_drop ? 100 : 0.0,
                                        child: drive_drop
                                            ? TextFormField(
                                                onChanged: (val) {
                                                  _link = val;
                                                },
                                                decoration: InputDecoration(
                                                    labelText: 'link'),
                                              )
                                            : Container(),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  alignment: Alignment.center,
                                  child: _files.isEmpty
                                      ? Text(
                                          'no files is selected',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.red),
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: _files
                                              .map(
                                                (e) => Flexible(
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        right: 10, top: 20),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Stack(
                                                          children: [
                                                            Image.asset(
                                                              'assets/icons/book3.png',
                                                              height: 40,
                                                            ),
                                                            Container(
                                                                child:
                                                                    IconButton(
                                                                        icon: Image
                                                                            .asset(
                                                                          'assets/icons/remove.png',
                                                                          width:
                                                                              15,
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            _files.remove(e);
                                                                          });
                                                                        })),
                                                          ],
                                                        ),
                                                        Text('${e.name}'),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: FlatButton(
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 0.2),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.white),
                                      width: 120,

                                      //margin: EdgeInsets.only(top: 20),

                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/icons/upload.png',
                                            width: 25,
                                          ),
                                          Text(
                                            '  Upload',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onPressed: () async {
                                      await _upload(context);
                                    },
                                  ),
                                ),
                              ],
                            )),
                      )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}