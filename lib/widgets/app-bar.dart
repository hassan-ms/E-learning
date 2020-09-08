import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
class TheAppBar extends StatelessWidget {
  const TheAppBar({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        //color: Colors.white,
        border: Border(bottom: BorderSide(width: 0.15)),
      ),
      margin: EdgeInsets.only(bottom: size.height * 0.02,),
      padding: EdgeInsets.only(right: 10),
      height: size.height * 0.1,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(icon :SvgPicture.asset("assets/icons/menu.svg",),onPressed: (){},),
            Text("E-learning", style: kHeadingextStyle.copyWith(fontSize: 25)),
            Image.asset("assets/images/user.png"),
          ],
        ),
    );
  }
}

