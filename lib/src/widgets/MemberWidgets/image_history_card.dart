import 'package:ftc_application/config/app_config.dart' as config;
import 'package:flutter/material.dart';
import 'package:ftc_application/src/models/image_history.dart';

class ImageHistoryCard extends StatelessWidget {
  final Function onClick;
  final ImageHistory image;
  ImageHistoryCard({this.image, this.onClick});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.transparent,
        elevation: 4.0,
        child: Container(
          height: 400,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color.fromRGBO(121, 114, 173, 1.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                bottom: 50,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0)),
                    image: DecorationImage(
                      image: NetworkImage("http://157.245.240.12:8080/api/images/" +
                          image.id.toString()),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _getButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getButton() {
    return image.used
        ? RaisedButton(
            color: config.Colors().accentColor(1),
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'صورتك الحلوه',
                  style: new TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ],
            ),
            onPressed: () {})
        : RaisedButton(
            color: config.Colors().accentColor(1),
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'رجع الصوره',
                  style: new TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ],
            ),
            onPressed: () {
              onClick(image.id);
            });
  }
}
