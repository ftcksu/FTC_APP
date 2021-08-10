import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';

class MemberImage extends StatelessWidget {
  final int id;
  final bool hasProfileImage;
  final double height;
  final double width;
  final bool thumb;
  final String baseLink = FlutterConfig.get('API_BASE_URL');

  MemberImage(
      {required this.id,
      required this.hasProfileImage,
      required this.height,
      required this.width,
      required this.thumb});

  @override
  Widget build(BuildContext context) {
    return hasProfileImage
        ? ClipOval(
            child: FadeInImage.assetNetwork(
              fit: BoxFit.cover,
              placeholder: 'assets/images/egg.jpg',
              image: _getImage(),
              width: width,
              height: height,
            ),
          )
        : ClipOval(
            child: Image.asset(
              'assets/images/egg.jpg',
              fit: BoxFit.cover,
              width: width,
              height: height,
            ),
          );
  }

  _getImage() {
    return thumb
        ? baseLink + "users/" + id.toString() + "/thumb"
        : baseLink + "users/" + id.toString() + "/image";
  }
}
