import 'package:flutter/material.dart';
import 'package:ftc_application/config/ui_icons.dart';
import 'package:ftc_application/config/app_config.dart' as config;
import 'package:ftc_application/src/models/Event.dart';
import 'package:ftc_application/src/widgets/MemberWidgets/member_image.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailsTop extends StatelessWidget {
  final Event event;
  final String heroTag;

  EventDetailsTop({this.event, this.heroTag});

  @override
  Widget build(BuildContext context) {
    _launchGoogleMaps(String link) async {
      if (link == null || link.isEmpty) {
        Alert(
          context: context,
          title: 'ماحط موقع',
          buttons: [
            DialogButton(
              child: Text(
                "زبال",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ).show();
      } else {
        if (await canLaunch(link)) {
          await launch(link, forceSafariVC: false);
        } else {
          throw "Couldn't launch URL";
        }
      }
    }

    _onWhatsAppTap(String link) async {
      if (link == null || link.isEmpty) {
        Alert(
          context: context,
          title: 'ماحط قروب',
          buttons: [
            DialogButton(
              child: Text(
                "زبال",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ).show();
      } else {
        if (await canLaunch(link)) {
          await launch(link, forceSafariVC: false);
        } else {
          throw 'Could not launch the number"';
        }
      }
    }

    final _eventLeader = Container(
      alignment: FractionalOffset.topCenter,
      child: Container(
        margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 3,
          ),
        ),
        child: Hero(
            tag: heroTag + event.id.toString(),
            child: MemberImage(
              id: event.leader.id,
              hasProfileImage: event.leader.hasProfileImage,
              height: 165,
              width: 165,
              thumb: false,
            )),
      ),
    );
    final _eventDetails = Card(
      margin: EdgeInsets.fromLTRB(10, 100, 10, 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 8.0,
      child: Padding(
        padding: EdgeInsets.fromLTRB(8, 65, 8, 8),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                event.title,
                style: Theme.of(context).textTheme.title,
              ),
            ),
            Divider(
              color: config.Colors().divider(1),
              height: 0,
              thickness: 1,
            ),
            Text(
              'وصف المشروع',
              style: Theme.of(context)
                  .textTheme
                  .subtitle
                  .merge(TextStyle(color: Colors.black)),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Text(
                event.description,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.body1,
              ),
            ),
            Divider(
              color: config.Colors().divider(1),
              height: 0,
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    event.date.toIso8601String().split("T")[0],
                    style: Theme.of(context)
                        .textTheme
                        .body1
                        .merge(TextStyle(fontSize: 18)),
                  ),
                  GestureDetector(
                    onTap: () => _launchGoogleMaps(event.location),
                    child: Icon(
                      UiIcons.map,
                      color: config.Colors().accentColor(1),
                      size: 30,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _onWhatsAppTap(event.whatsAppLink),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage:
                          AssetImage('assets/images/whats_app.png'),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    return Stack(
      children: <Widget>[
        _eventDetails,
        _eventLeader,
      ],
    );
  }
}
