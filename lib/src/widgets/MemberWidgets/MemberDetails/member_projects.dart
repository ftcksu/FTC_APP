import 'package:flutter/material.dart';
import 'package:ftc_application/src/models/Event.dart';
import 'package:ftc_application/src/widgets/MemberWidgets/MemberDetails/member_enlisted_project_item.dart';

class MemberProjects extends StatefulWidget {
  final List<Event> events;
  MemberProjects({required this.events});

  @override
  _MemberProjectsState createState() => _MemberProjectsState();
}

class _MemberProjectsState extends State<MemberProjects>
    with TickerProviderStateMixin {
  late AnimationController animationController = animationController =
      AnimationController(duration: Duration(milliseconds: 800), vsync: this);

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.events.length > 0
        ? _enlistedEventsList()
        : Center(
            child: Text('ماعنده فعاليات مشترك فيها',
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .merge(TextStyle(color: Colors.white, fontSize: 24))),
          );
  }

  Widget _enlistedEventsList() {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 8),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: widget.events.length,
        itemBuilder: (_, index) {
          var count = widget.events.length > 10 ? 10 : widget.events.length;
          var animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: animationController,
              curve: Interval((1 / count) * index, 1.0,
                  curve: Curves.fastOutSlowIn)));
          animationController.forward();
          return MemberEnlistedProject(
            event: widget.events[index],
            heroTag: 'member_details_event',
            animation: animation,
            animationController: animationController,
          );
        });
  }
}
