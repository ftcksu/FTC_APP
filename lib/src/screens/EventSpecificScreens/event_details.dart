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
  Event event;
  String _heroTag;
  Member currentMember;
  bool eventMembersLoaded = false;
  EventDetails({Key key, this.routeArgument}) {
    event = this.routeArgument.argumentsList[0] as Event;
    _heroTag = this.routeArgument.argumentsList[1] as String;
    currentMember = this.routeArgument.argumentsList[2] as Member;
  }

  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  List<Member> members;

  bool isUserEnlisted() {
    if (widget.currentMember.id == widget.event.leader.id) {
      return true;
    }
    for (Member member in members) {
      if (member.id == widget.currentMember.id) {
        return true;
      }
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<MemberBloc>(context)
        .add(GetEventMembers(eventId: widget.event.id));
    widget.eventMembersLoaded = false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MemberBloc, MemberState>(
      builder: (context, eventState) {
        if (eventState is InitialMemberEventsState) {
          BlocProvider.of<MemberBloc>(context)
              .add(GetEventMembers(eventId: widget.event.id));
          return _eventDetailsPage();
        } else if (eventState is EventMembersLoading) {
          return _eventDetailsPage();
        } else if (eventState is EventMembersLoaded) {
          members = eventState.members;
          widget.eventMembersLoaded = true;
          return _eventDetailsPage();
        } else {
          BlocProvider.of<MemberBloc>(context)
              .add(GetEventMembers(eventId: widget.event.id));
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
              widget.event.title,
              style: Theme.of(context).textTheme.subtitle,
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
    if (!widget.event.finished) {
      return ShareEventWidget(
        eventTitle: widget.event.title,
        eventId: widget.event.id,
        description: widget.event.description,
      );
    } else {
      return Container();
    }
  }

  Widget _eventDetailsList() {
    return ListView(
      children: <Widget>[
        EventDetailsTop(
          event: widget.event,
          heroTag: widget._heroTag,
        ),
        widget.eventMembersLoaded
            ? EventDetailsBottom(
                members: members,
                isUserEnlisted: isUserEnlisted(),
                full: widget.event.full,
                addMember: _addMember,
                currentMember: widget.currentMember,
              )
            : Center(child: CircularProgressIndicator())
      ],
    );
  }

  _addMember() {
    BlocProvider.of<EventsBloc>(context)
        .add(AddCurrentMemberToEvent(eventId: widget.event.id));
    setState(() {
      members.add(widget.currentMember);
    });
  }
}
