import 'package:flutter/material.dart';

class MyPainter extends CustomPainter {
  final Offset center;
  final double radius, containerHeight;
  final BuildContext context;

  late Color color;
  late double statusBarHeight, screenWidth;

  MyPainter(
      {required this.context,
      required this.containerHeight,
      required this.center,
      required this.radius}) {
    ThemeData theme = Theme.of(context);

    color = theme.primaryColor;
    statusBarHeight = MediaQuery.of(context).padding.top;
    screenWidth = MediaQuery.of(context).size.width;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint circlePainter = Paint();

    circlePainter.color = color;
    canvas.clipRect(
        Rect.fromLTWH(0, 0, screenWidth, containerHeight + statusBarHeight));
    canvas.drawCircle(center, radius, circlePainter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
