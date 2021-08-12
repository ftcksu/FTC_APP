import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ftc_application/main.dart';
import 'package:ftc_application/repositories/user_repo.dart';
import 'package:ftc_application/src/models/Member.dart';
import 'package:ftc_application/src/models/MembersRange.dart';
import 'package:ftc_application/src/widgets/loading_widget.dart';
import 'package:ftc_application/src/widgets/points_list_item.dart';
import 'package:ftc_application/blocs/pointsBloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ftc_application/src/widgets/SerchBar/search_appbar.dart';
import 'package:ftc_application/config/app_config.dart' as config;

class Points extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  Points({required this.scaffoldKey});

  @override
  _PointsState createState() => _PointsState();
}

class _PointsState extends State<Points> {
  Completer<void> _refreshCompleter = new Completer();
  bool searchState = false;
  Member currentMember = getIt<UserRepo>().getCurrentMember();
  List<Member> _newData = [];
  late List<Member> members;
  late MembersRange range;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PointsBloc, PointsState>(
      builder: (context, pointsState) {
        if (pointsState is PointsPageLoading) return LoadingWidget();
        if (pointsState is PointsPageLoaded) {
          members = pointsState.pointsPageInfo.argumentsList[0] as List<Member>;
          range = pointsState.pointsPageInfo.argumentsList[1] as MembersRange;
          return _pointsPage();
        }
        BlocProvider.of<PointsBloc>(context).add(GetPointsPage());
        return LoadingWidget();
      },
    );
  }

  Widget _pointsPage() {
    return RefreshIndicator(
      onRefresh: () {
        BlocProvider.of<PointsBloc>(context).add(RefreshPointsPage());
        return _refreshCompleter.future;
      },
      child: Scaffold(
        appBar: SearchAppBar('نقاط الأعضاء', _onChanged,
            widget.scaffoldKey.currentState!.openEndDrawer, _setSearchState),
        body: Directionality(
            textDirection: TextDirection.rtl, child: _pointsList()),
      ),
    );
  }

  Widget _pointsList() {
    if (searchState) {
      if (_newData.length == 0) {
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
            child: Text(
              'مافيش عضو بهل اسم',
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .merge(TextStyle(color: Colors.white, fontSize: 24)),
            ),
          ),
        );
      } else {
        return ListView.builder(
          itemBuilder: (context, index) {
            return PointsListItem(
                index: index,
                member: _newData[index],
                heroTag: 'points_screen_member',
                currentMemberID: currentMember.id,
                rankImage: _getRankImage(_newData[index].rank));
          },
          itemCount: _newData.length,
        );
      }
    } else {
      return ListView.builder(
        itemBuilder: (context, index) {
          return PointsListItem(
              index: index,
              member: members[index],
              heroTag: 'points_screen_member',
              currentMemberID: currentMember.id,
              rankImage: _getRankImage(members[index].rank));
        },
        itemCount: members.length,
      );
    }
  }

  _onChanged(String value) {
    setState(() {
      _newData =
          members.where((member) => member.name.contains(value)).toList();
    });
  }

  _setSearchState() {
    setState(() {
      searchState = !searchState;
    });
  }

  _getRankImage(int rank) {
    if (rank < 4) {
      return 'assets/images/fireIcon.png';
    } else if (rank <= range.muscleRange) {
      return 'assets/images/muscle.png';
    } else if (rank <= range.turtleRange) {
      return 'assets/images/turtle.png';
    } else if (rank <= range.sleepRange) {
      return 'assets/images/sleep.png';
    } else {
      return 'assets/images/trash.png';
    }
  }
}
