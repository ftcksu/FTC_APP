class ImageHistory {
  int id;
  int memberId;
  String approved;
  bool used;
  String userName;
  ImageHistory({this.id, this.approved});
  ImageHistory.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        used = json['used'],
        approved = json['approved'],
        userName = json['user_name'],
        memberId = json['user_id'];
}
