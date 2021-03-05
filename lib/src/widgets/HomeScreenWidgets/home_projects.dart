import 'package:flutter/material.dart';
import 'package:ftc_application/src/models/Event.dart';
import 'package:ftc_application/src/models/Member.dart';
import 'package:ftc_application/src/models/route_argument.dart';
import 'package:ftc_application/src/widgets/HomeScreenWidgets/enlisted_project_whatsapp.dart';
import 'package:ftc_application/config/app_config.dart' as config;

class HomeProject extends StatelessWidget {
  final List<Event> events;
  final Member currentMember;
  final String heroTag = 'home_screen_event';
  HomeProject({this.events, this.currentMember});

  @override
  Widget build(BuildContext context) {
    _onGroupClick(Event event) async {
      Navigator.of(context).pushNamed('/EventDetails',
          arguments: new RouteArgument(
              argumentsList: [event, heroTag, currentMember]));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 10,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'المشاريع الي سجلت فيها',
                  style: Theme.of(context).textTheme.title,
                ),
              ),
              Divider(
                height: 0,
                color: config.Colors().divider(1),
                thickness: 1,
              ),
              ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => Divider(
                        height: 0,
                        color: config.Colors().divider(1),
                        thickness: 1,
                      ),
                  itemCount: events.length,
                  itemBuilder: (_, index) {
                    return EnlistedProject(
                      event: events[index],
                      onTap: _onGroupClick,
                      heroTag: heroTag,
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
