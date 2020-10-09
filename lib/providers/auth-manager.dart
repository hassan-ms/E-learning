import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/classroom/v1.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import "package:googleapis_auth/auth_io.dart";
import 'package:url_launcher/url_launcher.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn.standard();
List<String> scopes = [
  'email',
  // ClassroomApi.ClassroomTopicsScope,
  // ClassroomApi.ClassroomRostersScope,
  'https://www.googleapis.com/auth/drive.file',
  'https://www.googleapis.com/auth/drive',
  'https://www.googleapis.com/auth/classroom.courses',
  'https://www.googleapis.com/auth/classroom.profile.emails',
  'https://www.googleapis.com/auth/classroom.profile.photos',
  'https://www.googleapis.com/auth/classroom.rosters',
  'https://www.googleapis.com/auth/classroom.coursework.students',
  'https://www.googleapis.com/auth/classroom.announcements',
  'https://www.googleapis.com/auth/classroom.coursework.me'
];

class AuthManager with ChangeNotifier {
  NetworkImage _profilePic;
  String _name;
  static var _authClient;
  bool _isTeacher = true;

  Future<void> signIn() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final isDone = await _googleSignIn.requestScopes(scopes);
      //final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      if (isDone) {
        final client = await _googleSignIn.authenticatedClient();
        _authClient = client;
        _profilePic = NetworkImage(googleUser.photoUrl);
        _name = googleUser.displayName;
      }

      //print('account: ${account?.toString()}');
    } catch (error) {
      print(error);
    }
  }

  get client {
    return _authClient;
  }

  bool get isTeacher {
    return _isTeacher;
  }

  static Future<GoogleSignInAccount> signInSilently() async {
    var account = await _googleSignIn.signInSilently();
    print('account: $account');
    return account;
  }

  Future<void> signOut() async {
    try {
      _googleSignIn.disconnect();
    } catch (error) {
      throw error;
    }
  }

  Future<AutoRefreshingAuthClient> loginByBrowser() async {
    var id = new ClientId(
        "19932950879-18t9khm302m9n9t7m439t95kcpsdr24q.apps.googleusercontent.com",
        "");
    //var client = new http.Client();
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
    var client = await clientViaUserConsent(id, [
      'email',
      //ClassroomApi.ClassroomCoursesScope,
      'https://www.googleapis.com/auth/classroom.courses',

      'https://www.googleapis.com/auth/classroom.profile.emails',
      'https://www.googleapis.com/auth/classroom.rosters',
      'https://www.googleapis.com/auth/classroom.coursework.students',
      'https://www.googleapis.com/auth/classroom.announcements',
      'https://www.googleapis.com/auth/drive.file',
      'https://www.googleapis.com/auth/classroom.coursework.me'
    ], (url) {
      launch(url);
    });
    _authClient = client;
    return client;
  }

  NetworkImage get profilePic {
    return _profilePic;
  }

  String get name {
    return _name;
  }
}
