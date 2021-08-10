import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:ftc_application/config/app_config.dart' as config;

class FirebaseNotifications {
  FirebaseMessaging? _firebaseMessaging;
  final GlobalKey<ScaffoldState> scaffoldKey;
  bool onReceive = true;
  FirebaseNotifications({required this.scaffoldKey});

  void setUpFirebase() async {
    _firebaseMessaging = FirebaseMessaging.instance;
    firebaseCloudMessagingListeners();
  }

  void firebaseCloudMessagingListeners() {
    if (Platform.isIOS) iosPermissions();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      if (onReceive) {
        onReceive = false;
        String title, notificationMessage;
        title = notification?.title as String;
        notificationMessage = notification?.body as String;
        _showNotification(title, notificationMessage);
      } else {
        onReceive = true;
      }
    });
  }

  Future<String?> getToken() async {
    return await _firebaseMessaging?.getToken();
  }

  Future<String?> getNewToken() async {
    return await _firebaseMessaging?.getToken();
  }

  void iosPermissions() {
    _firebaseMessaging?.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
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
      borderRadius: BorderRadius.all(Radius.circular(8)),
      backgroundGradient: LinearGradient(
        colors: [
          config.Colors().mainColor(1),
          config.Colors().accentColor(.8),
        ],
      ),
    )..show(scaffoldKey.currentState!.context);
  }
}
