import 'package:flutter/material.dart';
import 'package:ftc_application/config/app_config.dart' as config;
import 'package:ftc_application/src/models/Member.dart';
import 'package:ftc_application/src/models/route_argument.dart';
import 'package:ftc_application/src/widgets/MemberWidgets/member_image.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class EventDetailsBottom extends StatelessWidget {
  final List<Member> members;
  final bool isUserEnlisted;
  final bool full;
  final Function addMember;
  final Member currentMember;

  EventDetailsBottom(
      {this.members,
      this.full,
      this.isUserEnlisted,
      this.addMember,
      this.currentMember});

  @override
  Widget build(BuildContext context) {
    Widget _userButtons() {
      if (isUserEnlisted) {
        return RaisedButton(
            color: Colors.grey,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'محجوز',
                  style: new TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                Icon(
                  Icons.event_seat,
                  color: Colors.white,
                )
              ],
            ),
            onPressed: () => null);
      } else if (full) {
        return RaisedButton(
            color: Colors.grey,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'أمتلا العدد',
                  style: new TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                Icon(
                  Icons.event_seat,
                  color: Colors.white,
                )
              ],
            ),
            onPressed: () => null);
      } else {
        return RaisedButton(
            color: config.Colors().accentColor(1),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'احجز مقعد ',
                  style: new TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                Icon(
                  Icons.event_seat,
                  color: Colors.white,
                )
              ],
            ),
            onPressed: () {
              Alert(
                context: context,
                title: 'متأكد بتدخل؟',
                buttons: [
                  DialogButton(
                    child: Text(
                      "ايه",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () {
                      addMember();
                      Navigator.pop(context);
                    },
                  ),
                  DialogButton(
                    child: Text(
                      "اسف لأ",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ).show();
            });
      }
    }

    return Card(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 8.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'الأعضاء المشاركين',
                style: Theme.of(context).textTheme.title,
              ),
            ),
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: members.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed('/MemberDetails',
                        arguments: new RouteArgument(
                            id: members[index].id.toString(),
                            argumentsList: [
                              members[index],
                              'event_bootom_member',
                              currentMember
                            ]));
                  },
                  leading: Hero(
                    tag: "event_bootom_member" + members[index].id.toString(),
                    child: MemberImage(
                      id: members[index].id,
                      hasProfileImage: members[index].hasProfileImage,
                      height: 45,
                      width: 45,
                      thumb: true,
                    ),
                  ),
                  title: Text(
                    members[index].name,
                    style: TextStyle(fontSize: 18),
                  ),
                );
              },
              separatorBuilder: (context, index) => Divider(
                color: config.Colors().divider(1),
                height: 0,
                thickness: 1,
              ),
            ),
            Divider(
              color: config.Colors().divider(1),
              height: 0,
              thickness: 1,
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _userButtons(),
            )
          ],
        ),
      ),
    );
  }
}
