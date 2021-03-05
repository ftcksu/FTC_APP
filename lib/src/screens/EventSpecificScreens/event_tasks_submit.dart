import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ftc_application/blocs/memberTasksBloc/bloc.dart';
import 'package:ftc_application/blocs/notificationBloc/bloc.dart';
import 'package:ftc_application/config/app_config.dart' as config;
import 'package:ftc_application/src/models/Member.dart';
import 'package:ftc_application/src/models/PushNotificationRequest.dart';
import 'package:ftc_application/src/models/Task.dart';
import 'package:ftc_application/src/models/route_argument.dart';
import 'package:ftc_application/src/widgets/loading_widget.dart';
import 'package:ftc_application/src/widgets/MemberWidgets/tasks_submission_list_item.dart';

class EventTasksSubmit extends StatefulWidget {
  final RouteArgument routeArgument;
  int jobId;
  Member member;
  int eventId;
  EventTasksSubmit({Key key, this.routeArgument}) {
    jobId = routeArgument.argumentsList[0] as int;
    member = routeArgument.argumentsList[1] as Member;
    eventId = routeArgument.argumentsList[2] as int;
  }

  @override
  _EventTasksSubmitState createState() => _EventTasksSubmitState();
}

class _EventTasksSubmitState extends State<EventTasksSubmit> {
  List<Task> tasks;

  @override
  void initState() {
    BlocProvider.of<MemberTasksBloc>(context)
        .add(GetMemberJobTasks(jobId: widget.jobId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MemberTasksBloc, MemberTasksState>(
      builder: (context, taskState) {
        if (taskState is InitialMemberTasksState) {
          BlocProvider.of<MemberTasksBloc>(context)
              .add(GetMemberJobTasks(jobId: widget.jobId));
          return LoadingWidget();
        } else if (taskState is MemberTasksLoading) {
          return LoadingWidget();
        } else if (taskState is MemberTasksLoaded) {
          tasks = taskState.memberTasks;
          tasks.removeWhere((task) => task.approvalStatus != "WAITING");
          return _eventTasksSubmit();
        } else {
          BlocProvider.of<MemberTasksBloc>(context)
              .add(GetMemberJobTasks(jobId: widget.jobId));
          return LoadingWidget();
        }
      },
    );
  }

  Widget _eventTasksSubmit() {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  centerTitle: true,
                  title: Text('رصد أعمال ' + widget.member.name),
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
              child: tasks.length > 0
                  ? ListView.builder(
                      itemCount: tasks?.length,
                      itemBuilder: (context, count) {
                        return EventTasksApproveLeader(
                          task: tasks[count],
                          memberId: widget.member.id,
                          memberName: widget.member.name,
                          hasImage: widget.member.hasProfileImage,
                          onAccept: onAccept,
                          onReject: onReject,
                        );
//                  return EventTasksApproveLeader(tasks[count], () {}, () {});
                      })
                  : Center(
                      child: Text(
                      'مافيه اعمال',
                      style: Theme.of(context)
                          .textTheme
                          .title
                          .merge(TextStyle(color: Colors.white, fontSize: 24)),
                    )),
            ),
          ),
        ));
  }

  onAccept(int taskId) {
    BlocProvider.of<MemberTasksBloc>(context).add(UpdateTaskApproval(
        eventId: widget.eventId, taskId: taskId, approval: "READY"));

    BlocProvider.of<NotificationBloc>(context).add(sendMemberMessage(
        memberId: widget.member.id,
        notification: PushNotificationRequest.message(
            'أعمالك', "انقبل عملك من رئيس الفعاليه بيرصده الرئيس قريب")));
  }

  onReject(int taskId) {
    BlocProvider.of<MemberTasksBloc>(context)
        .add(UpdateTaskApproval(taskId: taskId, approval: "UNAPPROVED"));

    BlocProvider.of<NotificationBloc>(context).add(sendMemberMessage(
        memberId: widget.member.id,
        notification: PushNotificationRequest.message(
            'أعمالك', "انرفظ عملك من رئيس الفعاليه عدله")));
  }
}
