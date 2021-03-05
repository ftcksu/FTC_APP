import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ftc_application/blocs/imageApprovalBloc/bloc.dart';
import 'package:ftc_application/blocs/notificationBloc/bloc.dart';
import 'package:ftc_application/config/app_config.dart' as config;
import 'package:ftc_application/src/models/PushNotificationRequest.dart';
import 'package:ftc_application/src/models/image_history.dart';
import 'package:ftc_application/src/widgets/empty_page_widget.dart';
import 'package:ftc_application/src/widgets/loading_widget.dart';
import 'package:ftc_application/src/widgets/AdminScreenWidgets/tinder_card.dart';
import 'package:swipe_stack/swipe_stack.dart';

class ApproveImages extends StatefulWidget {
  @override
  _ApproveImagesState createState() => _ApproveImagesState();
}

class _ApproveImagesState extends State<ApproveImages> {
  List<ImageHistory> pendingImages;
  Completer<void> _refreshCompleter;
  final GlobalKey<SwipeStackState> _swipeKey = GlobalKey<SwipeStackState>();
  bool end = false;
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
          BlocProvider.of<ImageApprovalBloc>(context).add(GetPendingImages());
          return LoadingWidget();
        } else if (imageState is PendingImagesLoading) {
          return LoadingWidget();
        } else if (imageState is PendingImagesLoaded) {
          pendingImages = imageState.imageHistory;
          return _tinderPage();
        } else {
          BlocProvider.of<ImageApprovalBloc>(context).add(GetPendingImages());
          return LoadingWidget();
        }
      },
    );
  }

  Widget _tinderPage() {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'قبول الصور',
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
              BlocProvider.of<ImageApprovalBloc>(context)
                  .add(GetPendingImages());
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
                child: end || pendingImages.isEmpty
                    ? EmptyPageWidget(
                        text: 'ماعندك صور تقبلها',
                      )
                    : _swipeList()),
          ),
        ));
  }

  Widget _swipeList() {
    return SwipeStack(
      key: _swipeKey,
      children: pendingImages.map((ImageHistory image) {
        return SwiperItem(builder: (SwiperPosition position, double progress) {
          return Center(
            child: TinderCard(
              image: image,
            ),
          );
        });
      }).toList(),
      visibleCount: 3,
      stackFrom: StackFrom.Top,
      translationInterval: 10,
      scaleInterval: 0.03,
      onSwipe: (int index, SwiperPosition position) => _swipe(index, position),
      onEnd: () => setState(() {
        end = true;
      }),
    );
  }

  _swipe(int index, SwiperPosition position) {
    if (position == SwiperPosition.Right) {
      _onSwipe(
          pendingImages[index].id, pendingImages[index].memberId, "APPROVED");
      _swipeKey.currentState.swipeRight();
    } else {
      _onSwipe(
          pendingImages[index].id, pendingImages[index].memberId, "UNAPPROVED");
      _swipeKey.currentState.swipeLeft();
    }
  }

  _onSwipe(int id, int memberId, String status) {
    BlocProvider.of<ImageApprovalBloc>(context)
        .add(UpdateImageStatus(id, status));

    if (status == "APPROVED") {
      BlocProvider.of<NotificationBloc>(context).add(sendMemberMessage(
          memberId: memberId,
          notification:
              PushNotificationRequest.message('صورك', "قبل الئيس صورتك")));
    } else {
      BlocProvider.of<NotificationBloc>(context).add(sendMemberMessage(
          memberId: memberId,
          notification:
              PushNotificationRequest.message('صورك', "رفظ الرئيس صورتك")));
    }
  }
}
