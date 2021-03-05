import 'package:flutter/material.dart';
import 'package:ftc_application/src/models/Event.dart';
import 'package:ftc_application/src/widgets/MemberWidgets/member_image.dart';

class EnlistedProject extends StatelessWidget {
  final Event event;
  final Function onTap;
  final String heroTag;
  EnlistedProject(
      {this.event, this.onTap, this.heroTag}); //add the whats app link
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onTap(event),
      leading: Hero(
          tag: heroTag + event.id.toString(),
          child: MemberImage(
            id: event.leader.id,
            hasProfileImage: event.leader.hasProfileImage,
            height: 45,
            width: 45,
            thumb: true,
          )),
      title: Text(
        event.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
