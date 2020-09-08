import 'package:animated_text_kit/animated_text_kit.dart';

import '../constants.dart';
import '../providers/classroom-manager.dart';
import 'package:provider/provider.dart';
import '../providers/google-http-client.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../providers/auth-manager.dart';

class LoginScreen extends StatelessWidget {
  Future _handleSignIn(BuildContext ctx) async {
    await Provider.of<AuthManager>(ctx).loginByBrowser();
    //var client=GoogleHttpClient(await account.authHeaders);
    var client = Provider.of<AuthManager>(ctx).client;
    if (client != null) {
      await Provider.of<ClassroomManager>(ctx).setClient(client);
      Navigator.of(ctx).pushReplacementNamed('course-screen');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      Container(
        height: double.infinity,
        alignment: Alignment.bottomCenter,
        child: Image.asset('assets/images/success2.png',fit:BoxFit.fitHeight,height: 250,),
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Image.asset('assets/icons/graduate.jpg'),
                height: 60.0,
              ),
              SizedBox(
                width: 10,
              ),
              TypewriterAnimatedTextKit(
                speed: Duration(milliseconds: 300),
                totalRepeatCount: 2,
                //repeatForever: true,
                text: [
                  'E Learning',
                ],
                textStyle: kHeadingextStyle,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          FlatButton(
              onPressed: () => _handleSignIn(context),
              child: Card(
                child: Container(
                  height: 40,
                  width: 130,
                  padding: EdgeInsets.only(left: 10),
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        'assets/icons/Gicon.png',
                        height: 32,
                        width: 28,
                      ),
                      Text(
                        '  Sign In',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                elevation: 8,
              )),
          // FlatButton(
          //     onPressed: () => AuthManager.signOut(), child: Text('logout')),
        ],
      ),
    ]));
  }
}
