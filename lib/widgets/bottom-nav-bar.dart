import 'package:flutter/material.dart';
import '../constants.dart';

class BottomNavBar extends StatelessWidget {
  final bool isChatActive;
  BottomNavBar(this.isChatActive);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      // color: Colors.white,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(30), topLeft: Radius.circular(30)),
        border: Border.all(width: 0.4),
        //image: DecorationImage(image:AssetImage('assets/images/virus.png',),fit: BoxFit.fitWidth)
      ),
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {},
            child: Container(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacementNamed('home-screen');
                },
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.home,
                      color: !isChatActive ? Colors.blue : kTextColor,
                      size: 40,
                    ),
                    Text(
                      'Home',
                      style: TextStyle(
                          color: !isChatActive ? Colors.blue : kTextColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
          VerticalDivider(
            color: Colors.grey,
            thickness: 0.8,
          ),
          Container(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacementNamed('chat-home-screen');
              },
              child: Column(
                children: <Widget>[
                  Image.asset(
                    'assets/icons/chat2.png',
                    width: 40,
                    color: isChatActive ? Colors.blue : kTextColor,
                  ),
                  Text(
                    'Chat',
                    style: TextStyle(
                        color: isChatActive ? Colors.blue : kTextColor),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
