import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ftc_application/blocs/notificationBloc/bloc.dart';
import 'package:ftc_application/config/app_config.dart' as config;
import 'package:ftc_application/src/models/PushNotificationRequest.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SendNotificationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String adminMessage = "";

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 8.0, bottom: 5.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 8.0,
        child: Padding(
          padding: EdgeInsets.all(25.0),
          child: Column(
            children: <Widget>[
              Text(
                'ارسل تنبيهك',
                style: Theme.of(context).textTheme.title,
              ),
              Container(
                child: TextField(
                  autofocus: true,
                  textDirection: TextDirection.rtl,
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  onChanged: (string) => adminMessage = string,
                  decoration: InputDecoration(
                    hintText: 'اكتب تنبيهك',
                    hintStyle: TextStyle(
                      color: config.Colors().divider(1),
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 30.0)),
              RaisedButton(
                color: config.Colors().accentColor(1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'ارسلها',
                      style: new TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ],
                ),
                onPressed: () {
                  if (adminMessage.length < 5) {
                    Alert(
                      context: context,
                      title: 'اكتب اكثر من كم حرف لوسمحت',
                      buttons: [
                        DialogButton(
                          child: Text(
                            "اسف فيصل",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    ).show();
                  } else {
                    Alert(
                      context: context,
                      title: 'بينرسل تنبيهك ياحلو',
                      buttons: [
                        DialogButton(
                          child: Text(
                            "شكرا فيصل",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    ).show().whenComplete(() {
                      BlocProvider.of<NotificationBloc>(context).add(
                          AdminSendNotification(
                              notification: PushNotificationRequest.admin(
                                  'تنبيه من الرئيس', adminMessage)));
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
