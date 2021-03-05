import 'package:flutter/material.dart';
import 'package:ftc_application/config/app_config.dart' as config;
import 'package:ftc_application/config/ui_icons.dart';
import 'package:ftc_application/repositories/ftc_repository.dart';
import 'package:ftc_application/src/models/Member.dart';
import 'package:ftc_application/src/widgets/MemberWidgets/member_image.dart';

class HomeDrawer extends StatefulWidget {
  final FtcRepository ftcRepository;
  final Member member;
  HomeDrawer({this.member, this.ftcRepository, Key key}) : super(key: key);

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  List<DrawerList> drawerList;
  bool isUserAdmin = false;
  @override
  void initState() {
    isUserAdmin = widget.member.role != "ROLE_USER";
    setDrawerListArray();
    super.initState();
  }

  void setDrawerListArray() {
    if (isUserAdmin) {
      drawerList = [
        DrawerList(
          index: DrawerIndex.SubmitWork,
          labelName: 'رصد النقاط',
          icon: Icon(UiIcons.bakery),
        ),
        DrawerList(
          index: DrawerIndex.SendNotifications,
          labelName: 'ارسال التنبيهات',
          icon: Icon(UiIcons.settings_1),
        ),
        DrawerList(
          index: DrawerIndex.ApproveImages,
          labelName: 'قبول الصور',
          icon: Icon(UiIcons.image),
        ),
        DrawerList(
          index: DrawerIndex.Account,
          labelName: 'حسابي',
          icon: Icon(UiIcons.mail),
        ),
        DrawerList(
          index: DrawerIndex.WorkRecord,
          labelName: 'سجل فعالياتي',
          icon: Icon(UiIcons.glasses),
        ),
        DrawerList(
          index: DrawerIndex.SubmitMyWork,
          labelName: 'رصد أعمالي',
          icon: Icon(UiIcons.bowling),
        ),
      ];
    } else {
      drawerList = [
        DrawerList(
          index: DrawerIndex.Account,
          labelName: 'حسابي',
          icon: Icon(UiIcons.mail),
        ),
        DrawerList(
          index: DrawerIndex.WorkRecord,
          labelName: 'سجل فعالياتي',
          icon: Icon(UiIcons.glasses),
        ),
        DrawerList(
          index: DrawerIndex.SubmitMyWork,
          labelName: 'رصد أعمالي',
          icon: Icon(UiIcons.bowling),
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              bottomLeft: Radius.circular(16.0)),
          child: Drawer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    config.Colors().accentColor(.8),
                    config.Colors().mainColor(1),
                  ],
                ),
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: EdgeInsets.only(top: 40.0),
                        child: Container(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: 130,
                                  width: 130,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color:
                                              config.Colors().secondaryText(.6),
                                          offset: Offset(2.0, 4.0),
                                          blurRadius: 8),
                                    ],
                                  ),
                                  child: MemberImage(
                                    id: widget.member.id,
                                    hasProfileImage:
                                        widget.member.hasProfileImage,
                                    height: 60,
                                    width: 60,
                                    thumb: false,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8, left: 4),
                                  child: Text(
                                    widget.member.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Divider(
                      height: 1,
                      color: config.Colors().divider(1),
                    ),
                    Expanded(
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.all(0.0),
                        itemCount: drawerList.length,
                        itemBuilder: (context, index) {
                          return inkwell(drawerList[index]);
                        },
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: config.Colors().divider(1),
                    ),
                    ListTile(
                      title: Text(
                        "تسجيل الخروج",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      leading: Icon(
                        Icons.power_settings_new,
                        color: Colors.white,
                      ),
                      onTap: () {
                        widget.ftcRepository.signOut();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/SignIn', (Route<dynamic> route) => false);
                      },
                    ),
                  ]),
            ),
          ),
        ));
  }

  Widget inkwell(DrawerList listData) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Theme.of(context).splashColor,
          highlightColor: Theme.of(context).accentColor,
          onTap: () => changeIndex(listData.index),
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 6.0,
                      height: 46.0,
                    ),
                    Padding(
                      padding: EdgeInsets.all(4.0),
                    ),
                    listData.isAssetsImage
                        ? Container(
                            width: 24,
                            height: 24,
                            child: Image.asset(
                              listData.imageName,
                            ),
                          )
                        : Icon(
                            listData.icon.icon,
                            color: Colors.white,
                          ),
                    Padding(
                      padding: EdgeInsets.all(4.0),
                    ),
                    Text(
                      listData.labelName,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    DrawerIndex drawerIndex = drawerIndexdata;
    if (drawerIndex == DrawerIndex.SubmitWork) {
      setState(() {
        Navigator.of(context).pushNamed('/SubmitWork');
      });
    } else if (drawerIndex == DrawerIndex.SendNotifications) {
      setState(() {
        Navigator.of(context).pushNamed('/SendNotifications');
      });
    } else if (drawerIndex == DrawerIndex.ApproveImages) {
      setState(() {
        Navigator.of(context).pushNamed('/ApproveImages');
      });
    } else if (drawerIndex == DrawerIndex.Account) {
      setState(() {
        Navigator.of(context).pushNamed('/Account');
      });
    } else if (drawerIndex == DrawerIndex.WorkRecord) {
      setState(() {
        Navigator.of(context).pushNamed('/WorkRecord');
      });
    } else if (drawerIndex == DrawerIndex.SubmitMyWork) {
      setState(() {
        Navigator.of(context)
            .pushNamed('/SubmitMyWork', arguments: widget.ftcRepository);
      });
    }
  }
}

enum DrawerIndex {
  SubmitWork,
  SendNotifications,
  Account,
  WorkRecord,
  SubmitMyWork,
  ApproveImages
}

class DrawerList {
  String labelName;
  Icon icon;
  bool isAssetsImage;
  String imageName;
  DrawerIndex index;

  DrawerList({
    this.isAssetsImage = false,
    this.labelName = '',
    this.icon,
    this.index,
    this.imageName = '',
  });
}
