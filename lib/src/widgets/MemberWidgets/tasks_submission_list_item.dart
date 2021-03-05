import 'package:flutter/material.dart';
import 'package:ftc_application/src/models/Task.dart';
import 'package:ftc_application/config/app_config.dart' as config;
import 'package:ftc_application/src/widgets/MemberWidgets/member_image.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class EventTasksApproveLeader extends StatefulWidget {
  final Task task;
  final int memberId;
  final String memberName;
  final bool hasImage;
  final Function onAccept, onReject;

  EventTasksApproveLeader(
      {this.task,
      this.memberId,
      this.memberName,
      this.hasImage,
      this.onAccept,
      this.onReject});

  @override
  _EventTasksApproveLeaderState createState() =>
      _EventTasksApproveLeaderState();
}

class _EventTasksApproveLeaderState extends State<EventTasksApproveLeader> {
  @override
  Widget build(BuildContext context) {
    final _workOwner = Container(
      alignment: FractionalOffset.topCenter,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 3,
          ),
        ),
        child: MemberImage(
          id: widget.memberId,
          hasProfileImage: widget.hasImage,
          height: 65,
          width: 65,
          thumb: false,
        ),
      ),
    );
    var card = Card(
      margin: EdgeInsets.fromLTRB(10, 40, 10, 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 8.0,
      child: Padding(
        padding: EdgeInsets.all(25.0),
        child: ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Center(
              child: Text(
                widget.memberName,
                style: Theme.of(context).textTheme.title,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(
                color: config.Colors().divider(1),
                height: 0,
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.task.description,
                maxLines: null,
                style: Theme.of(context).textTheme.body1,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: RaisedButton(
                        onPressed: () {
                          Alert(
                            context: context,
                            title: 'متأكد بتقبل؟',
                            buttons: [
                              DialogButton(
                                child: Text(
                                  "ايه",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () {
                                  widget.onAccept(widget.task.id);
                                  Navigator.pop(context);
                                },
                              ),
                              DialogButton(
                                child: Text(
                                  "اسف لأ",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () => Navigator.pop(context),
                              )
                            ],
                          ).show();
                        },
                        color: config.Colors().accentColor(1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'اقبل',
                              style: new TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: RaisedButton(
                          color: config.Colors().accentColor(1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'ارفض',
                                style: new TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          onPressed: () {
                            Alert(
                              context: context,
                              title: 'متأكد بترفض؟',
                              buttons: [
                                DialogButton(
                                  child: Text(
                                    "ايه",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  onPressed: () {
                                    widget.onReject(widget.task.id);
                                    Navigator.pop(context);
                                  },
                                ),
                                DialogButton(
                                  child: Text(
                                    "اسف لأ",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                )
                              ],
                            ).show();
                          }),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
    return Stack(
      children: <Widget>[card, _workOwner],
    );
  }
}
