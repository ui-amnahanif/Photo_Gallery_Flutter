class Event {
  int? id;
  late String name;
  Event();
  Map<String, dynamic> toMap() {
    Map<String, dynamic> emap = Map<String, dynamic>();
    emap["id"] = id;
    emap["name"] = name;
    return emap;
  }

  Event.fromMap(Map<String, dynamic> e) {
    id = e["id"];
    name = e["name"];
  }
}
