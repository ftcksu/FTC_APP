import 'package:equatable/equatable.dart';
import 'package:ftc_application/src/models/PushNotificationRequest.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
  @override
  List<Object> get props => [];
}

class AdminSendNotification extends NotificationEvent {
  final PushNotificationRequest notification;

  AdminSendNotification({this.notification});
}

class sendMemberMessage extends NotificationEvent {
  final PushNotificationRequest notification;
  final int memberId;
  sendMemberMessage({this.memberId, this.notification});
}
