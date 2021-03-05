import 'package:flutter/material.dart';
import 'package:ftc_application/config/app_config.dart' as config;
import 'package:ftc_application/src/models/Job.dart';
import 'package:ftc_application/src/models/route_argument.dart';
import 'package:ftc_application/src/widgets/MemberWidgets/member_image.dart';

class SubmitPointsJobCard extends StatelessWidget {
  final Job job;

  SubmitPointsJobCard(this.job);

  @override
  Widget build(BuildContext context) {
    final _indicator = Container(
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
          id: job.assignedMember.id,
          hasProfileImage: job.assignedMember.hasProfileImage,
          height: 75,
          width: 75,
          thumb: true,
        ),
      ),
    );
    var card = Card(
      margin: EdgeInsets.fromLTRB(15, 45, 15, 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 8.0,
      child: Padding(
        padding: EdgeInsets.all(25.0),
        child: Column(
          children: <Widget>[
            Text(
              job.assignedMember.name,
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
                onPressed: () => Navigator.of(context).pushNamed('/MemberTasks',
                    arguments: RouteArgument(argumentsList: [
                      job.assignedMember.name,
                      job.id,
                      job.assignedMember.id
                    ])),
              ),
            ),
          ],
        ),
      ),
    );
    return Stack(
      children: <Widget>[card, _indicator],
    );
  }
}
