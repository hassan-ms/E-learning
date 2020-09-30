import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants.dart';
import '../widgets/app-bar.dart';
import '../providers/classroom-manager.dart';
import 'package:provider/provider.dart';
import 'package:googleapis/classroom/v1.dart' as gc;
import 'package:intl/intl.dart';

class MaterialsScreen extends StatefulWidget {
  @override
  _MaterialsScreenState createState() => _MaterialsScreenState();
}

class _MaterialsScreenState extends State<MaterialsScreen> {
  bool _isLoading = false;
  // @override
  // void didChangeDependencies() async {
  //   final courseId = ModalRoute.of(context).settings.arguments as String;

  //       await Provider.of<ClassroomManager>(context).getAnnouncements(courseId);
  //   print(courseId);

  //   super.didChangeDependencies();
  // }
  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    try {
      Future.delayed(Duration.zero, () async {
        final courseId = ModalRoute.of(context).settings.arguments as String;

        await Provider.of<ClassroomManager>(context, listen: false)
            .getAnnouncements(courseId);
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
    final materials = Provider.of<ClassroomManager>(context).announcements;
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          body: Column(
          
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TheAppBar(
            size: size,
          ),
          Container(
            
              padding: EdgeInsets.only(top: 5, bottom: 12, left: 10),
              child: Text("Course Materials",
                  style: kSubheadingextStyle.copyWith(
                      fontWeight: FontWeight.bold))),
          Container(
            decoration: BoxDecoration(
              border: Border.all(width: 0.2),
              borderRadius: BorderRadius.circular(30),
            
            ),
            margin: EdgeInsets.only(top: 5, bottom: 12, left: 11,right:11 ),
            padding: EdgeInsets.only(bottom: 5,left: 15,right:11 ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Add materials',
                  style: kSubheadingextStyle.copyWith(fontSize: 20),
                ),
                IconButton(icon: Icon(Icons.add), onPressed: () {
                  Navigator.of(context).pushNamed('add-materials');
                }),
              ],
            ),
          ),
          _isLoading == true
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  margin: EdgeInsets.only(top: 10),
                  height: size.height * 0.65,
                  child: ListView.builder(
                    itemBuilder: (ctx, index) =>
                        AnnouncementItem(material: materials[index]),
                    itemCount: materials.length,
                  ),
                )
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
      margin: EdgeInsets.only(bottom: 10, right: 12, left: 12, top: 10),
      decoration: BoxDecoration(
        //color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
        //border: Border.all(width: 0.3),
        shape: BoxShape.rectangle,

        //   boxShadow: <BoxShadow>[
        //     BoxShadow(
        //        color: Colors.grey.withOpacity(0.5),
        // spreadRadius: 5,
        // blurRadius: 7,
        // offset: Offset(0, 3),
        //     ),
        //]
      ),
      child: Stack(
        children: <Widget>[
          //  Container(

          //    margin: EdgeInsets.only(top:50),
          //    alignment: Alignment.bottomRight,
          //    child: SvgPicture.asset('assets/icons/assignment.svg',height:80,alignment:Alignment.bottomRight,colorBlendMode:BlendMode.src,)),
          //
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
              material.materials.isEmpty
                  ? Container()
                  : Container(
                      height: 90,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4),
                        itemBuilder: (ctx, index) {
                          return Container(
                              margin: EdgeInsets.all(0),
                              padding: EdgeInsets.all(0),
                              //height: 30,
                              child: FlatButton(
                                  onPressed: () {
                                    if (material.materials[index].driveFile!=null) {
                                      launch(material.materials[index].driveFile.driveFile.alternateLink);
                                    } else if(material.materials[index].youtubeVideo!=null) {
                                      launch(material.materials[index].youtubeVideo.alternateLink);
                                                                          }
                                    else{
                                      launch(material.materials[index].link.url);
                                    }
                                    
                                  },
                                  child: Image.asset(
                                    'assets/icons/book3.png',
                                    height: 50,
                                  )));
                        },
                        itemCount: material.materials.length,
                      ),
                    ),
              Divider(
                color: Colors.black87,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
