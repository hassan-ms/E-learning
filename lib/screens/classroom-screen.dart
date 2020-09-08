import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../category.dart';
import '../constants.dart';
import '../providers/classroom-manager.dart';
class ClassRoomScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final client=ModalRoute.of(context).settings.arguments;
    final classroom =Provider.of<ClassroomManager>(context);
    return Scaffold(
      
      body: Padding(
        padding: EdgeInsets.only(left: 20, top: 50, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
               FlatButton(onPressed: (){}, child: SvgPicture.asset("assets/icons/menu.svg")) ,
                Image.asset("assets/images/user.png"),
              ],
            ),
            SizedBox(height: 30),
            Text("Hey Alex,", style: kHeadingextStyle),
            Text("Find a course you want to learn", style: kSubheadingextStyle),
          
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Category", style: kTitleTextStyle),
                Text(
                  "See All",
                  style: kSubtitleTextSyule.copyWith(color: kBlueColor),
                ),
              ],
            ),
            SizedBox(height: 30),
            
          ],
        ),
      ),
    
    );
  }
}