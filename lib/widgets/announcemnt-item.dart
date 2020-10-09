import '../providers/classroom-manager.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/classroom/v1.dart' as gc;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
class AnnouncementItem extends StatelessWidget {
  const AnnouncementItem({
    Key key,
    @required this.material,
    @required this.isteacher,
  }) : super(key: key);

  final gc.Announcement material;
  final bool isteacher;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
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
     

      child: Stack(
        children: [
           Container(
             alignment: Alignment.center,
                child:Opacity(child: Image.asset('assets/images/back3.png',width: double.infinity,),opacity: 0.5,),
              ),
          Column(
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
                    ),

              // Divider(
              //   color: Colors.black87,
              // ),
              isteacher?Container(
                alignment: Alignment.bottomRight,
                child: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (ctx) {
                                  return AlertDialog(
                                    title: Text('Delete announcement '),
                                    content:
                                        Text('Are you sure to delete  this announcement ?'),
                                    actions: <Widget>[
                                      FlatButton(
                                          onPressed: () async {
                                            Navigator.of(ctx).pop(true);
                                            try {
                                             await Provider.of<ClassroomManager>(context).removeAnnouncement(material.id);
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
                          }),
              ):Container()
            ],
          ),
        ],
      ),
    );
  }
}