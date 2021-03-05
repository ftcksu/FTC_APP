import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ftc_application/blocs/memberEventsBloc/bloc.dart';
import 'package:ftc_application/config/app_config.dart' as config;
import 'package:ftc_application/src/models/Event.dart';
import 'package:ftc_application/src/models/Member.dart';
import 'package:ftc_application/src/models/route_argument.dart';
import 'package:ftc_application/src/widgets/empty_page_widget.dart';
import 'package:ftc_application/src/widgets/EventWidgets/events_list_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ftc_application/src/widgets/loading_widget.dart';

class EventManagement extends StatefulWidget {
  const EventManagement({Key key}) : super(key: key);

  @override
  _EventManagementState createState() => _EventManagementState();
}

class _EventManagementState extends State<EventManagement>
    with TickerProviderStateMixin {
  Member currentMember;
  List<Event> currentEvents;
  List<Event> finishedEvents;
  AnimationController animationController;
  Completer<void> _refreshCompleter;
  TabController controller;

  @override
  void initState() {
    animationController =
        AnimationController(duration: Duration(milliseconds: 800), vsync: this);
    _refreshCompleter = Completer<void>();
    controller = TabController(
      length: 2,
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MemberEventsBloc, MemberEventsState>(
      builder: (context, eventState) {
        if (eventState is InitialMemberEventsState) {
          BlocProvider.of<MemberEventsBloc>(context)
              .add(GetCurrentMemberEvents());
          return LoadingWidget();
        } else if (eventState is CurrentMemberEventPageLoading) {
          return LoadingWidget();
        } else if (eventState is CurrentMemberEventPageLoaded) {
          _setEvents(eventState.events);
          return _eventManagementScreen();
        } else {
          BlocProvider.of<MemberEventsBloc>(context)
              .add(GetCurrentMemberEvents());
          return LoadingWidget();
        }
      },
    );
  }

  _setEvents(RouteArgument events) {
    currentMember = events.argumentsList[0] as Member;
    currentEvents = List.from(events.argumentsList[1] as List<Event>)
      ..removeWhere((event) => event.finished);
    finishedEvents = List.from(events.argumentsList[1] as List<Event>)
      ..retainWhere((event) => event.finished);
  }

  Widget _eventManagementScreen() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                centerTitle: true,
                title: Text('مشاريعي القوية'),
                backgroundColor: Colors.deepPurpleAccent,
                elevation: 8,
                floating: true,
                snap: true,
                leading: IconButton(
                  icon: new Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                bottom: TabBar(
                  controller: controller,
                  tabs: [
                    Tab(text: 'مشاريعك'),
                    Tab(text: 'مشاريعك المنتهيه'),
                  ],
                ),
              )
            ];
          },
          body: TabBarView(
            controller: controller,
            children: <Widget>[
              _currentEvents(),
              _finishedEvents(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _currentEvents() {
    return RefreshIndicator(
      onRefresh: () {
        BlocProvider.of<MemberEventsBloc>(context)
            .add(RefreshCurrentMemberEvents());
        return _refreshCompleter.future;
      },
      child: Container(
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
        child: currentEvents.length > 0
            ? ListView.builder(
                itemCount: currentEvents.length,
                itemBuilder: (context, index) {
                  var count =
                      currentEvents.length > 10 ? 10 : currentEvents.length;
                  var animation = Tween(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: animationController,
                          curve: Interval((1 / count) * index, 1.0,
                              curve: Curves.fastOutSlowIn)));
                  animationController.forward();

                  return EventCard(
                    event: currentEvents[index],
                    heroTag: '',
                    leaderView: true,
                    currentMember: currentMember,
                    animation: animation,
                    animationController: animationController,
                  );
                })
            : EmptyPageWidget(
                text: 'ماعندك فعاليات حاليا',
              ),
      ),
    );
  }

  Widget _finishedEvents() {
    return RefreshIndicator(
      onRefresh: () {
        BlocProvider.of<MemberEventsBloc>(context)
            .add(RefreshCurrentMemberEvents());
        return _refreshCompleter.future;
      },
      child: Container(
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
          child: finishedEvents.length > 0
              ? ListView.builder(
                  itemCount: finishedEvents.length,
                  itemBuilder: (context, index) {
                    var count =
                        finishedEvents.length > 10 ? 10 : finishedEvents.length;
                    var animation = Tween(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                            parent: animationController,
                            curve: Interval((1 / count) * index, 1.0,
                                curve: Curves.fastOutSlowIn)));
                    animationController.forward();

                    return EventCard(
                      event: finishedEvents[index],
                      heroTag: '',
                      leaderView: true,
                      currentMember: currentMember,
                      animation: animation,
                      animationController: animationController,
                    );
                  })
              : EmptyPageWidget(
                  text: 'ماعندك فعاليات منتهيه',
                )),
    );
  }
}
