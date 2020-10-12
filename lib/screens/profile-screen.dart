import 'package:elearning4/providers/auth-manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final profilePic =
        Provider.of<AuthManager>(context, listen: false).profilePic;
    final name = Provider.of<AuthManager>(context, listen: false).name;
    return Scaffold(
      backgroundColor: Colors.white24,
      //backgroundColor: Color.fromRGBO(233, 233, 241, 0.6),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 80,
          ),
          Container(
              alignment: Alignment.center,
              child: Hero(
                tag: 1,
                child: CircleAvatar(
                  backgroundImage: profilePic == null
                      ? AssetImage('assets/images/st2.png')
                      : profilePic,
                  radius: 80,
                  backgroundColor: Colors.transparent,
                ),
              )),
          SizedBox(
            height: 20,
          ),
          Text(
            name,
            style: TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 40,
          ),
          buildItem('Home', Icons.home),
          InkWell(child: buildItem('invitaions', Icons.settings),onTap: (){
            Navigator.of(context).pushReplacementNamed('invitations-screen');
          },),
          buildItem('Profile', Icons.person),
          InkWell(
            child: buildItem('Logout', Icons.exit_to_app),
            onTap: ()async {
              try {
                await Provider.of<AuthManager>(context,listen: false).signOut();
                Navigator.of(context).pushReplacementNamed('login-screen');
              } catch (e) {
                Scaffold.of(context).showSnackBar(
                  SnackBar(content: Text('network error please try again')),
                );
              }
            },
          ),
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
        color: Color.fromRGBO(233, 233, 241, 0.6),
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
            color: Colors.black,
            //color: Color.fromRGBO(58, 114, 237, 1),
            size: 30,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            title,
            style: TextStyle(
                //color: Color.fromRGBO(58, 114, 237, 1),
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w700),
          )
        ],
      ),
    );
  }
}
