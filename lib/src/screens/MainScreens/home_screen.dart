import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ftc_application/blocs/homeBloc/bloc.dart';
import 'package:ftc_application/config/app_config.dart' as config;
import 'package:ftc_application/src/models/Member.dart';
import 'package:ftc_application/src/models/message_of_the_day.dart';
import 'package:ftc_application/src/widgets/HomeScreenWidgets/home_boring_box.dart';
import 'package:ftc_application/src/widgets/HomeScreenWidgets/home_projects.dart';
import 'package:ftc_application/src/widgets/HomeScreenWidgets/home_title.dart';
import 'package:ftc_application/src/widgets/loading_widget.dart';

class Home extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  Member member;
  MessageOfTheDay messageOfTheDay;
  Home({this.scaffoldKey});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Completer<void> _refreshCompleter;
  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, homeState) {
        if (homeState is InitialHomeState) {
          BlocProvider.of<HomeBloc>(context).add(GetHomePage());
          return LoadingWidget();
        } else if (homeState is HomePageLoading) {
          return LoadingWidget();
        } else if (homeState is HomePageLoaded) {
          widget.member = homeState.homePageInfo.argumentsList[0] as Member;
          widget.messageOfTheDay =
              homeState.homePageInfo.argumentsList[1] as MessageOfTheDay;
          return _homePage();
        } else {
          BlocProvider.of<HomeBloc>(context).add(GetHomePage());
          return LoadingWidget();
        }
      },
    );
  }

  Widget _homePage() {
    return RefreshIndicator(
      onRefresh: () {
        BlocProvider.of<HomeBloc>(context).add(RefreshHome());
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
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () =>
                          widget.scaffoldKey.currentState.openEndDrawer(),
                      child: Icon(
                        Icons.reorder,
                        color: Colors.white,
                      ),
                    )),
              ),
              HomeTitle(
                member: widget.member,
              ),
              HomeBoringBox(
                text: widget.messageOfTheDay.message,
                author: widget.messageOfTheDay.member,
              ),
              HomeProject(
                events: widget.member.participatedEvents,
                currentMember: widget.member,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
