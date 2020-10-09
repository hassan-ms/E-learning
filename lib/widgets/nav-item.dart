import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants.dart';
class NavItem extends StatelessWidget {
  final String svgSrc;
  final String title;
  final bool isActive;
  const NavItem({
    Key key, this.svgSrc, this.title, this.isActive=false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (){},
          child: Column(
        children: <Widget>[
          SvgPicture.asset(svgSrc,color: isActive?Colors.blue:kTextColor,),
          Text(title,style: TextStyle(color: isActive?Colors.blue:kTextColor),), 
        ],
      ),
    );
  }
}
