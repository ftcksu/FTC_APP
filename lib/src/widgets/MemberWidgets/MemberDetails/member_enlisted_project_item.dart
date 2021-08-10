import 'package:flutter/material.dart';
import 'package:ftc_application/src/models/Event.dart';
import 'package:ftc_application/src/models/Member.dart';
import 'package:ftc_application/src/models/route_argument.dart';
import 'package:ftc_application/src/widgets/MemberWidgets/member_image.dart';

class MemberEnlistedProject extends StatelessWidget {
  final Event event;
  final Member currentMember;
  final String heroTag;
  final AnimationController animationController;
  final Animation<double> animation;

  MemberEnlistedProject(
      {required this.event,
      required this.heroTag,
      required this.currentMember,
      required this.animationController,
      required this.animation}); //Event leader icon or icon icon? what to choose

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
            opacity: animation,
            child: Transform(
              transform: Matrix4.translationValues(
                  0.0, 50 * (1.0 - animation.value), 0.0),
              child: Card(
                color: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  onTap: () => Navigator.of(context).pushNamed('/EventDetails',
                      arguments: new RouteArgument(
                          argumentsList: [event, heroTag, currentMember])),
                  leading: Hero(
                      tag: heroTag + event.id.toString(),
                      child: MemberImage(
                        id: event.leader.id,
                        hasProfileImage: event.leader.hasProfileImage,
                        height: 45,
                        width: 45,
                        thumb: true,
                      )),
                  title: Text(event.title,
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .merge(TextStyle(color: Colors.white))),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
