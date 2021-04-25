import 'package:flutter/material.dart';
import 'package:ftc_application/src/models/Task.dart';
import 'package:ftc_application/src/models/route_argument.dart';
import 'package:ftc_application/blocs/memberTasksBloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ftc_application/config/app_config.dart' as config;
import 'package:ftc_application/src/widgets/loading_widget.dart';
import 'package:ftc_application/src/widgets/MemberWidgets/previous_work_task_card.dart';

class PreviousWorkTasks extends StatefulWidget {
  final RouteArgument routeArgument;
  PreviousWorkTasks({this.routeArgument});

  @override
  _PreviousWorkTasksState createState() => _PreviousWorkTasksState();
}

class _PreviousWorkTasksState extends State<PreviousWorkTasks> {
  List<Task> tasks;
  String jobType;
  String jobTitle;
  int jobId;

  @override
  void initState() {
    super.initState();
    _setRouteArgument();
    BlocProvider.of<MemberTasksBloc>(context)
        .add(GetMemberJobTasks(jobId: jobId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MemberTasksBloc, MemberTasksState>(
      builder: (context, taskState) {
        if (taskState is InitialMemberTasksState) {
          BlocProvider.of<MemberTasksBloc>(context)
              .add(GetMemberJobTasks(jobId: jobId));
          return LoadingWidget();
        } else if (taskState is MemberTasksLoading) {
          return LoadingWidget();
        } else if (taskState is MemberTasksLoaded) {
          tasks = taskState.memberTasks;
          return _previousWorkTasksScreen();
        } else {
          BlocProvider.of<MemberTasksBloc>(context)
              .add(GetMemberJobTasks(jobId: jobId));
          return LoadingWidget();
        }
      },
    );
  }

  Widget _previousWorkTasksScreen() {
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
          child: _previousWorkTasksList(),
        ),
      )),
    );
  }

  Widget _previousWorkTasksList() {
    return tasks.length > 0
        ? ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return PreviousWorkTaskCard(
                task: tasks[index],
                jobType: jobType,
                jobTitle: jobTitle,
                editTask: editTask,
              );
            },
          )
        : Center(
            child: Text(
            'ماعندك اعمال سابقه',
            style: Theme.of(context)
                .textTheme
                .headline2
                .merge(TextStyle(color: Colors.white, fontSize: 24)),
          ));
  }

  editTask(Task task, String input) {
    if (jobType == "SELF") {
      BlocProvider.of<MemberTasksBloc>(context)
          .add(EditTask(taskId: task.id, description: input, userSub: true));
    } else {
      BlocProvider.of<MemberTasksBloc>(context)
          .add(EditTask(taskId: task.id, description: input, userSub: false));
    }
  }

  _setRouteArgument() {
    jobType = widget.routeArgument.argumentsList[0];
    jobTitle = widget.routeArgument.argumentsList[1];
    jobId = widget.routeArgument.argumentsList[2];
  }
}
