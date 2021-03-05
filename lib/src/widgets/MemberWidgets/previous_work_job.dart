import 'package:flutter/material.dart';
import 'package:ftc_application/config/app_config.dart' as config;
import 'package:ftc_application/src/models/Job.dart';
import 'package:ftc_application/src/models/route_argument.dart';

class PreviousJobCard extends StatelessWidget {
  final Job job;

  PreviousJobCard({this.job});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 8.0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              _getJobTitle(),
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
            RaisedButton(
              color: config.Colors().accentColor(1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'شف اعمالك',
                    style: new TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ],
              ),
              onPressed: () => Navigator.of(context).pushNamed(
                  '/PreviousWorkTasksScreen',
                  arguments:
                      new RouteArgument(id: job.id.toString(), argumentsList: [
                    job.jobType,
                    job.title,
                    job.id,
                  ])),
            ),
          ],
        ),
      ),
    );
  }

  String _getJobTitle() {
    if (job.jobType == "ADMIN") {
      return 'الاعمال الي من رئيسك';
    } else if (job.jobType == "SELF") {
      return 'اعمالك';
    } else {
      return job.title;
    }
  }
}
