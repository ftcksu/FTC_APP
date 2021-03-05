import 'package:flutter/material.dart';
import 'package:ftc_application/blocs/memberEventsBloc/bloc.dart';
import 'package:ftc_application/config/app_config.dart' as config;
import 'package:ftc_application/src/models/Event.dart';
import 'package:ftc_application/src/models/Member.dart';
import 'package:ftc_application/src/models/route_argument.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ftc_application/blocs/eventsBloc/bloc.dart';
import 'package:ftc_application/src/widgets/MemberWidgets/member_image.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final List<int> enlistedEvents;
  final String heroTag;
  final bool leaderView;
  final Member currentMember;
  final AnimationController animationController;
  final Animation animation;

  EventCard(
      {@required this.event,
      this.enlistedEvents,
      this.heroTag,
      this.leaderView = false,
      this.animationController,
      this.currentMember,
      this.animation});

  bool isUserEnlisted() {
    if (currentMember.id == event.leader.id) {
      return true;
    }
    if (enlistedEvents.contains(event.id)) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    _endEvent() {
      Alert(
        context: context,
        title: 'متأكد بتنهي الفعاليه؟',
        desc: 'محد بيقدر يرصد اعماله بعدها',
        buttons: [
          DialogButton(
            child: Text(
              "ايه",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              BlocProvider.of<EventsBloc>(context)
                  .add(ChangeEventStatus(eventId: event.id, status: true));
              BlocProvider.of<MemberEventsBloc>(context)
                  .add(GetCurrentMemberEvents());
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
    }

    Widget _userButtons() {
      if (event.full) {
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
      } else if (isUserEnlisted()) {
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
      } else if (event.full) {
        return RaisedButton(
            color: Colors.grey,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'امتلا العدد',
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
                      BlocProvider.of<EventsBloc>(context)
                          .add(AddCurrentMemberToEvent(eventId: event.id));
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

    Widget _eventStatus() {
      if (leaderView) {
        return event.finished
            ? Positioned(
                left: 10,
                top: 10,
                child: Text(
                  'انتهت الفعاليه',
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .merge(TextStyle(fontWeight: FontWeight.w600)),
                ))
            : Positioned(
                left: 10,
                top: 10,
                child: GestureDetector(
                  onTap: () => _endEvent(),
                  child: Icon(
                    Icons.clear,
                    color: Colors.red,
                  ),
                ));
      } else {
        return Container();
      }
    }

    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Stack(
                children: <Widget>[
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        Navigator.of(context).pushNamed('/EventDetails',
                            arguments: new RouteArgument(argumentsList: [
                              event,
                              heroTag,
                              currentMember
                            ]));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Hero(
                                        tag: heroTag + event.id.toString(),
                                        child: MemberImage(
                                          id: event.leader.id,
                                          hasProfileImage:
                                              event.leader.hasProfileImage,
                                          height: 65,
                                          width: 65,
                                          thumb: true,
                                        )),
                                    Text(
                                      event.leader.name,
                                    ),
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
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        event.title,
                                        overflow: TextOverflow.ellipsis,
                                        style:
                                            Theme.of(context).textTheme.subhead,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.calendar_today,
                                            color: Colors.black45,
                                          ),
                                          Text(
                                            event.date
                                                .toIso8601String()
                                                .split("T")[0],
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Divider(),
                            Text(
                              event.description.length > 150 && !leaderView
                                  ? event.description.substring(0, 130) + " ..."
                                  : event.description,
                              style: Theme.of(context).textTheme.body1,
                              textAlign: TextAlign.center,
                            ),
                            !leaderView
                                ? _userButtons()
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: RaisedButton(
                                              color: config.Colors()
                                                  .accentColor(1),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0)),
                                              padding: EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    'رصد الأعمال ',
                                                    style: new TextStyle(
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.white),
                                                  ),
                                                  Icon(
                                                    Icons.check,
                                                    color: Colors.white,
                                                  )
                                                ],
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pushNamed(
                                                    '/EventJobsApprovalScreen',
                                                    arguments:
                                                        new RouteArgument(
                                                            id: event.id
                                                                .toString(),
                                                            argumentsList: [
                                                          event.id
                                                        ]));
                                              }),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: RaisedButton(
                                              color: config.Colors()
                                                  .accentColor(1),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0)),
                                              padding: EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    'عدل الفعالية ',
                                                    style: new TextStyle(
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.white),
                                                  ),
                                                  Icon(
                                                    Icons.edit,
                                                    color: Colors.white,
                                                  )
                                                ],
                                              ),
                                              onPressed: () => Navigator.of(
                                                      context)
                                                  .pushNamed(
                                                      '/EventCreationScreen',
                                                      arguments: RouteArgument(
                                                          argumentsList: [
                                                            true,
                                                            currentMember,
                                                            event
                                                          ]))),
                                        ),
                                      )
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _eventStatus()
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
