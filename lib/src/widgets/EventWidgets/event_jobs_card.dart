import 'package:flutter/material.dart';
import 'package:ftc_application/config/app_config.dart' as config;
import 'package:ftc_application/src/models/Job.dart';
import 'package:ftc_application/src/models/route_argument.dart';
import 'package:ftc_application/src/widgets/MemberWidgets/member_image.dart';

class EventsJobCard extends StatelessWidget {
  final int eventId;
  final Job job;
  EventsJobCard({this.job, this.eventId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: -5,
                left: 0,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blueAccent,
                    border: Border.all(
                      color: Colors.blueAccent,
                      width: 10,
                    ),
                  ),
                  child: Text(
                    job.waitingTasks.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          MemberImage(
                            id: job.assignedMember.id,
                            hasProfileImage: job.assignedMember.hasProfileImage,
                            height: 55,
                            width: 55,
                            thumb: true,
                          ),
                          Text(job.assignedMember.name),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 1,
                          height: 30,
                          color: Colors.black12,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          job.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .title
                              .merge(TextStyle(fontWeight: FontWeight.w500)),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: config.Colors().divider(1),
                    thickness: 1,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: RaisedButton(
                            color: config.Colors().accentColor(1),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 12),
                            child: Text(
                              'ارصد اعماله',
                              style: new TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                            onPressed: () => Navigator.of(context).pushNamed(
                                '/EventTasksSubmit',
                                arguments: new RouteArgument(
                                    id: job.id.toString(),
                                    argumentsList: [
                                      job.id,
                                      job.assignedMember,
                                      eventId
                                    ])),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
