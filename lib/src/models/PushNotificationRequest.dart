class PushNotificationRequest {
  final String title;
  final String message;
  final String topic = 'FTC-APP';

  PushNotificationRequest.admin(this.title, this.message);
  PushNotificationRequest.message(this.title, this.message);

  Map<String, dynamic> postTopicJson() =>
      <String, dynamic>{'title': title, 'message': message, 'topic': topic};
  Map<String, dynamic> postMessageJson() =>
      <String, dynamic>{'title': title, 'message': message};
}
