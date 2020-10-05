import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(233, 233, 241, 0.6),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 120,
          ),
          Container(
              alignment: Alignment.center,
              child: Hero(
                tag: 1,
                child: CircleAvatar(
                  child: Image.asset(
                    'assets/images/st2.png',
                  ),
                  radius: 80,
                  backgroundColor: Colors.transparent,
                   
                ),
              )),
          // SizedBox(height: 10,),
          Text(
            'Hassan',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            height: 60,
          ),
          buildItem('Home', Icons.home),
          buildItem('Setting', Icons.settings),
          buildItem('Profile', Icons.person),
          buildItem('Logout', Icons.exit_to_app),
        ],
      )),
    );
  }

  Container buildItem(title, icon) {
    return Container(
      alignment: Alignment.center,
      // color: Colors.white,
      width: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 0.5, color: Colors.white),
        borderRadius: BorderRadius.circular(25),
      ),
      margin: EdgeInsets.only(bottom: 30),
      padding: EdgeInsets.only(top: 2, bottom: 2, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Color.fromRGBO(58, 114, 237, 1),
            size: 30,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            title,
            style: TextStyle(
                color: Color.fromRGBO(58, 114, 237, 1),
                fontSize: 20,
                fontWeight: FontWeight.w700),
          )
        ],
      ),
    );
  }
}
