import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ftc_application/blocs/memberJobsBloc/bloc.dart';
import 'package:ftc_application/config/app_config.dart' as config;
import 'package:ftc_application/src/widgets/SubmitWorkWidgets/self_submit_card.dart';
import 'package:ftc_application/src/widgets/SubmitWorkWidgets/submit_work_card.dart';
import 'package:ftc_application/src/models/Job.dart';
import 'package:ftc_application/src/models/Task.dart';
import 'package:ftc_application/src/widgets/loading_widget.dart';

class SubmitWorkScreen extends StatefulWidget {
  @override
  _SubmitWorkScreenState createState() => _SubmitWorkScreenState();
}

class _SubmitWorkScreenState extends State<SubmitWorkScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;
  List<Job> jobs = [];
  int selfJobId;
  Completer<void> _refreshCompleter;

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
    return BlocBuilder<MemberJobsBloc, MemberJobsState>(
      builder: (context, memberState) {
        if (memberState is InitialMemberJobsState) {
          BlocProvider.of<MemberJobsBloc>(context).add(GetMemberJobs());
          return LoadingWidget();
        } else if (memberState is MemberJobsLoading) {
          return LoadingWidget();
        } else if (memberState is MemberJobsLoaded) {
          jobs = memberState.jobsInfo.argumentsList[0] as List<Job>;
          selfJobId = memberState.jobsInfo.argumentsList[1] as int;
          jobs.removeWhere(
              (item) => item.jobType != "EVENT" || item.eventStatus);
          return _jobsScreen();
        } else {
          BlocProvider.of<MemberJobsBloc>(context).add(GetMemberJobs());
          return LoadingWidget();
        }
      },
    );
  }

  Widget _jobsScreen() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                centerTitle: true,
                title: Text('رصد اعمالي'),
                backgroundColor: Colors.deepPurpleAccent,
                elevation: 8,
                floating: true,
                snap: true,
                leading: IconButton(
                  icon: new Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              )
            ];
          },
          body: RefreshIndicator(
            onRefresh: () {
              BlocProvider.of<MemberJobsBloc>(context).add(RefreshMemberJobs());
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
                child: _jobScreenList()),
          ),
        ),
      ),
    );
  }

  Widget _jobScreenList() {
    return jobs.length > 0
        ? ListView.builder(
            itemCount: jobs.length + 1,
            itemBuilder: (context, index) {
              var count = jobs.length > 10 ? 10 : jobs.length;
              var animation = Tween(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: animationController,
                      curve: Interval((1 / count) * index, 1.0,
                          curve: Curves.fastOutSlowIn)));
              animationController.forward();
              if (index == 0) {
                return SelfSubmitCard(
                  submitSelf: _submitSelfWork,
                  animation: animation,
                  animationController: animationController,
                );
              } else {
                return SubmitWorkCard(
                  job: jobs[index - 1],
                  submitWork: _submitWorkToJob,
                  animation: animation,
                  animationController: animationController,
                );
              }
            })
        : Column(
            children: <Widget>[
              SelfSubmitCard(
                submitSelf: _submitSelfWork,
              ),
            ],
          );
  }

  _submitSelfWork(String taskDescription) {
    Task task = Task(description: taskDescription, approvalStatus: "READY");
    BlocProvider.of<MemberJobsBloc>(context)
        .add(AddTaskToJob(jobId: selfJobId, payload: task.toJson()));
  }

  _submitWorkToJob(int jobId, String taskDescription) {
    Task task = Task(description: taskDescription, approvalStatus: "WAITING");
    BlocProvider.of<MemberJobsBloc>(context)
        .add(AddTaskToJob(jobId: jobId, payload: task.toJson()));
  }
}
