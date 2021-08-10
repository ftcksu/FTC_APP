class ImageHistory {
  int id = 0;
  int memberId = 0;
  String approved = "";
  bool used = false;
  String userName = "";

  ImageHistory({required this.id, required this.approved});
  ImageHistory.initital();
  ImageHistory.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        used = json['used'],
        approved = json['approved'],
        userName = json['user_name'],
        memberId = json['user_id'];
}
