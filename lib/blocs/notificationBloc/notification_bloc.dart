import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:ftc_application/repositories/ftc_repository.dart';
import './bloc.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final FtcRepository ftcRepository;
  NotificationBloc({@required this.ftcRepository})
      : assert(ftcRepository != null),
        super(null);
  NotificationState get initialState => InitialNotificationState();

  @override
  Stream<NotificationState> mapEventToState(
    NotificationEvent event,
  ) async* {
    if (event is AdminSendNotification) {
      ftcRepository.sendNotification(event.notification);
    }
    if (event is SendMemberMessage) {
      ftcRepository.sendMessage(event.memberId, event.notification);
    }
  }
}
