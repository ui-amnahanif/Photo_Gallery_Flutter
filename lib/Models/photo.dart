import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:photo_gallery/DBHelper/dbhelper.dart';
import 'package:photo_gallery/Models/event.dart';
import 'package:photo_gallery/Models/person.dart';
import 'package:photo_gallery/Utilities/Global/global.dart';

class Photo {
  int? id;
  String? title;
  double? lat;
  double? lng;
  String path = "";
  String? label;
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
    pmap["label"] = label;
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
    label = pmap["label"];
    date_taken = pmap["date_taken"];
    last_modified_date = pmap["last_modified_date"];
  }
  static Future<List<String>> saveImage(File f) async {
    List<String> people = [];
    String url = '${ip}/saveImage';
    Uri uri = Uri.parse(url);
    var request = http.MultipartRequest('POST', uri);
    http.MultipartFile newfile =
        await http.MultipartFile.fromPath('file', f.path);
    request.files.add(newfile);
    var response = await request.send();
    if (response.statusCode == 200) {
      var v = await response.stream.bytesToString();
      if (v != "\"No faces found\"") {
        Map<String, dynamic> res = jsonDecode(v);
        people = res.keys.toList();
      }
    }
    return people;
  }

  static Future<void> deletePhoto(int pid) async {
    int affectedPhotoRows = await DbHelper.instance.deletePhotobyId(pid);
    int affectedPhotoPersonRows =
        await DbHelper.instance.deletePhotoPersonByPhotoId(pid);
    int affectedPhotoEventRows =
        await DbHelper.instance.deletePhotoEventByPhotoId(pid);
    List<Person> plist = await DbHelper.instance.getPersonDetailsByPhotoId(pid);
    List<Event> elist = await DbHelper.instance.getEventDetailsByPhotoId(pid);
    for (int i = 0; i < plist.length; i++) {
      int photoEventCount =
          await DbHelper.instance.getPhotoPersonCountbyPersonId(plist[i].id!);
      if (photoEventCount == 0) {
        int affectedRows =
            await DbHelper.instance.deletePersonbyId(plist[i].id!);
      }
    }
    for (int i = 0; i < elist.length; i++) {
      int photoEventCount =
          await DbHelper.instance.getPhotoEventCountbyEventId(elist[i].id!);
      if (photoEventCount == 0) {
        int affectedRows =
            await DbHelper.instance.deleteEventbyId(elist[i].id!);
      }
    }
  }

  static Future<List<Photo>> getPersonPhotosFromPhotosList(
      List<Photo> plist, int id) async {
    List<Photo> PhotosList = [];
    List<Photo> personPhotoList =
        await DbHelper.instance.getPhotosofPersonById(id);
    for (int i = 0; i < plist.length; i++) {
      for (int j = 0; j < personPhotoList.length; j++) {
        if (personPhotoList[j].id == plist[i].id) {
          PhotosList.add(plist[i]);
        }
      }
    }
    return PhotosList;
  }

  static Future<List<Photo>> getEventnPhotosFromPhotosList(
      List<Photo> plist, int id) async {
    List<Photo> PhotosList = [];
    List<Photo> eventPhotoList =
        await DbHelper.instance.getPhotosofEventById(id);
    for (int i = 0; i < plist.length; i++) {
      for (int j = 0; j < eventPhotoList.length; j++) {
        if (eventPhotoList[j].id == plist[i].id) {
          PhotosList.add(plist[i]);
        }
      }
    }
    return PhotosList;
  }

  static Future<List<Photo>> getDatesPhotosFromPhotosList(
      List<Photo> plist, int id) async {
    List<Photo> PhotosList = [];
    List<Photo> datesPhotoList =
        await DbHelper.instance.getPhotosofDateByPhotoId(id);
    for (int i = 0; i < plist.length; i++) {
      for (int j = 0; j < datesPhotoList.length; j++) {
        if (datesPhotoList[j].id == plist[i].id) {
          PhotosList.add(plist[i]);
        }
      }
    }
    return PhotosList;
  }

  static Future<List<Photo>> getLabelPhotosFromPhotosList(
      List<Photo> plist, String title) async {
    List<Photo> PhotosList = [];
    List<Photo> labelPhotoList =
        await DbHelper.instance.getPhotosofLabelByTitle(title);
    for (int i = 0; i < plist.length; i++) {
      for (int j = 0; j < labelPhotoList.length; j++) {
        if (labelPhotoList[j].id == plist[i].id) {
          PhotosList.add(plist[i]);
        }
      }
    }
    return PhotosList;
  }

  static Future<List<Photo>> getLocationPhotosFromPhotosList(
      List<Photo> plist, String title) async {
    List<Photo> PhotosList = [];
    List<Photo> locationPhotoList =
        await DbHelper.instance.getPhotosofLocationByTitle(title);
    for (int i = 0; i < plist.length; i++) {
      locationPhotoList.forEach((element) {
        if (element.id == plist[i].id) {
          PhotosList.add(plist[i]);
        }
      });
      // for (int j = 0; j < locationPhotoList.length; j++) {
      //   if (locationPhotoList[j].id == plist[i].id) {
      //     PhotosList.add(plist[i]);
      //   }
      // }
    }
    return PhotosList;
  }
}
