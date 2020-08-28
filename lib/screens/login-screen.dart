import '../providers/google-http-client.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../providers/auth-manager.dart';


class LoginScreen extends StatelessWidget {
  Future _handleSignIn(BuildContext ctx) async {
    var account = await AuthManager.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await account.authentication;
    if (account != null) {
      final client = GoogleHttpClient(await account.authHeaders);
      Navigator.of(ctx).pushReplacementNamed('classroom-screen',arguments: client);
    }
    return null;
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
              onPressed: () => _handleSignIn(context), child: Text('login')),
          FlatButton(
              onPressed: () => AuthManager.signOut(), child: Text('logout')),
          
          
        ],
      ),
    ));
  }
}
