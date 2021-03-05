import 'package:flutter/material.dart';
import 'package:ftc_application/src/models/Member.dart';
import 'package:ftc_application/src/models/image_history.dart';
import 'package:ftc_application/src/models/route_argument.dart';

class ProfileImagePreview extends StatelessWidget {
  final RouteArgument routeArgument;
  bool adminPreview;
  Member member;
  String _heroTag;
  ImageHistory memberImage;

  ProfileImagePreview({this.routeArgument}) {
    adminPreview = routeArgument.argumentsList[0];
    if (adminPreview) {
      memberImage = routeArgument.argumentsList[1] as ImageHistory;
      _heroTag = routeArgument.argumentsList[2] as String;
    } else {
      member = routeArgument.argumentsList[1] as Member;
      _heroTag = routeArgument.argumentsList[2] as String;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: adminPreview
              ? Text('صوره ' + memberImage.userName)
              : Text('صوره ' + member.name),
        ),
        body: Container(
          color: Colors.black,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Hero(
                tag: _heroTag + routeArgument.id.toString(),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: _getImage()),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getImage() {
    if (adminPreview) {
      return Image.network(
        "http://157.245.240.12:8080/api/images/" + memberImage.id.toString(),
        alignment: Alignment.center,
      );
    } else {
      return member.hasProfileImage
          ? Image.network(
              "http://157.245.240.12:8080/api/users/" +
                  member.id.toString() +
                  "/image",
              alignment: Alignment.center,
            )
          : Image.asset(
              'assets/images/egg.jpg',
              alignment: Alignment.center,
            );
    }
  }
}
