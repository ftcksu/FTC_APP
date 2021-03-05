import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ftc_application/authenticationBloc/authentication.dart';
import 'package:ftc_application/config/app_config.dart' as config;
import 'package:flutter_bloc/flutter_bloc.dart';

class FailureScreen extends StatelessWidget {
  final Completer<void> _refreshCompleter = Completer<void>();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        BlocProvider.of<AuthenticationBloc>(context).add(AppStarted());
        return _refreshCompleter.future;
      },
      child: Container(
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
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Image.asset('assets/images/loginFail.png'),
            ),
          ),
        ),
      ),
    );
  }
}
