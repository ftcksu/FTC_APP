import 'package:flutter/material.dart';
import 'package:ftc_application/blocs/adminBloc/admin_event.dart';
import 'package:ftc_application/blocs/notificationBloc/bloc.dart';
import 'package:ftc_application/src/models/PushNotificationRequest.dart';
import 'package:ftc_application/src/models/Task.dart';
import 'package:ftc_application/src/models/route_argument.dart';
import 'package:ftc_application/config/app_config.dart' as config;
import 'package:ftc_application/src/widgets/AdminScreenWidgets/PointsSubmissionWidgets/submit_points_task_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ftc_application/blocs/adminBloc/admin_bloc.dart';
import 'package:ftc_application/src/widgets/loading_widget.dart';
import 'package:ftc_application/blocs/memberTasksBloc/bloc.dart';

class SubmitPointsAnyoneMemberScreen extends StatefulWidget {
  final RouteArgument routeArgument;

  SubmitPointsAnyoneMemberScreen({required this.routeArgument});

  @override
  _SubmitPointsAnyoneMemberScreenState createState() =>
      _SubmitPointsAnyoneMemberScreenState();
}

class _SubmitPointsAnyoneMemberScreenState
    extends State<SubmitPointsAnyoneMemberScreen> {
  late List<Task> tasks;
  late int selfJobId;
  late int assignedMemberId;
  late String memberName;

  @override
  void initState() {
    _setRouteArguments();
    BlocProvider.of<MemberTasksBloc>(context)
        .add(GetMemberSelfTasks(jobId: selfJobId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MemberTasksBloc, MemberTasksState>(
      builder: (context, taskState) {
        if (taskState is InitialMemberTasksState) {
          BlocProvider.of<MemberTasksBloc>(context)
              .add(GetMemberSelfTasks(jobId: selfJobId));
          return LoadingWidget();
        } else if (taskState is GetMemberSelfTasksLoading) {
          return LoadingWidget();
        } else if (taskState is GetMemberSelfTasksLoaded) {
          tasks = taskState.memberTasks;
          tasks.removeWhere((task) => task.approvalStatus == "APPROVED");
          return _memberTasks();
        } else {
          BlocProvider.of<MemberTasksBloc>(context)
              .add(GetMemberSelfTasks(jobId: selfJobId));
          return LoadingWidget();
        }
      },
    );
  }

  Widget _memberTasks() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            memberName,
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
            child: _memberTaskList()),
      ),
    );
  }

  Widget _memberTaskList() {
    return tasks.length > 0
        ? ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, count) {
              return SubmitPointsTaskCard(
                task: tasks[count],
                submit: _submitPoints,
                index: count,
              );
            })
        : Center(
            child: Text(
            'ماعنده اعمال جديده',
            style: Theme.of(context)
                .textTheme
                .headline2!
                .merge(TextStyle(color: Colors.white, fontSize: 24)),
          ));
  }

  _submitPoints(Task task, Map<String, dynamic> payload, int index) {
    BlocProvider.of<AdminBloc>(context)
        .add(UpdateTask(taskId: task.id, payload: payload));

    setState(() {
      tasks.remove(task);
    });

    BlocProvider.of<NotificationBloc>(context).add(SendMemberMessage(
        memberId: assignedMemberId,
        notification: PushNotificationRequest.message(
            'أعمالك', "الرئيس رصد وحده من اعمالك")));
  }

  _setRouteArguments() {
    selfJobId = widget.routeArgument.argumentsList[0] as int;
    assignedMemberId = widget.routeArgument.argumentsList[1] as int;
    memberName = widget.routeArgument.argumentsList[2] as String;
  }
}
