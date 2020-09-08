import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
class ClassItem extends StatelessWidget {
  final title;
  final svg;
  const ClassItem({
    @required this.title,
    @required this.svg,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(
            svg,
            height: 120,
            
          ),
          Text(
            title,
            style: kSubheadingextStyle.copyWith(
                fontSize: 17, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
