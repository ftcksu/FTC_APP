import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ftc_application/blocs/eventsBloc/bloc.dart';
import 'package:ftc_application/blocs/eventsBloc/events_bloc.dart';
import 'package:ftc_application/blocs/memberBloc/bloc.dart';
import 'package:ftc_application/blocs/memberEventsBloc/bloc.dart';
import 'package:ftc_application/config/app_config.dart' as config;
import 'package:ftc_application/src/models/Event.dart';
import 'package:ftc_application/src/models/Member.dart';
import 'package:ftc_application/src/models/route_argument.dart';
import 'package:ftc_application/src/widgets/EventWidgets/EventDetailsWidgets/event_details_bottom.dart';
import 'package:ftc_application/src/widgets/EventWidgets/EventDetailsWidgets/event_details_top.dart';
import 'package:ftc_application/src/widgets/EventWidgets/share_event_widget.dart';
import 'package:ftc_application/src/widgets/loading_widget.dart';

class EventDetails extends StatefulWidget {
  final RouteArgument routeArgument;

  EventDetails({Key key, this.routeArgument});

  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  List<Member> members;
  Event event;
  String _heroTag;
  Member currentMember;
  bool eventMembersLoaded = false;

  bool isUserEnlisted() {
    if (currentMember.id == event.leader.id) {
      return true;
    }
    for (Member member in members) {
      if (member.id == currentMember.id) {
        return true;
      }
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _setRouteArgument();
    BlocProvider.of<MemberBloc>(context)
        .add(GetEventMembers(eventId: event.id));
    eventMembersLoaded = false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MemberBloc, MemberState>(
      builder: (context, eventState) {
        if (eventState is InitialMemberEventsState) {
          BlocProvider.of<MemberBloc>(context)
              .add(GetEventMembers(eventId: event.id));
          return _eventDetailsPage();
        } else if (eventState is EventMembersLoading) {
          return _eventDetailsPage();
        } else if (eventState is EventMembersLoaded) {
          members = eventState.members;
          eventMembersLoaded = true;
          return _eventDetailsPage();
        } else {
          BlocProvider.of<MemberBloc>(context)
              .add(GetEventMembers(eventId: event.id));
          return LoadingWidget();
        }
      },
    );
  }

  Widget _eventDetailsPage() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: AppBar(
            actions: <Widget>[_eventShare()],
            iconTheme: IconThemeData(
              color: Colors.white, //change your color here
            ),
            centerTitle: true,
            title: Text(
              event.title,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            backgroundColor: Colors.deepPurpleAccent,
          ),
          body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    config.Colors().mainColor(1),
                    config.Colors().accentColor(.8),
                  ],
                ),
              ),
              child: _eventDetailsList())),
    );
  }

  Widget _eventShare() {
    if (!event.finished) {
      return ShareEventWidget(
        eventTitle: event.title,
        eventId: event.id,
        description: event.description,
      );
    } else {
      return Container();
    }
  }

  Widget _eventDetailsList() {
    return ListView(
      children: <Widget>[
        EventDetailsTop(
          event: event,
          heroTag: _heroTag,
        ),
        eventMembersLoaded
            ? EventDetailsBottom(
                members: members,
                isUserEnlisted: isUserEnlisted(),
                full: event.full,
                addMember: _addMember,
                currentMember: currentMember,
              )
            : Center(child: CircularProgressIndicator())
      ],
    );
  }

  _addMember() {
    BlocProvider.of<EventsBloc>(context)
        .add(AddCurrentMemberToEvent(eventId: event.id));
    setState(() {
      members.add(currentMember);
    });
  }

  _setRouteArgument() {
    event = widget.routeArgument.argumentsList[0] as Event;
    _heroTag = widget.routeArgument.argumentsList[1] as String;
    currentMember = widget.routeArgument.argumentsList[2] as Member;
  }
}
