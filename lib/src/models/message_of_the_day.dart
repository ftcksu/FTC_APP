class MessageOfTheDay {
  String message = "";
  String member = "";

  MessageOfTheDay({required this.message, required this.member});
  MessageOfTheDay.initial();
  MessageOfTheDay.fromJson(Map<String, dynamic> json)
      : message = json['message'] as String,
        member = json['user'] as String;
}
