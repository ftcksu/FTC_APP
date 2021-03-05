import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:ftc_application/src/models/Event.dart';
import 'package:ftc_application/src/models/Member.dart';
import 'package:ftc_application/src/models/route_argument.dart';
import 'package:ftc_application/src/widgets/EventWidgets/events_list_item.dart';
import 'package:ftc_application/config/app_config.dart' as config;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ftc_application/blocs/eventsBloc/bloc.dart';
import 'package:ftc_application/src/widgets/loading_widget.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Events extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Member currentMember;
  String eventId;

  Events({this.scaffoldKey, this.currentMember, this.eventId = ''});
  Events.leadTo({this.scaffoldKey, this.currentMember, this.eventId});
  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> with TickerProviderStateMixin {
  AnimationController animationController;
  Completer<void> _refreshCompleter;
  List<Event> events;
  List<int> enlistedEvents;

  @override
  void initState() {
    animationController =
        AnimationController(duration: Duration(milliseconds: 800), vsync: this);
    _refreshCompleter = Completer<void>();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventsBloc, EventsState>(
      builder: (context, eventState) {
        if (eventState is EventPageLoading) {
          return LoadingWidget();
        } else if (eventState is EventPageLoaded) {
          events = eventState.events.argumentsList[0] as List<Event>;
          enlistedEvents = eventState.events.argumentsList[1] as List<int>;
          if (widget.eventId.isNotEmpty) {
            _leadToEvent(widget.eventId);
            widget.eventId = '';
          }
          return RefreshIndicator(
              onRefresh: () {
                BlocProvider.of<EventsBloc>(context).add(RefreshEvents());
                return _refreshCompleter.future;
              },
              child: _eventsPage());
        } else {
          BlocProvider.of<EventsBloc>(context).add(GetEventsPage());
          return LoadingWidget();
        }
      },
    );
  }

  Widget _eventsPage() {
    return Scaffold(
      floatingActionButton: speedDial(),
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
        child: CustomScrollView(slivers: <Widget>[
          SliverAppBar(
            floating: true,
            backgroundColor: Colors.deepPurpleAccent,
            centerTitle: true,
            elevation: 8,
            actions: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.reorder,
                  color: Colors.white,
                ),
                onPressed: () {
                  widget.scaffoldKey.currentState.openEndDrawer();
                },
              ),
            ],
            title: Text(
              'الفعاليات',
            ),
          ),
          _eventPageList()
        ]),
      ),
    );
  }

  Widget _eventPageList() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
          child: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          var count = events.length > 10 ? 10 : events.length;
          var animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: animationController,
              curve: Interval((1 / count) * index, 1.0,
                  curve: Curves.fastOutSlowIn)));
          animationController.forward();
          return EventCard(
            event: events[index],
            enlistedEvents: enlistedEvents,
            heroTag: 'events_screen_event',
            currentMember: widget.currentMember,
            animation: animation,
            animationController: animationController,
          );
        }, childCount: events.length),
      )),
    );
  }

  Widget speedDial() {
    return SpeedDial(
      marginRight: 18,
      marginBottom: 45,
      animatedIcon: AnimatedIcons.menu_close,
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      backgroundColor: config.Colors().accentColor(1),
      foregroundColor: Colors.white,
      elevation: 8.0,
      shape: CircleBorder(),
      children: [
        SpeedDialChild(
            child: Icon(Icons.add, color: Colors.white),
            backgroundColor: Colors.deepPurpleAccent,
            label: 'أضف فعاليه',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => _onEventCreation()),
        SpeedDialChild(
          child: Icon(
            Icons.event,
            color: Colors.white,
          ),
          backgroundColor: Colors.deepPurpleAccent,
          label: 'فعالياتك',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () => _onEventManagement(),
        ),
      ],
    );
  }

  _leadToEvent(String eventId) {
    int id = int.parse(eventId);
    Event event = events.firstWhere((event) => event.id == id);
    Future.delayed(Duration.zero, () {
      Navigator.of(context).pushNamed('/EventDetails',
          arguments: new RouteArgument(argumentsList: [
            event,
            'events_screen_event',
            widget.currentMember
          ]));
    });
  }

  _onEventCreation() {
    if (widget.currentMember.hidden) {
      Alert(
        context: context,
        title: 'خريج انت حبيبي مافيش',
        buttons: [
          DialogButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "اسف",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ],
      ).show();
    } else {
      Navigator.of(context).pushNamed('/EventCreationScreen',
          arguments:
              RouteArgument(argumentsList: [false, widget.currentMember]));
    }
  }

  _onEventManagement() {
    if (widget.currentMember.hidden) {
      Alert(
        context: context,
        title: 'خريج انت حبيبي مافيش',
        buttons: [
          DialogButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "اسف",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ],
      ).show();
    } else {
      Navigator.of(context).pushNamed('/EventManagement');
    }
  }
}
