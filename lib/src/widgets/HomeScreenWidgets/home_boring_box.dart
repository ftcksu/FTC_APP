import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ftc_application/config/app_config.dart' as config;

class HomeBoringBox extends StatelessWidget {
  final String text;
  final String author;

  HomeBoringBox({required this.text, required this.author});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 10,
        color: Colors.white,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                Center(
                    child: Text(
                  'كلام مايهمك',
                  style: Theme.of(context).textTheme.headline2,
                )),
                Divider(
                  color: config.Colors().divider(1),
                  thickness: 1,
                ),
                Center(
                    child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                )),
                Center(
                  child: Text(
                    '-' + author,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
