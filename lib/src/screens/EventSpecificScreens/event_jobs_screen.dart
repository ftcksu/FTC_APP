import 'package:flutter/material.dart';
import 'package:ftc_application/blocs/memberJobsBloc/bloc.dart';
import 'package:ftc_application/src/models/Job.dart';
import 'package:ftc_application/src/models/route_argument.dart';
import 'package:ftc_application/src/widgets/EventWidgets/event_jobs_card.dart';
import 'package:ftc_application/src/widgets/loading_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ftc_application/config/app_config.dart' as config;

class EventJobsApprovalScreen extends StatefulWidget {
  final RouteArgument routeArgument;
  int eventId;

  EventJobsApprovalScreen({this.routeArgument}) {
    eventId = routeArgument.argumentsList[0] as int;
  }

  @override
  _EventJobsApprovalScreenState createState() =>
      _EventJobsApprovalScreenState();
}

class _EventJobsApprovalScreenState extends State<EventJobsApprovalScreen> {
  List<Job> eventJobs;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<MemberJobsBloc>(context)
        .add(GetEventJobs(eventId: widget.eventId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MemberJobsBloc, MemberJobsState>(
      builder: (context, taskState) {
        if (taskState is InitialMemberJobsState) {
          BlocProvider.of<MemberJobsBloc>(context)
              .add(GetEventJobs(eventId: widget.eventId));
          return LoadingWidget();
        } else if (taskState is EventJobsLoading) {
          return LoadingWidget();
        } else if (taskState is EventJobsLoaded) {
          eventJobs = taskState.jobs;
          eventJobs.sort((a, b) => b.waitingTasks.compareTo(a.waitingTasks));
          return _eventJobsScreen();
        } else {
          BlocProvider.of<MemberJobsBloc>(context)
              .add(GetEventJobs(eventId: widget.eventId));
          return LoadingWidget();
        }
      },
    );
  }

  Widget _eventJobsScreen() {
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
            child: ListView.builder(
              itemCount: eventJobs.length,
              itemBuilder: (context, index) {
                return EventsJobCard(
                  eventId: widget.eventId,
                  job: eventJobs[index],
                );
              },
            ),
          ),
        )));
  }
}
