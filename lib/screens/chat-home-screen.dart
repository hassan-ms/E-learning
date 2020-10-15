import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearning4/screens/course-screen.dart';
import 'package:elearning4/widgets/app-bar.dart';
import 'package:elearning4/widgets/bottom-nav-bar.dart';
import 'package:elearning4/widgets/heading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:elearning4/constants.dart';
import 'package:elearning4/widgets/loading.dart';
import 'chat-chat-screen.dart';
import 'chat-settings-screen.dart';

class ChatHomeScreen extends StatefulWidget {
  ChatHomeScreen({
    Key key,
  }) : super(key: key);

  @override
  State createState() => ChatHomeScreenState();
}

class ChatHomeScreenState extends State<ChatHomeScreen> {
  ChatHomeScreenState({
    Key key,
  });

  var currentUserId;
  bool toSeeModarrs;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    registerNotification();
    configLocalNotification();
    setUserId();
  }

  void setUserId() async {
    final prefs = await SharedPreferences.getInstance();
    currentUserId = prefs.getString('id');
    toSeeModarrs = !prefs.getBool('modarrs');
    // print(toSeeModarrs.toString());
  }

  // bool checkModarrs(){
  //   if (element.get('modarrs') == modarrs){
  //     return false;
  //   }else{
  //     return true;
  //   }
  // }

  void registerNotification() {
    firebaseMessaging.requestNotificationPermissions();

    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
      Platform.isAndroid
          ? showNotification(message['notification'])
          : showNotification(message['aps']['alert']);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      return;
    });

    firebaseMessaging.getToken().then((token) {
      print('token: $token');
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .update({'pushToken': token});
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
  }

  void configLocalNotification() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid ? 'com.wrl.E-Learning' : 'com.wrl.E-Learning',
      'E-Learning',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    print(message);
//    print(message['body'].toString());
//    print(json.encode(message));

    await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
        message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));

//    await flutterLocalNotificationsPlugin.show(
//        0, 'plain title', 'plain body', platformChannelSpecifics,
//        payload: 'item x');
  }

  Future<bool> onBackPress() {
    //openDialog();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => CourseScreen()),
        (route) => false);
    return Future.value(false);
  }

  Stream<dynamic> modQuery() {
    Stream<QuerySnapshot> q = FirebaseFirestore.instance
        .collection('users')
        .where('modarrs', isEqualTo: toSeeModarrs)
        .snapshots();
    var m = q.forEach((element) {
      element.docs.forEach((element) {
        print(element.data());
      });
    });
    print(m);
    return q;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(true),
      // appBar: AppBar(
      //   title: Text(
      //     'Chat',
      //     style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
      //   ),
      //   centerTitle: true,
      //   actions: <Widget>[
      //     IconButton(
      //       icon: Icon(Icons.settings),
      //       onPressed: () => Navigator.push(context,
      //           MaterialPageRoute(builder: (context) => ChatSettings())),
      //     ),
      //   ],
      // ),
      body: SafeArea(
        child: Column(
          children: [
            TheAppBar(),
            Heading('Chat'),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Stack(
                children: <Widget>[
                  // List
                  StreamBuilder(
                    stream: modQuery(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(themeColor),
                          ),
                        );
                      } else {
                        return ListView.builder(
                          padding: EdgeInsets.all(10.0),
                          itemBuilder: (context, index) =>
                              buildItem(context, snapshot.data.docs[index]),
                          itemCount: snapshot.data.docs.length,
                        );
                      }
                    },
                  ),

                  // Loading
                  Positioned(
                    child: isLoading ? const Loading() : Container(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    if (document.data()['id'] == currentUserId) {
      return Container();
    } else {
      return Container(
        child: FlatButton(
          child: Row(
            children: <Widget>[
              Material(
                child: document.data()['photoUrl'] != null
                    ? CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          child: CircularProgressIndicator(
                            strokeWidth: 1.0,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(themeColor),
                          ),
                          width: 50.0,
                          height: 50.0,
                          padding: EdgeInsets.all(15.0),
                        ),
                        imageUrl: document.data()['photoUrl'],
                        width: 50.0,
                        height: 50.0,
                        fit: BoxFit.cover,
                      )
                    : Icon(
                        Icons.account_circle,
                        size: 50.0,
                        color: greyColor,
                      ),
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                clipBehavior: Clip.hardEdge,
              ),
              Flexible(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          ' ${document.data()['nickname']}',
                          style: TextStyle(color: primaryColor),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                      ),
                      // additional information for user
                    ],
                  ),
                  margin: EdgeInsets.only(left: 20.0),
                ),
              ),
            ],
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Chat(
                          peerId: document.id,
                          peerAvatar: document.data()['photoUrl'],
                        )));
          },
          color: greyColor2,
          padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
      );
    }
  }
}
