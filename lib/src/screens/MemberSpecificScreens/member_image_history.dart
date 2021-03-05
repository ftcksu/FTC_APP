import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ftc_application/blocs.dart';
import 'package:ftc_application/blocs/imageApprovalBloc/bloc.dart';
import 'package:ftc_application/blocs/memberBloc/member_bloc.dart';
import 'package:ftc_application/src/models/image_history.dart';
import 'package:ftc_application/src/widgets/empty_page_widget.dart';
import 'package:ftc_application/src/widgets/MemberWidgets/image_history_card.dart';
import 'package:ftc_application/src/widgets/loading_widget.dart';
import 'package:ftc_application/config/app_config.dart' as config;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class MemberImageHistory extends StatefulWidget {
  @override
  _MemberImageHistoryState createState() => _MemberImageHistoryState();
}

class _MemberImageHistoryState extends State<MemberImageHistory> {
  List<ImageHistory> memberImages;
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageApprovalBloc, ImageApprovalState>(
      builder: (context, imageState) {
        if (imageState is InitialImageApprovalState) {
          BlocProvider.of<ImageApprovalBloc>(context)
              .add(GetUserImageHistory());
          return LoadingWidget();
        } else if (imageState is MemberImagesHistoryLoading) {
          return LoadingWidget();
        } else if (imageState is MemberImagesHistoryLoaded) {
          memberImages = imageState.imageHistory;
          memberImages.retainWhere((i) => i.approved == "APPROVED");
          return _imageHistory();
        } else {
          BlocProvider.of<ImageApprovalBloc>(context)
              .add(GetUserImageHistory());
          return LoadingWidget();
        }
      },
    );
  }

  Widget _imageHistory() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'صورك الحلوه',
              style: Theme.of(context).textTheme.subtitle,
            ),
            backgroundColor: Colors.deepPurpleAccent,
            leading: IconButton(
              icon: new Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: <Widget>[
              IconButton(icon: Icon(Icons.add), onPressed: () => getImage())
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () {
              BlocProvider.of<ImageApprovalBloc>(context).add(
                RefreshImageHistory(),
              );
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
                child: _imageHistoryList()),
          )),
    );
  }

  Widget _imageHistoryList() {
    return memberImages.length > 0
        ? ListView.builder(
            itemCount: memberImages.length,
            itemBuilder: (context, index) {
              return ImageHistoryCard(
                image: memberImages[index],
                onClick: _onClick,
              );
            })
        : EmptyPageWidget(
            text: 'ماعندك صور تبدل بينها',
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

  _onClick(int imageId) {
    BlocProvider.of<ImageApprovalBloc>(context)
        .add(MemberImageUpdated(imageId: imageId));
  }
}
