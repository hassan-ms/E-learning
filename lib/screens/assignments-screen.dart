import 'package:elearning4/providers/classroom-manager.dart';
import 'package:elearning4/widgets/app-bar.dart';
import 'package:elearning4/widgets/assignment-item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class AssignmentScreen extends StatefulWidget {
  @override
  _AssignmentScreenState createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  bool _isLoading = false;
  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    try {
      Future.delayed(Duration.zero, () async {
        final courseId ='148352686559';

        await Provider.of<ClassroomManager>(context, listen: false)
            .fetchAssignments(courseId);
      });
    } catch (e) {
      print(e);
    }
    setState(() {
      _isLoading = false;
    });

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final assignments = Provider.of<ClassroomManager>(context).assignments;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TheAppBar(),
              Container(
                  padding: EdgeInsets.only(top: 5, bottom: 12, left: 10),
                  child: Text("Assignments",
                      style: kSubheadingextStyle.copyWith(
                          fontWeight: FontWeight.bold))),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                margin:
                    EdgeInsets.only(top: 5, bottom: 12, left: 11, right: 11),
                padding: EdgeInsets.only(bottom: 5, left: 15, right: 11),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Add Assignment',
                      style: kSubheadingextStyle.copyWith(fontSize: 20),
                    ),
                    IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          Navigator.of(context).pushNamed('add-assignment');
                        }),
                  ],
                ),
              ),
              Container(
               
                height:500 ,
                child: ListView.builder(
                  itemBuilder: (ctx, index) => AssignmentItem(
                    assignmentId: assignments[index].id,
                    title: assignments[index].title,
                    date: DateFormat('dd-MM-yyyy')
                          .format(DateTime.parse(assignments[index].creationTime)),
                    description: assignments[index].description,
                    materials: assignments[index].materials,
                  ),
                  itemCount: assignments.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
