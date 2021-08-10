import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:ftc_application/src/models/Member.dart';
import 'package:ftc_application/src/models/image_history.dart';
import 'package:ftc_application/src/models/route_argument.dart';

class ProfileImagePreview extends StatefulWidget {
  final RouteArgument routeArgument;
  ProfileImagePreview({required this.routeArgument});

  @override
  _ProfileImagePreviewState createState() => _ProfileImagePreviewState();
}

class _ProfileImagePreviewState extends State<ProfileImagePreview> {
  final String baseLink = FlutterConfig.get('API_BASE_URL');
  bool adminPreview = false;
  Member member = Member.initial();
  String _heroTag = "";
  ImageHistory memberImage = ImageHistory.initital();

  @override
  void initState() {
    super.initState();
    _setRouteArgument();
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
                tag: _heroTag + widget.routeArgument.id.toString(),
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
        baseLink + memberImage.id.toString(),
        alignment: Alignment.center,
      );
    } else {
      return member.hasProfileImage
          ? Image.network(
              baseLink + "users/" + member.id.toString() + "/image",
              alignment: Alignment.center,
            )
          : Image.asset(
              'assets/images/egg.jpg',
              alignment: Alignment.center,
            );
    }
  }

  _setRouteArgument() {
    adminPreview = widget.routeArgument.argumentsList[0];
    if (adminPreview) {
      memberImage = widget.routeArgument.argumentsList[1] as ImageHistory;
      _heroTag = widget.routeArgument.argumentsList[2] as String;
    } else {
      member = widget.routeArgument.argumentsList[1] as Member;
      _heroTag = widget.routeArgument.argumentsList[2] as String;
    }
  }
}
