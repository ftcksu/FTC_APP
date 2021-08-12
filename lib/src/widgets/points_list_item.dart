import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ftc_application/config/app_config.dart' as config;
import 'package:ftc_application/src/models/Member.dart';
import 'package:ftc_application/src/models/route_argument.dart';
import 'package:ftc_application/src/widgets/MemberWidgets/member_image.dart';

class PointsListItem extends StatelessWidget {
  final Member member;
  final int currentMemberID;
  final int index;
  final String heroTag;
  final String rankImage;

  PointsListItem(
      {required this.member,
      required this.heroTag,
      required this.index,
      required this.currentMemberID,
      required this.rankImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: index.isEven ? config.Colors().notWhite(1) : Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed('/MemberDetails',
              arguments: new RouteArgument(
                  id: member.id.toString(), argumentsList: [member, heroTag]));
        },
        child: Row(
          children: <Widget>[
            Text(member.rank.toString()),
            Expanded(
              child: ListTile(
                leading: getLeading(member, currentMemberID, heroTag),
                title: Text(
                  member.name ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .merge(TextStyle(fontSize: 14)),
                ),
                subtitle: Text(
                  member.bio ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(rankImage),
                  backgroundColor: Colors.transparent,
                ),
                dense: true,
              ),
            ),
            SizedBox(
              width: 45,
              child: Center(
                child: Text(
                  member.points.toString() ?? "",
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.grey[600]),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget getLeading(Member member, int currentMemberID, String heroTag) {
  return Container(
    decoration: member.id == currentMemberID
        ? BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: config.Colors().accentColor(1),
                blurRadius: 3.0,
                spreadRadius: 1,
              ),
            ],
          )
        : null,
    child: Hero(
      tag: heroTag + member.id.toString(),
      child: MemberImage(
        id: member.id,
        hasProfileImage: member.hasProfileImage,
        height: 45,
        width: 45,
        thumb: true,
      ),
    ),
  );
}
