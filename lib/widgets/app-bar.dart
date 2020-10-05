import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
class TheAppBar extends StatelessWidget {
  const TheAppBar({
    Key key,
     size,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        //color: Colors.white,
        border: Border(bottom: BorderSide(width: 0.15)),
      ),
      margin: EdgeInsets.only(bottom: 20,),
      padding: EdgeInsets.only(right: 10,bottom: 10,top: 10),
     // height: 70,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(icon :SvgPicture.asset("assets/icons/menu.svg",),onPressed: (){
              
            },),
            Text("E-learning", style: kHeadingextStyle.copyWith(fontSize: 25)),
            FlatButton(child: Hero(child: Image.asset("assets/images/user.png"),tag: 1,),onPressed:(){
              Navigator.of(context).pushNamed('profile-screen');
            } ,),
          ],
        ),
    );
  }
}

