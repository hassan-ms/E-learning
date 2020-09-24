import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:googleapis/classroom/v1.dart';
//import "package:googleapis_auth/auth_io.dart";
//import 'package:url_launcher/url_launcher.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn.standard();
List<String> scopes = [
    'email',
    ClassroomApi.ClassroomCoursesScope,
    ClassroomApi.ClassroomTopicsScope,
    ClassroomApi.ClassroomRostersScope,
    'https://www.googleapis.com/auth/classroom.profile.emails',
    'https://www.googleapis.com/auth/classroom.rosters',
    'https://www.googleapis.com/auth/classroom.coursework.students',
    'https://www.googleapis.com/auth/classroom.announcements',
    'https://www.googleapis.com/auth/classroom.coursework.students.readonly',
    'https://www.googleapis.com/auth/classroom.coursework.me.readonly',
    'https://www.googleapis.com/auth/classroom.coursework.me'
  ];

class AuthManager with ChangeNotifier{


  static var _authClient;
  Future signIn() async {
  try {
    await _googleSignIn.signInSilently();
    await _googleSignIn.requestScopes(scopes);
    //final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    return await _googleSignIn.authenticatedClient();
    //print('account: ${account?.toString()}');
  } catch (error) {
    print(error);
    await _googleSignIn.signIn();
    await _googleSignIn.requestScopes(scopes);
    return await _googleSignIn.authenticatedClient();
    }
  }
    get client{
    return _authClient;
  }

  // TODO: Silent sign in
   static Future<GoogleSignInAccount> signInSilently() async {
    var account = _googleSignIn.signInSilently();
    print('account: $account');
    return account;
   }

  static Future<void> signOut() async {
    try {
      _googleSignIn.signOut();
      print("DISCONNECTED");
    } catch (error) {
      print(error);
    }
  }
//    Future<AutoRefreshingAuthClient> loginByBrowser()async{
//     var id = new ClientId("19932950879-18t9khm302m9n9t7m439t95kcpsdr24q.apps.googleusercontent.com", "");
//     var client = new http.Client();
// obtainAccessCredentialsViaUserConsent(id, [
//     'email',
//     ClassroomApi.ClassroomCoursesScope,
//     'https://www.googleapis.com/auth/classroom.profile.emails',
//     'https://www.googleapis.com/auth/classroom.rosters',
//     'https://www.googleapis.com/auth/classroom.coursework.students' 
//   ], client, (url){
//     launch(url);
//   })
//     .then((AccessCredentials credentials) {
//       print(credentials.accessToken);

//   client.close();
// });
//   var client = await clientViaUserConsent(id, [
//     'email',
//     ClassroomApi.ClassroomCoursesScope,
//     'https://www.googleapis.com/auth/classroom.profile.emails',
//     'https://www.googleapis.com/auth/classroom.rosters',
//     'https://www.googleapis.com/auth/classroom.coursework.students',
//     'https://www.googleapis.com/auth/classroom.announcements',
//     'https://www.googleapis.com/auth/classroom.coursework.students.readonly',
//     'https://www.googleapis.com/auth/classroom.coursework.me.readonly',
//     'https://www.googleapis.com/auth/classroom.coursework.me'
//   ], (url){
//     launch(url);
//   });
//      _authClient=client;
//      return client;
//   }
}