import '../widgets/announcemnt-item.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/app-bar.dart';
import '../providers/classroom-manager.dart';
import 'package:provider/provider.dart';
import '../widgets/heading.dart';

class MaterialsScreen extends StatelessWidget {
  final bool _isteacher = true;
  Future<void> _refresh(context) async {
    try {
      await Provider.of<ClassroomManager>(context).getAnnouncements();
    } catch (e) {
      displayError(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TheAppBar(),
          Heading('Materials'),
          SizedBox(
            height: 15,
          ),
          _isteacher
              ? Container(
                  // decoration: BoxDecoration(
                  //   border: Border.all(width: 0.2),
                  //   borderRadius: BorderRadius.circular(30),
                  // ),
                  margin:
                      EdgeInsets.only(top: 5, bottom: 12, left: 11, right: 11),
                  padding: EdgeInsets.only(bottom: 5, left: 15, right: 11),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Add materials',
                        style: kSubheadingextStyle.copyWith(fontSize: 20),
                      ),
                      IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            Navigator.of(context).pushNamed('add-materials');
                          }),
                    ],
                  ),
                )
              : Container(),
          FutureBuilder(
            builder: (ctx, snapShot) => snapShot.connectionState ==
                    ConnectionState.waiting
                ? Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 50),
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refresh(ctx),
                    child: Consumer<ClassroomManager>(
                      builder: (ctx, classroom, _) => classroom
                              .announcements.isEmpty
                          ? Center(
                              child: Text('no materials found'),
                            )
                          : Expanded(
                              child: Container(
                                margin: EdgeInsets.only(top: 10),
                                child: ListView.builder(
                                  itemBuilder: (ctx, index) => AnnouncementItem(
                                      isteacher: _isteacher,
                                      material: classroom.announcements[index]),
                                  itemCount: classroom.announcements.length,
                                ),
                              ),
                            ),
                    )),
            future: _refresh(context),
          ),
        ],
      )),
    );
  }
}

