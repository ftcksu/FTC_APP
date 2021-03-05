import 'package:flutter/material.dart';
import 'package:ftc_application/config/app_config.dart' as config;

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            config.Colors().mainColor(1),
            config.Colors().accentColor(.8),
          ],
        ),
      ),
      child: Center(
        child: Image.asset(
          'assets/images/logoFTC.png',
          width: 320,
          height: 320,
        ),
      ),
    );
  }
}
