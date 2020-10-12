import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import "package:googleapis_auth/auth_io.dart";
import 'package:url_launcher/url_launcher.dart';


class AuthManager with ChangeNotifier{

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences prefs;

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


  bool isLoading = false;
  bool isLoggedIn = false;
  User currentUser;
  static String firebaseUserId;
  var isSignedIn;

  static var _authClient;
	NetworkImage _profilePic;
  String _name;
  bool _isTeacher = true;

  Future signIn() async {

		isSignedIn = await googleSignIn.isSignedIn();
		print("isSIGNEDIN: $isSignedIn");

    prefs = await SharedPreferences.getInstance();
    isLoading = true;

    await prefs.setBool('isSignedIn', isSignedIn);

    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final isDone = await googleSignIn.requestScopes(scopes);
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    if (isDone) {
      final client = await googleSignIn.authenticatedClient();
      _authClient = client;
      _profilePic = NetworkImage(googleUser.photoUrl);
      _name = googleUser.displayName;
    }
    // GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    User firebaseUser =
        (await firebaseAuth.signInWithCredential(credential)).user;

    if (firebaseUser != null) {
      // Check is already sign up
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: firebaseUser.uid)
          .get();
      final List<DocumentSnapshot> documents = result.docs;
      if (documents.length == 0) {
        // Update data to server if new user
        print("New User in Firestore");
        FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .set({
          'nickname': firebaseUser.displayName,
          'photoUrl': firebaseUser.photoURL,
          'id': firebaseUser.uid,
          'modarrs': false,
          'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
          'chattingWith': null
        });

        // Write data to local
        currentUser = firebaseUser;
        await prefs.setString('id', currentUser.uid);
        await prefs.setString('nickname', currentUser.displayName);
        await prefs.setString('photoUrl', currentUser.photoURL);
      } else {
        // Write data to local
        print("Old User on Firestore");
        await prefs.setString('id', documents[0].data()['id']);
        await prefs.setBool('modarrs', documents[0].data()['modarrs']);
        await prefs.setString('nickname', documents[0].data()['nickname']);
        await prefs.setString('photoUrl', documents[0].data()['photoUrl']);
        await prefs.setString('aboutMe', documents[0].data()['aboutMe']);
      }
      Fluttertoast.showToast(msg: "Sign in success");
      isLoading = false;
      firebaseUserId = firebaseUser.uid;

    } else {
      Fluttertoast.showToast(msg: "Sign in fail");
      isLoading = false;
    }
    return null;
		// if (isSignedIn) {
		// await googleSignIn.signInSilently();
		// await googleSignIn.requestScopes(scopes);
		// //final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
		// _authClient = await googleSignIn.authenticatedClient();
		// return _authClient;
		// //print('account: ${account?.toString()}');
		// }else{
		// final GoogleSignIn googleSignIn =  GoogleSignIn.standard();
		// await googleSignIn.signIn();
		// await googleSignIn.requestScopes(scopes);
		// _authClient = await googleSignIn.authenticatedClient();
		// return _authClient;
		// }
	}

	Future<void> signOut() async {
		try {
      await FirebaseAuth.instance.signOut();
			await googleSignIn.disconnect();
			await googleSignIn.signOut();
			print("DISCONNECTED");
		} catch (error) {
			print(error);
		}
	}


		get client{
		return _authClient;
	}

  get userId{
    return firebaseUserId;
  }
  bool get isTeacher {
    return _isTeacher;
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
