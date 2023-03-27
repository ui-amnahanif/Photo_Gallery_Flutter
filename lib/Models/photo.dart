import 'dart:ffi';

class Photo {
  int? id;
  String? title;
  Float? lat;
  Float? lng;
  String path = "";
  String? date_taken;
  String? last_modified_date;
  Photo();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> pmap = Map<String, dynamic>();
    pmap["id"] = id;
    pmap["title"] = title;
    pmap["lat"] = lat;
    pmap["lng"] = lng;
    pmap["path"] = path;
    pmap["date_taken"] = date_taken;
    pmap["last_modified_date"] = last_modified_date;
    return pmap;
  }

  Photo.fromMap(Map<String, dynamic> pmap) {
    id = pmap["id"];
    title = pmap["title"];
    lat = pmap["lat"];
    lng = pmap["lng"];
    path = pmap["path"];
    date_taken = pmap["date_taken"];
    last_modified_date = pmap["last_modified_date"];
  }
}
