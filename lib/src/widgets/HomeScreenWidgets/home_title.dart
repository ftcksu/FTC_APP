import 'package:flutter/material.dart';
import 'package:ftc_application/src/models/Member.dart';
import 'package:ftc_application/src/models/MembersRange.dart';
import 'package:ftc_application/src/widgets/MemberWidgets/member_image.dart';

class HomeTitle extends StatelessWidget {
  final Member member;
  final MembersRange range;
  HomeTitle({required this.member, required this.range});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                ),
                child: MemberImage(
                  id: member.id,
                  hasProfileImage: member.hasProfileImage,
                  height: 250,
                  width: 250,
                  thumb: false,
                ))),
        Text(
          member.name,
          style: Theme.of(context).textTheme.headline1,
        ),
        Text(getRankTitle(member.rank),
            style: Theme.of(context).textTheme.subtitle1),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 8,
                color: Colors.white,
                child: Container(
                    width: 155,
                    height: 85,
                    child: Stack(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(member.points.toString(),
                                textDirection: TextDirection.ltr,
                                style: TextStyle(
                                    fontSize: 32,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Text('نقاطك',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 17)),
                        )
                      ],
                    )),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 8,
                  color: Colors.white,
                  child: Container(
                    width: 155,
                    height: 85,
                    child: Stack(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(member.rank.toString(),
                                textDirection: TextDirection.ltr,
                                style: TextStyle(
                                    fontSize: 32,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Text('ترتيبك',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 17)),
                        )
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ],
    );
  }

  String getRankTitle(int rank) {
    if (rank == 1) {
      return 'الهامور';
    } else if (rank < 4) {
      return 'هويمر';
    } else if (rank <= range.muscleRange) {
      return 'معضل';
    } else if (rank <= range.turtleRange) {
      return 'سلحوف';
    } else if (rank <= range.sleepRange) {
      return 'نايم';
    } else {
      return 'ميت';
    }
  }
}
