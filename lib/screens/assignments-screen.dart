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
         await Provider.of<ClassroomManager>(context, listen: false)
            .fetchAssignments();
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
     final md = MediaQuery.of(context);
    final height = md.size.height - md.padding.top - 240;
    final assignments = Provider.of<ClassroomManager>(context).assignments;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                        "Assignments",
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
              Container(
                
                margin:
                    EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                //padding: EdgeInsets.only(bottom: 5, left: 15, right: 11),
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
               
                height:height ,
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
