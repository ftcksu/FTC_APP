import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ftc_application/src/models/image_history.dart';
import 'package:ftc_application/src/models/route_argument.dart';

class TinderCard extends StatelessWidget {
  final Function onSwipe;
  final ImageHistory image;
  final Random rnd = new Random();
  TinderCard({this.image, this.onSwipe});

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
                bottom: 70,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed(
                      '/ProfileImagePreview',
                      arguments: RouteArgument(
                          id: image.id,
                          argumentsList: [true, image, 'admin_image'])),
                  child: Hero(
                    tag: 'admin_image' + image.id.toString(),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0)),
                        image: DecorationImage(
                          image: NetworkImage(
                              "http://157.245.240.12:8080/api/images/" +
                                  image.id.toString()),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                    alignment: Alignment.center,
                    height: 70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8.0),
                            bottomRight: Radius.circular(8.0)),
                        color: Colors.white),
                    child: ListTile(
                      title: Text(
                        image.userName +
                            ' ,' +
                            (1 + rnd.nextInt(69 - 1)).toString(),
                        style: Theme.of(context).textTheme.title,
                      ),
                      subtitle: Text(
                        'عضو حار',
                        style: Theme.of(context).textTheme.subtitle.merge(
                            TextStyle(color: Colors.blueGrey, fontSize: 15)),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
