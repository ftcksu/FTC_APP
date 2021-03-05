import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ftc_application/blocs/adminBloc/bloc.dart';
import 'package:ftc_application/blocs/notificationBloc/bloc.dart';
import 'package:ftc_application/src/models/Job.dart';
import 'package:ftc_application/src/models/PushNotificationRequest.dart';
import 'package:ftc_application/src/models/Task.dart';
import 'package:ftc_application/src/widgets/loading_widget.dart';
import 'package:ftc_application/config/app_config.dart' as config;
import 'package:ftc_application/src/widgets/SerchBar/search_appbar.dart';
import 'package:ftc_application/src/widgets/AdminScreenWidgets/submit_anyone_member_card.dart';

class SubmitPointsAnyone extends StatefulWidget {
  @override
  _SubmitPointsAnyoneState createState() => _SubmitPointsAnyoneState();
}

class _SubmitPointsAnyoneState extends State<SubmitPointsAnyone> {
  List<Job> adminJobs, searchList, _newData;
  Completer<void> _refreshCompleter;
  bool searchState = false;

  @override
  void initState() {
    _refreshCompleter = Completer<void>();
    searchList = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminBloc, AdminState>(
      builder: (context, adminState) {
        if (adminState is InitialAdminState) {
          BlocProvider.of<AdminBloc>(context).add(GetSelfJobs());
          return LoadingWidget();
        } else if (adminState is AdminGetJobsLoading) {
          return LoadingWidget();
        } else if (adminState is AdminGetJobsLoaded) {
          adminJobs = adminState.jobs;
          adminJobs.sort((a, b) => b.readyTasks.compareTo(a.readyTasks));
          return _submitAnyoneScreen();
        } else {
          BlocProvider.of<AdminBloc>(context).add(GetSelfJobs());
          return LoadingWidget();
        }
      },
    );
  }

  Widget _submitAnyoneScreen() {
    return Scaffold(
      appBar: SearchAppBar.noDrawer('رصد النقاط', _onChanged, _setSearchState),
      body: RefreshIndicator(
        onRefresh: () {
          BlocProvider.of<AdminBloc>(context).add(GetSelfJobs());
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
          child: Directionality(
              textDirection: TextDirection.rtl, child: _simpleSubmitAnyone()),
        ),
      ),
    );
  }

  Widget _simpleSubmitAnyone() {
    if (searchState && _newData != null) {
      if (_newData.length == 0) {
        return Container(
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
          child: Center(
            child: Text(
              'مافيش عضو بهل اسم',
              style: Theme.of(context)
                  .textTheme
                  .title
                  .merge(TextStyle(color: Colors.white, fontSize: 24)),
            ),
          ),
        );
      } else {
        return ListView.builder(
          itemBuilder: (context, index) {
            return SubmitAnyoneMemberCard(
              adminJob: _newData[index],
              onClick: _onSubmit,
            );
          },
          itemCount: _newData.length,
        );
      }
    } else {
      return ListView.builder(
        itemBuilder: (context, index) {
          return SubmitAnyoneMemberCard(
            adminJob: adminJobs[index],
            onClick: _onSubmit,
          );
        },
        itemCount: adminJobs.length,
      );
    }
  }

  _onChanged(String value) {
    setState(() {
      _newData = adminJobs
          .where((job) => job.assignedMember.name
              .toLowerCase()
              .contains(value.toLowerCase()))
          .toList();
    });
  }

  _setSearchState() {
    setState(() {
      searchState = !searchState;
    });
  }

  _onSubmit(int memberId, String description, int points) {
    Task task = Task(
        description: description, points: points, approvalStatus: "APPROVED");

    BlocProvider.of<AdminBloc>(context)
        .add(AdminSubmitPoints(memberId: memberId, payload: task.toJson()));

    BlocProvider.of<NotificationBloc>(context).add(sendMemberMessage(
        memberId: memberId,
        notification: PushNotificationRequest.message(
          'أعمالك',
          "الرئيس رصدلك نقاط",
        )));
  }
}
