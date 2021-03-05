import 'package:flutter/material.dart';
import 'package:ftc_application/blocs/memberJobsBloc/bloc.dart';
import 'package:ftc_application/src/models/Job.dart';
import 'package:ftc_application/config/app_config.dart' as config;
import 'package:ftc_application/src/models/route_argument.dart';
import 'package:ftc_application/src/widgets/AdminScreenWidgets/PointsSubmissionWidgets/submit_points_job_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ftc_application/src/widgets/loading_widget.dart';

class EventJobsScreen extends StatefulWidget {
  final RouteArgument routeArgument;
  int eventID;
  EventJobsScreen({this.routeArgument}) {
    eventID = routeArgument.argumentsList[0] as int;
  }

  @override
  _EventJobsScreenState createState() => _EventJobsScreenState();
}

class _EventJobsScreenState extends State<EventJobsScreen> {
  List<Job> jobs;

  @override
  void initState() {
    BlocProvider.of<MemberJobsBloc>(context)
        .add(GetEventJobs(eventId: widget.eventID));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MemberJobsBloc, MemberJobsState>(
      builder: (context, jobsState) {
        if (jobsState is InitialMemberJobsState) {
          BlocProvider.of<MemberJobsBloc>(context)
              .add(GetEventJobs(eventId: widget.eventID));
          return LoadingWidget();
        } else if (jobsState is EventJobsLoading) {
          return LoadingWidget();
        } else if (jobsState is EventJobsLoaded) {
          jobs = jobsState.jobs;
          jobs.removeWhere((job) => job.readyTasks == 0);
          return _eventJobsScreen();
        } else {
          BlocProvider.of<MemberJobsBloc>(context)
              .add(GetEventJobs(eventId: widget.eventID));
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
                child: _eventJobList()),
          ),
        ));
  }

  Widget _eventJobList() {
    return jobs.length > 0
        ? ListView.builder(
            itemCount: jobs.length,
            itemBuilder: (context, count) {
              return SubmitPointsJobCard(jobs[count]);
            },
          )
        : Center(
            child: Text(
            'مافيه شغل',
            style: Theme.of(context)
                .textTheme
                .title
                .merge(TextStyle(color: Colors.white, fontSize: 24)),
          ));
  }
}
