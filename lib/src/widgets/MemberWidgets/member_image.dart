import 'package:flutter/material.dart';

class MemberImage extends StatelessWidget {
  final int id;
  final bool hasProfileImage;
  final double height;
  final double width;
  final bool thumb;
  MemberImage(
      {this.id, this.hasProfileImage, this.height, this.width, this.thumb});

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
        ? "http://157.245.240.12:8080/api/users/" + id.toString() + "/thumb"
        : "http://157.245.240.12:8080/api/users/" + id.toString() + "/image";
  }
}
