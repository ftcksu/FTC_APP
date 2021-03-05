import 'package:flutter/material.dart';
import 'package:ftc_application/config/app_config.dart' as config;
import 'package:ftc_application/src/models/Job.dart';
import 'package:ftc_application/src/models/route_argument.dart';
import 'package:ftc_application/src/widgets/MemberWidgets/member_image.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SubmitAnyoneMemberCard extends StatelessWidget {
  final Job adminJob;
  final Function onClick;
  final FocusNode _whyFocusNode = FocusNode();
  final FocusNode _pointsFocusNode = FocusNode();

  SubmitAnyoneMemberCard({this.adminJob, this.onClick});

  @override
  Widget build(BuildContext context) {
    final _workOwner = Container(
      alignment: FractionalOffset.topCenter,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 3,
          ),
        ),
        child: MemberImage(
          id: adminJob.assignedMember.id,
          hasProfileImage: adminJob.assignedMember.hasProfileImage,
          height: 65,
          width: 65,
          thumb: false,
        ),
      ),
    );

    var card = Card(
      margin: EdgeInsets.fromLTRB(10, 40, 10, 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 8.0,
      child: Padding(
        padding: EdgeInsets.all(25.0),
        child: Column(
          children: <Widget>[
            Text(
              adminJob.assignedMember.name,
              style: Theme.of(context).textTheme.title,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(
                color: config.Colors().divider(1),
                height: 0,
                thickness: 1,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: RaisedButton(
                    color: config.Colors().accentColor(1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    child: Text(
                      'ارصدني',
                      style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                    onPressed: () => _showCustomPointsBottomCard(context),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: RaisedButton(
                    color: config.Colors().accentColor(1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                    child: Text(
                      'أعماله الخاصه',
                      style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                    onPressed: () => Navigator.of(context).pushNamed('/SubmitPointsAnyoneMemberScreen', arguments: new RouteArgument(id: adminJob.id.toString(), argumentsList: [adminJob.id, adminJob.assignedMember.id, adminJob.assignedMember.name])),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
    return Stack(
      children: <Widget>[
        card,
        _workOwner,
        Positioned(
          top: 40,
          left: 20,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blueAccent,
              border: Border.all(
                color: Colors.blueAccent,
                width: 10,
              ),
            ),
            child: Text(
              adminJob.readyTasks.toString(),
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  _showCustomPointsBottomCard(context) {
    String description = "";
    int points = 0;
    return showBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.white,
      builder: (context) => Container(
        margin: const EdgeInsets.only(top: 5, left: 15, right: 15),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      autofocus: true,
                      focusNode: _whyFocusNode,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      keyboardType: TextInputType.text,
                      maxLines: null,
                      onChanged: (string) => description = string,
                      onSubmitted: (e) {
                        _whyFocusNode.unfocus();
                        _pointsFocusNode.requestFocus();
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.ac_unit,
                          color: Theme.of(context).accentColor,
                        ),
                        hintText: 'ليه يستاهل نقاط؟',
                        hintStyle: TextStyle(
                          color: config.Colors().divider(1),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      focusNode: _pointsFocusNode,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                      maxLength: 3,
                      onChanged: (string) => points = int.parse(string),
                      onSubmitted: (e) {
                        _pointsFocusNode.unfocus();
                        _onSubmitCustomPoints(points, context);
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.ac_unit,
                          color: Theme.of(context).accentColor,
                        ),
                        hintText: 'النقاط',
                        hintStyle: TextStyle(
                          color: config.Colors().divider(1),
                        ),
                      ),
                    ),
                  ),
                  MaterialButton(
                    color: Colors.grey[800],
                    onPressed: () => _onSubmitCustomPoints(points, context),
                    child: Text(
                      'ارصد',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).closed.then((value) {
      if (points != 0) {
        onClick(adminJob.assignedMember.id, description, points);
      }
    });
  }

  _onSubmitCustomPoints(points, context) {
    if (points == 0) {
      Alert(
        context: context,
        title: 'شالفايده ترصد ولاشي',
        buttons: [
          DialogButton(
            child: Text(
              "أسف",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ).show();
    } else {
      Alert(
        context: context,
        title: 'شكرا للرصد',
        buttons: [
          DialogButton(
            child: Text(
              "عفوا",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ).show().then((onValue) {
        Navigator.pop(context);
      });
    }
  }
}
