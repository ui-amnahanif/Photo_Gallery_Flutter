class Person {
  int? id;
  late String name;
  Person();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> pmap = Map<String, dynamic>();
    pmap["name"] = name;
    return pmap;
  }

  Person.fromMap(Map<String, dynamic> p) {
    id = p["id"];
    name = p["name"];
  }
}
