import 'package:flutter/material.dart';
import 'package:ftc_application/config/app_config.dart' as config;
import 'package:ftc_application/src/widgets/AdminScreenWidgets/send_notification_card.dart';

class SendNotificationScreen extends StatefulWidget {
  @override
  _SendNotificationScreenState createState() => _SendNotificationScreenState();
}

class _SendNotificationScreenState extends State<SendNotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('ارسل تنبيه'),
          backgroundColor: Colors.deepPurpleAccent,
          elevation: 8,
          leading: IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                config.Colors().mainColor(1),
                config.Colors().accentColor(.8),
              ],
            ),
          ),
          child: Column(
            children: <Widget>[
              SendNotificationCard(),
            ],
          ),
        ),
      ),
    );
  }
}
