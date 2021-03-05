import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ftc_application/config/app_config.dart' as config;
import 'package:ftc_application/src/models/Member.dart';
import 'package:ftc_application/src/models/route_argument.dart';
import 'package:ftc_application/src/widgets/MemberWidgets/member_image.dart';

class PointsListItem extends StatelessWidget {
  final Member member;
  final Member currentMember;
  final int index;
  final String heroTag;
  final String rankImage;

  PointsListItem(
      {@required this.member,
      @required this.heroTag,
      @required this.index,
      @required this.currentMember,
      this.rankImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: index.isEven ? config.Colors().notWhite(1) : Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed('/MemberDetails',
              arguments: new RouteArgument(
                  id: member.id.toString(),
                  argumentsList: [member, heroTag, currentMember]));
        },
        child: Row(
          children: <Widget>[
            Text(member.rank.toString()),
            Expanded(
              child: ListTile(
                leading: Container(
                  decoration: member.id == currentMember.id
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
                ),
                title: Text(
                  member.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: member?.bio != null
                    ? Text(
                        member.bio,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    : Text(''),
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
                  member.points.toString(),
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
//'assets/images/profile.JPG'
