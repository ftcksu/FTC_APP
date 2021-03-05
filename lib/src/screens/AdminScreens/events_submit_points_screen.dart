import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ftc_application/blocs/memberEventsBloc/bloc.dart';
import 'package:ftc_application/src/models/Event.dart';
import 'package:ftc_application/config/app_config.dart' as config;
import 'package:ftc_application/src/models/route_argument.dart';
import 'package:ftc_application/src/widgets/AdminScreenWidgets/PointsSubmissionWidgets/submit_points_event_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ftc_application/src/widgets/AdminScreenWidgets/admin_submit_card.dart';
import 'package:ftc_application/src/widgets/loading_widget.dart';

class SubmitPointsScreen extends StatefulWidget {
  @override
  _SubmitPointsScreenState createState() => _SubmitPointsScreenState();
}

class _SubmitPointsScreenState extends State<SubmitPointsScreen> {
  List<Event> events;
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MemberEventsBloc, MemberEventsState>(
        builder: (context, eventState) {
      if (eventState is InitialMemberEventsState) {
        BlocProvider.of<MemberEventsBloc>(context).add(GetEvents());
        return LoadingWidget();
      } else if (eventState is EventsLoading) {
        return LoadingWidget();
      } else if (eventState is EventsLoaded) {
        events = eventState.events;
        events.removeWhere((event) => event.finished);
        return _submitPointsScreen();
      } else {
        BlocProvider.of<MemberEventsBloc>(context).add(GetEvents());
        return LoadingWidget();
      }
    });
  }

  Widget _submitPointsScreen() {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                centerTitle: true,
                title: Text('رصد النقاط'),
                backgroundColor: Colors.deepPurpleAccent,
                elevation: 8,
                floating: true,
                snap: true,
                leading: IconButton(
                  icon: new Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ];
          },
          body: RefreshIndicator(
            onRefresh: () {
              BlocProvider.of<MemberEventsBloc>(context).add(
                MemberRefreshEvents(),
              );
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
                child: _submitPointsList()),
          ),
        )));
  }

  Widget _submitPointsList() {
    return ListView.builder(
      itemCount: events.length + 1,
      itemBuilder: (context, count) {
        if (count == 0) {
          return AdminSubmitCard();
        } else {
          return SubmitPointsEventCard(events[count - 1], _onClick);
        }
      },
    );
  }

  _onClick(int eventId) {
    Navigator.of(context).pushNamed('/EventJobs',
        arguments: RouteArgument(argumentsList: [eventId]));
  }
}
