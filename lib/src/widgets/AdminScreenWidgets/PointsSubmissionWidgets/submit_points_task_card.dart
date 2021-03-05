import 'package:flutter/material.dart';

import 'package:ftc_application/config/app_config.dart' as config;
import 'package:ftc_application/src/models/Task.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SubmitPointsTaskCard extends StatelessWidget {
  final Task task;
  final Function submit;
  final int index;
  SubmitPointsTaskCard({this.task, this.submit, this.index});

  @override
  Widget build(BuildContext context) {
    int _points = 0;

    return Card(
      margin: EdgeInsets.fromLTRB(15, 45, 15, 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 8.0,
      child: Padding(
        padding: EdgeInsets.all(25.0),
        child: Column(
          children: <Widget>[
            Text(
              task.description,
              style: Theme.of(context).textTheme.title,
            ),
            TextField(
              autofocus: index==0,
              showCursor: false,
              textDirection: TextDirection.rtl,
              keyboardType:
                  TextInputType.numberWithOptions(decimal: true, signed: true),
              maxLines: null,
              maxLength: 3,
              onChanged: (value) {
                _points = int.parse(value);
              },
              onSubmitted: (e) => _onSubmit(_points,context),
              decoration: InputDecoration(
                hintText: 'كم تقيمه',
                hintStyle: TextStyle(
                  color: config.Colors().divider(1),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                color: config.Colors().accentColor(1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'ارصدني',
                      style: new TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ],
                ),
                onPressed: () => _onSubmit(_points,context),
              ),
            ),
          ],
        ),
      ),
    );
  }
  _onSubmit(_points,context) {
    print(_points);
    if (_points < 0) {
      Alert(
        context: context,
        title: 'مو هنا تخصم',
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
        title: 'شكرا لتعبك ياحلو',
        buttons: [
          DialogButton(
            child: Text(
              "عفوا فيصل",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ).show().whenComplete(() {
        Map<String, dynamic> payload = {
          "approval_status": "APPROVED",
          "points": _points
        };
        submit(task, payload, index);
        FocusScope.of(context).requestFocus(FocusNode());
      });
    }
  }

}
