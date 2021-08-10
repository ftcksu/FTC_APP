class RouteArgument {
  dynamic id = 0;
  List<dynamic> argumentsList;

  RouteArgument({this.id, required this.argumentsList});

  @override
  String toString() {
    return '{id: $id, heroTag:${argumentsList.toString()}}';
  }
}
