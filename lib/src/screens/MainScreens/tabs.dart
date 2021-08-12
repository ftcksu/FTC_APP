import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:ftc_application/config/ui_icons.dart';
import 'package:ftc_application/repositories/ftc_repository.dart';
import 'package:ftc_application/src/screens/MainScreens/events_screen.dart';
import 'package:ftc_application/src/screens/MainScreens/home_screen.dart';
import 'package:ftc_application/src/screens/MainScreens/point_screen.dart';
import 'package:ftc_application/src/widgets/bottomnav/fancy_bottom_navigation.dart';
import 'package:ftc_application/src/widgets/drawer_widget.dart';

class TabsWidget extends StatefulWidget {
  final FtcRepository ftcRepository;
  final GlobalKey<ScaffoldState> scaffoldKey;

  TabsWidget({required this.ftcRepository, required this.scaffoldKey});

  @override
  _TabsWidgetState createState() {
    return _TabsWidgetState();
  }
}

class _TabsWidgetState extends State<TabsWidget> with TickerProviderStateMixin {
  int selectedTab = 0;
  int currentTab = 0;
  late Widget currentPage;
  final GlobalKey<FancyBottomNavigationState> _tabKey =
      GlobalKey<FancyBottomNavigationState>();

  @override
  initState() {
    super.initState();
    this._selectTab(currentTab);
    this.initDynamicLinks();
  }

  void _selectTab(int tabItem) {
    setState(() {
      currentTab = tabItem;
      selectedTab = tabItem;
      switch (tabItem) {
        case 0:
          currentPage = Home(
            scaffoldKey: widget.scaffoldKey,
          );
          break;

        case 1:
          currentPage = Points(
            scaffoldKey: widget.scaffoldKey,
          );
          break;

        case 2:
          currentPage = Events(
            scaffoldKey: widget.scaffoldKey,
          );
          break;

        default:
          currentPage = Home(
            scaffoldKey: widget.scaffoldKey,
          );
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        key: widget.scaffoldKey,
        endDrawer: HomeDrawer(
          ftcRepository: widget.ftcRepository,
        ),
        body: currentPage,
        bottomNavigationBar: FancyBottomNavigation(
          key: _tabKey,
          circleColor: Theme.of(context).accentColor,
          onTabChangedListener: (position) {
            this._selectTab(position);
          },
          tabs: [
            TabData(iconData: UiIcons.home, title: 'المنزل'),
            TabData(iconData: UiIcons.trophy, title: 'النقاط'),
            TabData(iconData: UiIcons.glasses, title: 'الفعاليات'),
          ],
        ),
      ),
    );
  }

  void initDynamicLinks() async {
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;
    if (deepLink != null) {
      leadToEvent(deepLink);
    } else {
      //display relavent notification
    }

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLink) async {
      final Uri? deepLink = dynamicLink?.link;
      if (deepLink != null) {
        leadToEvent(deepLink);
      } else {
        //display relavent notification
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
  }

  void leadToEvent(Uri deepLink) {
    final queryParams = deepLink.queryParameters;
    if (queryParams.length > 0) {
      String id = queryParams['eventId'] as String;
      _tabKey.currentState?.setPage(2);
      setState(() {
        currentTab = 2;
        selectedTab = 2;
        currentPage = Events.leadTo(
          scaffoldKey: widget.scaffoldKey,
          eventId: id,
        );
      });
    }
  }
}
