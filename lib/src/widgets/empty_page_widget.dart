import 'package:flutter/material.dart';

class EmptyPageWidget extends StatelessWidget {
  final String text;

  EmptyPageWidget({required this.text});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Center(
            child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .headline6!
              .merge(TextStyle(color: Colors.white, fontSize: 24)),
        )),
      ),
    );
  }
}
