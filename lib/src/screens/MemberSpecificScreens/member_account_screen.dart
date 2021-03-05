import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ftc_application/config/app_config.dart' as config;
import 'package:ftc_application/src/models/Member.dart';
import 'package:ftc_application/src/widgets/MemberWidgets/MemberAccountWidgets/account_screen_bottom.dart';
import 'package:ftc_application/src/widgets/loading_widget.dart';
import 'package:ftc_application/src/widgets/MemberWidgets/member_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ftc_application/blocs/memberBloc/bloc.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:image_cropper/image_cropper.dart';

class MemberAccountScreen extends StatefulWidget {
  @override
  _MemberAccountScreenState createState() => _MemberAccountScreenState();
}

class _MemberAccountScreenState extends State<MemberAccountScreen> {
  Member member;
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MemberBloc, MemberState>(
      builder: (context, memberState) {
        if (memberState is InitialMemberState) {
          BlocProvider.of<MemberBloc>(context).add(GetMember());
          return LoadingWidget();
        } else if (memberState is GetMemberLoading) {
          return LoadingWidget();
        } else if (memberState is GetMemberLoaded) {
          member = memberState.member;
          return _memberAccountPage();
        } else {
          BlocProvider.of<MemberBloc>(context).add(GetMember());
          return LoadingWidget();
        }
      },
    );
  }

  Widget _memberAccountPage() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            member.name,
            style: Theme.of(context).textTheme.subtitle,
          ),
          backgroundColor: Colors.deepPurpleAccent,
          leading: IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () {
            BlocProvider.of<MemberBloc>(context).add(RefreshMember());
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
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 4,
                          ),
                        ),
                        child: GestureDetector(
                            onTap: () => getImage(),
                            child: MemberImage(
                              id: member.id,
                              hasProfileImage: member.hasProfileImage,
                              height: 250,
                              width: 250,
                              thumb: false,
                            )),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                AccountScreenBottom(
                  member: member,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      File croppedFile = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'عدل صورتك',
              toolbarColor: Colors.deepPurpleAccent,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));
      if (croppedFile == null) {
        Alert(
          context: context,
          title: 'الصورة كخة راجع نفسك',
          buttons: [
            DialogButton(
              child: Text(
                "عفوا",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ).show();
      } else {
        Alert(
          context: context,
          title: 'ارسلت الصوره شف رئيسك اذا عاجبته',
          buttons: [
            DialogButton(
              child: Text(
                "عفوا",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ).show().whenComplete(() {
          BlocProvider.of<MemberBloc>(context)
              .add(AddImage(image: croppedFile));
        });
      }
    } else {
      Alert(
        context: context,
        title: 'الصورة كخة راجع نفسك',
        buttons: [
          DialogButton(
            child: Text(
              "عفوا",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ).show();
    }
  }
}
