import 'package:flutter/material.dart';
import 'package:ftc_application/config/app_config.dart' as config;
import 'package:ftc_application/src/models/Task.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class PreviousWorkTaskCard extends StatelessWidget {
  final Task task;
  final String jobType;
  final String jobTitle;
  final Function editTask;
  PreviousWorkTaskCard({this.task, this.editTask, this.jobType, this.jobTitle});

  @override
  Widget build(BuildContext context) {
    String _input = "";

    _bottomSheet() {
      _onPress() {
        if (_input.length < 5) {
          Alert(
            context: context,
            title: 'اكتب اكثر من كم حرف لوسمحت',
            buttons: [
              DialogButton(
                child: Text(
                  "اسف فيصل",
                  style: TextStyle(
                      color: Colors.white, fontSize: 20),
                ),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ).show();
        } else {
          Alert(
            context: context,
            title: 'تم رصد عملك شكرا ياحلو',
            buttons: [
              DialogButton(
                child: Text(
                  "شكرا اسم الشخص هنا",
                  style: TextStyle(
                      color: Colors.white, fontSize: 20),
                ),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ).show().then((onValue) {
            Navigator.pop(context);
          });
        }
      }
      return showBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: Colors.white,
          builder: (context) => Container(
                margin: const EdgeInsets.only(top: 5, left: 15, right: 15),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(children: [
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10)),
                          child: TextField(
                            autofocus: true,
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            keyboardType: TextInputType.text,
                            maxLines: null,
                            onChanged: (string) => _input = string,
                            onSubmitted: (e) => _onPress(),
                            decoration: InputDecoration(
                              hintText: 'عدل',
                              hintStyle: TextStyle(
                                color: config.Colors().divider(1),
                              ),
                            ),
                          ),
                        ),
                        MaterialButton(
                            color: Colors.grey[800],
                            onPressed: _onPress,
                            child: Text(
                              'عدل',
                              style: TextStyle(color: Colors.white),
                            )),
                      ])
                    ]),
              )).closed.then((value) {
        editTask(task, _input);
      });
    }

    Widget _getAction() {
      if (task.approvalStatus == 'READY') {
        if (jobType == "SELF") {
          return RaisedButton(
            onPressed: () {
              _bottomSheet();
            },
            child: Text('Edit'),
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),
                side: BorderSide(color: config.Colors().accentColor(1))),
          );
        } else {
          return Container();
        }
      } else if (task.approvalStatus == 'APPROVED') {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'النقاط: ' + task.points.toString(),
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.grey[600]),
          ),
        );
      } else {
        return RaisedButton(
          onPressed: () {
            _bottomSheet();
          },
          child: Text('Edit'),
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(18.0),
              side: BorderSide(color: config.Colors().accentColor(1))),
        );
      }
    }

    return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 18.0,
        ),
        child: Container(
          height: 200,
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 10),
                )
              ]),
          child: Container(
            margin: EdgeInsets.fromLTRB(12.0, 16.0, 18.0, 16.0),
            constraints: BoxConstraints.expand(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 4.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      _getTitle(),
                      style: Theme.of(context)
                          .textTheme
                          .title
                          .merge(TextStyle(fontSize: 20)),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      _getStatus(),
                      style: Theme.of(context).textTheme.subhead.merge(
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    )
                  ],
                ),
                SizedBox(height: 10.0),
                Text(
                  task.description,
                  style: Theme.of(context).textTheme.subhead,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    height: 2.0,
                    width: 18.0,
                    color: Colors.deepPurpleAccent),
                Row(
                  children: <Widget>[_getAction()],
                )
              ],
            ),
          ),
        ));
  }

  bool isNullEmpty(String o) => o == null || "" == o;

  String _getStatus() {
    if (task.approvalStatus == 'READY') {
      if (jobType == "SELF") {
        return 'بعده مارصدلك رئيسك';
      } else {
        return 'مقبول من راعي الفعالية';
      }
    } else if (task.approvalStatus == 'APPROVED') {
      return 'مرصود من رئيسك الحلو';
    } else if (task.approvalStatus == 'WAITING') {
      return 'جديد توه';
    } else {
      return 'زبال عدله لوسمحت';
    }
  }

  String _getTitle() {
    if (jobType == 'EVENT') {
      return jobTitle;
    } else if (jobType == 'ADMIN') {
      return 'من رئيسك';
    } else {
      return 'من يدينك';
    }
  }
}
