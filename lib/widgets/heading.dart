import 'package:flutter/material.dart';

import '../constants.dart';

class Heading extends StatelessWidget {
  final String title;
  const Heading(
    this.title,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
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
            title,
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
    );
  }
}
