import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants.dart';
import '../widgets/app-bar.dart';
import '../providers/classroom-manager.dart';
import 'package:provider/provider.dart';
import 'package:googleapis/classroom/v1.dart' as gc;
import 'package:intl/intl.dart';

class MaterialsScreen extends StatelessWidget {
  final bool _isteacher = true;
  Future<void> _refresh(context) async {
    try {
      await Provider.of<ClassroomManager>(context, listen: false)
          .getAnnouncements();
    } catch (e) {
      Scaffold.of(context).showSnackBar(
        SnackBar(content: Text('network error please try again')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      
      child: Scaffold(
       
          body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TheAppBar(
            size: size,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/graduate.jpg',
                width: 50,
              ),
              Container(
                padding: EdgeInsets.only(bottom: 7, right: 10, left: 10),
                alignment: Alignment.center,
                child: Text(
                  "Materials",
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
                          : Container(
                              margin: EdgeInsets.only(top: 10),
                              height: size.height * 0.65,
                              child: ListView.builder(
                                itemBuilder: (ctx, index) => AnnouncementItem(
                                    material: classroom.announcements[index]),
                                itemCount: classroom.announcements.length,
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

class AnnouncementItem extends StatelessWidget {
  const AnnouncementItem({
    Key key,
    @required this.material,
  }) : super(key: key);

  final gc.Announcement material;

  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(width: 0.3),
        borderRadius: BorderRadius.only(
          //topLeft: Radius.circular(20),
          //bottomRight: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
       
      ),
      margin: EdgeInsets.only(bottom: 10, right: 12, left: 12, top: 10),
     

      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Flexible(
                    child: Text('${material.text}',
                        style: kSubtitleTextSyule.copyWith(fontSize: 18))),
                Text(
                  DateFormat('dd-MM-yyyy')
                      .format(DateTime.parse(material.creationTime)),
                  style: kSubheadingextStyle.copyWith(
                    fontSize: 12,
                  ),
                )
              ],
            ),
          ),
          material.materials == null
              ? Container()
              : Container(
                height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: material.materials
                        .map(
                          (e) => Flexible(
                              child: Container(
                                  margin: EdgeInsets.all(0),
                                  padding: EdgeInsets.all(0),
                                  //height: 30,
                                  child: FlatButton(
                                      onPressed: () {
                                        if (e.driveFile != null) {
                                          launch(e.driveFile.driveFile
                                              .alternateLink);
                                        } else if (e.youtubeVideo != null) {
                                          launch(
                                              e.youtubeVideo.alternateLink);
                                        } else {
                                          launch(e.link.url);
                                        }
                                      },
                                      child: Image.asset(
                                        'assets/icons/book3.png',
                                        height: 50,
                                      )))),
                        )
                        .toList(),
                  ),
                )

          // Divider(
          //   color: Colors.black87,
          // ),
        ],
      ),
    );
  }
}
