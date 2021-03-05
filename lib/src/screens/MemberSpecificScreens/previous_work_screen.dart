import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ftc_application/blocs/memberJobsBloc/bloc.dart';
import 'package:ftc_application/blocs/memberTasksBloc/bloc.dart';
import 'package:ftc_application/config/app_config.dart' as config;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ftc_application/src/models/Job.dart';
import 'package:ftc_application/src/widgets/empty_page_widget.dart';
import 'package:ftc_application/src/widgets/loading_widget.dart';
import 'package:ftc_application/src/widgets/MemberWidgets/previous_work_job.dart';

class PreviousWorkScreen extends StatefulWidget {
  final BuildContext _context;
  PreviousWorkScreen(this._context);

  @override
  _PreviousWorkScreenState createState() => _PreviousWorkScreenState();
}

class _PreviousWorkScreenState extends State<PreviousWorkScreen> {
  Completer<void> _refreshCompleter;
  List<Job> jobs = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<MemberJobsBloc>(context).add(GetCurrentMemberJobs());
    _refreshCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MemberJobsBloc, MemberJobsState>(
      builder: (context, taskState) {
        if (taskState is InitialMemberTasksState) {
          BlocProvider.of<MemberJobsBloc>(context).add(GetCurrentMemberJobs());
          return LoadingWidget();
        } else if (taskState is CurrentMemberJobsLoading) {
          return LoadingWidget();
        } else if (taskState is CurrentMemberJobsLoaded) {
          jobs = taskState.jobs;
          return _previousWorkScreen();
        } else {
          BlocProvider.of<MemberJobsBloc>(context).add(GetCurrentMemberJobs());
          return LoadingWidget();
        }
      },
    );
  }

  Widget _previousWorkScreen() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              centerTitle: true,
              title: Text('سجل فعالياتي'),
              backgroundColor: Colors.deepPurpleAccent,
              elevation: 8,
              floating: true,
              snap: true,
              leading: IconButton(
                icon: new Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(widget._context).pop(),
              ),
            )
          ];
        },
        body: RefreshIndicator(
          onRefresh: () {
            BlocProvider.of<MemberJobsBloc>(context)
                .add(RefreshCurrentMemberJobs());
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
              child: _previousWorkList()),
        ),
      )),
    );
  }

  Widget _previousWorkList() {
    return jobs.length > 0
        ? ListView.builder(
            itemCount: jobs.length,
            itemBuilder: (context, count) {
              return PreviousJobCard(
                job: jobs[count],
              );
            },
          )
        : EmptyPageWidget(
            text: 'ماعندك اعمال سابقه',
          );
  }
}
