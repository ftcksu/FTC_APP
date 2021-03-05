import 'package:flutter/material.dart';
import 'package:ftc_application/config/app_config.dart' as config;
import 'package:ftc_application/src/models/Event.dart';
import 'package:ftc_application/src/widgets/MemberWidgets/member_image.dart';

class SubmitPointsEventCard extends StatelessWidget {
  final Event event;
  final Function onClick;
  SubmitPointsEventCard(this.event, this.onClick);

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
            id: event.leader.id,
            hasProfileImage: event.leader.hasProfileImage,
            height: 80,
            width: 80,
            thumb: true,
          )),
    );
    var card = Card(
      margin: EdgeInsets.fromLTRB(10, 55, 10, 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 8.0,
      child: Padding(
        padding: EdgeInsets.all(25.0),
        child: Column(
          children: <Widget>[
            Text(
              event.title,
              style: Theme.of(context).textTheme.title,
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
                event.description,
                maxLines: null,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w200),
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
                onPressed: () => onClick(event.id),
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
