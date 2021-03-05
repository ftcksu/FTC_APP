import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:ftc_application/config/app_config.dart' as config;

class FirebaseNotifications {
  FirebaseMessaging _firebaseMessaging;
  final GlobalKey<ScaffoldState> scaffoldKey;
  bool onReceive = true;
  FirebaseNotifications(this.scaffoldKey);

  void setUpFirebase() async {
    _firebaseMessaging = FirebaseMessaging();
    firebaseCloudMessagingListeners();
  }

  void firebaseCloudMessagingListeners() {
    if (Platform.isIOS) iosPermissions();
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      if (onReceive) {
        onReceive = false;
        String title, notificationMessage;
        title = message['notification']['title'] as String;
        notificationMessage = message['notification']['body'] as String;
        _showNotification(title, notificationMessage);
      } else {
        onReceive = true;
      }
    }, onResume: (Map<String, dynamic> message) async {
      print('on resume $message');
    }, onLaunch: (Map<String, dynamic> message) async {
      print('on launch $message');
    });
  }

  Future<String> getToken() async {
    String token = await _firebaseMessaging.getToken();
    _firebaseMessaging.subscribeToTopic('FTC-APP');
    return token;
  }

  Future<String> getNewToken() async {
    return await _firebaseMessaging.getToken();
  }

  void subscribe() async {
    _firebaseMessaging.subscribeToTopic('FTC-APP');
  }

  void iosPermissions() {
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {});
  }

  _showNotification(String title, String notificationMessage) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      titleText: Text(
        title,
        textAlign: TextAlign.right,
        style: TextStyle(color: Colors.white),
      ),
      icon: ImageIcon(
        AssetImage('assets/images/transperant_logo.png'),
        size: 28.0,
        color: Colors.white,
      ),
      messageText: Text(
        notificationMessage,
        textAlign: TextAlign.right,
        style: TextStyle(color: Colors.white),
      ),
      margin: EdgeInsets.all(8),
      duration: Duration(seconds: 2),
      borderColor: Colors.white,
      borderRadius: 8,
      backgroundGradient: LinearGradient(
        colors: [
          config.Colors().mainColor(1),
          config.Colors().accentColor(.8),
        ],
      ),
    )..show(scaffoldKey.currentState.context);
  }
}
