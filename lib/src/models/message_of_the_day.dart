
class MessageOfTheDay {
  String message;
  String member;

  MessageOfTheDay({this.message, this.member});
  MessageOfTheDay.fromJson(Map<String, dynamic> json)
      : message = json['message'] as String,
        member = json['user'] as String;
}
