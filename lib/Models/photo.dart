import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_gallery/DBHelper/dbhelper.dart';
import 'package:photo_gallery/Models/event.dart';
import 'package:photo_gallery/Models/person.dart';
import 'package:photo_gallery/Utilities/Global/global.dart';
import 'package:path/path.dart' as pathh;

class Photo {
  int? id;
  String? title;
  double? lat;
  double? lng;
  String path = "";
  String? label;
  String? date_taken;
  String? last_modified_date;
  int? isSynced;
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
    pmap["isSynced"] = isSynced;
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
    isSynced = pmap["isSynced"];
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
    List<Person> plist = await DbHelper.instance.getPersonDetailsByPhotoId(pid);
    List<Event> elist = await DbHelper.instance.getEventDetailsByPhotoId(pid);
    int affectedPhotoRows = await DbHelper.instance.deletePhotobyId(pid);
    int affectedPhotoPersonRows =
        await DbHelper.instance.deletePhotoPersonByPhotoId(pid);
    int affectedPhotoEventRows =
        await DbHelper.instance.deletePhotoEventByPhotoId(pid);
    for (int i = 0; i < plist.length; i++) {
      int photoPersonCount =
          await DbHelper.instance.getPhotoPersonCountbyPersonId(plist[i].id!);
      if (photoPersonCount == 0) {
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

  static Future<bool> syncingPhoto() async {
    String url = '${ip}/syncNow';
    Uri uri = Uri.parse(url);
    List<Map<String, dynamic>> mapList = [];
    List<Photo> plist = await DbHelper.instance.getAllPhotos();
    Map<String, dynamic> map;
    for (int i = 0; i < plist.length; i++) {
      map = Map<String, dynamic>();
      map["title"] = plist[i].title;
      map["lat"] = plist[i].lat ?? 0.0;
      map["lng"] = plist[i].lng ?? 0.0;
      map["label"] = plist[i].label ?? "";
      map["date_taken"] = plist[i].date_taken;
      map["last_modified_date"] = plist[i].last_modified_date;
      map["people"] = [];
      map["isSynced"] = plist[i].isSynced;
      List<Person> perlist =
          await DbHelper.instance.getAllPersonsByPhotoId(plist[i].id!);
      for (int j = 0; j < perlist.length; j++) {
        map["people"].add(perlist[j].name.toString());
      }
      map["events"] = [];
      List<Event> elist =
          await DbHelper.instance.getAllEventsByPhotoId(plist[i].id!);
      for (int j = 0; j < elist.length; j++) {
        map["events"].add(elist[j].name.toString());
      }
      mapList.add(map);
    }
    for (int i = 0; i < mapList.length; i++) {
      final map = mapList[i];
      print(map.toString());
      print("Map $i:");
      map.forEach((key, value) {
        print("$key: $value");
      });
    }
    final json = jsonEncode(mapList);
    print(json);
    //print(mapList.toString());
    final response = await http.post(uri,
        body: json,
        headers: <String, String>{'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      //change all photos synced to 1
      DbHelper.instance.updateIsSyncedTo1();
      var jsonResponse = jsonDecode(response.body);
      // Use jsonResponse object to access the returned data
      print(jsonResponse);
      // List<Photo> plist = getPhotoListFromJson(jsonResponse);
      Photo p;
      List<Person> plist = [];
      List<Event> elist = [];
      Person per;
      Event e;
      for (int i = 0; i < jsonResponse.length; i++) {
        if (jsonResponse[i]["isSynced"] == 0) {
          String url = '${ip}/images/${jsonResponse[i]["title"]}';
          String path = await downloadFile(url);
          p = Photo();
          p.path = path;
          p.title = jsonResponse[i]["title"];
          p.label = jsonResponse[i]["label"];
          p.lat = jsonResponse[i]["lat"] != 0.0 ? jsonResponse[i]["lat"] : null;
          p.lng = jsonResponse[i]["lng"] != 0.0 ? jsonResponse[i]["lng"] : null;
          p.date_taken = jsonResponse[i]["date_taken"];
          p.last_modified_date = jsonResponse[i]["last_modified_date"];
          p.isSynced = 1;
          List<dynamic> peopleList = jsonResponse[i]['people'];

          for (var pers in peopleList) {
            plist = [];
            print(pers);
            per = Person();
            per.name = pers.toString();
            plist.add(per);
          }
          List<dynamic> eventList = jsonResponse[i]['events'];

          for (var eve in eventList) {
            elist = [];
            print(eve);
            e = Event();
            e.name = eve.toString();
            elist.add(e);
          }
          int photoId = await DbHelper.instance.insertPhoto(p);
          await Person.insertPersons(plist, photoId);
          await Event.insertEvents(elist, photoId);
        } else {
          //get photo detail by title
          Photo photoDetail =
              await DbHelper.instance.getPhotoByTitle(jsonResponse[i]["title"]);
          //compare dates
          String compare = compareDates(jsonResponse[i]["last_modified_date"],
              photoDetail.last_modified_date!);
          //if windows date greater
          if (compare == "date1") {
            //get all events
            List<Event> eventsList =
                await DbHelper.instance.getAllEventsByPhotoId(photoDetail.id!);
            //get all persons
            List<Person> personsList =
                await DbHelper.instance.getAllPersonsByPhotoId(photoDetail.id!);
            //delete all photo person links
            for (int j = 0; j < personsList.length; j++) {
              Person.deletePerson(personsList[j].id!, photoDetail.id!);
            }
            //delete all photo events links
            for (int j = 0; j < eventsList.length; j++) {
              Event.deleteEvent(eventsList[j].id!, photoDetail.id!);
            }
            //insert persons
            List<dynamic> peopleList = jsonResponse[i]['people'];

            for (var pers in peopleList) {
              plist = [];
              print(pers);
              per = Person();
              per.name = pers.toString();
              plist.add(per);
            }
            await Person.insertPersons(plist, photoDetail.id!);

            //insert events
            List<dynamic> eventList = jsonResponse[i]['events'];

            for (var eve in eventList) {
              elist = [];
              print(eve);
              e = Event();
              e.name = eve.toString();
              elist.add(e);
            }
            await Event.insertEvents(elist, photoDetail.id!);
            //update photo
            photoDetail.label = jsonResponse[i]["label"];
            photoDetail.date_taken = jsonResponse[i]["date_taken"];
            photoDetail.last_modified_date =
                jsonResponse[i]["last_modified_date"];
            photoDetail.lat = jsonResponse[i]["lat"];
            photoDetail.lng = jsonResponse[i]["lng"];
            await DbHelper.instance.editPhotobyid(photoDetail);
          }
        }
      }
      return true;
    } else {
      return false;
    }
  }

  static void updatePicturesLocationByEventId(
      int id, double lat, double lng) async {
    List<Photo> eventPhotoList =
        await DbHelper.instance.getPhotosofEventById(id);
    for (int i = 0; i < eventPhotoList.length; i++) {
      eventPhotoList[i].lat = lat;
      eventPhotoList[i].lng = lng;
      //changing last modified date as well
      DateTime currentDateTime = DateTime.now();
      String formattedDateTime =
          DateFormat("yyyy:MM:dd HH:mm:ss").format(currentDateTime);
      //print(formattedDateTime);
      eventPhotoList[i].last_modified_date = formattedDateTime;
      await DbHelper.instance.editPhotobyid(eventPhotoList[i]);
    }
  }

  static List<Photo> getPhotoListFromJson(var jsonData) {
    List<Photo> plist = [];

    for (int i = 0; i < jsonData.length; i++) {
      Photo p = Photo.fromMap(jsonData[i]);
      plist.add(p);
    }
    return plist;
  }

  static Future<String> downloadFile(String url) async {
    // Get the filename from the URL.
    final filename = pathh.basename(url);

    // Get a reference to the directory where images are stored.
    final Directory? appDir = await getExternalStorageDirectory();
    final String imagesDir = pathh.join(appDir!.path, 'images');

    // Create the directory if it doesn't exist.
    if (!Directory(imagesDir).existsSync()) {
      Directory(imagesDir).createSync(recursive: true);
    }

    // Send the HTTP request to download the file.
    final response = await http.get(Uri.parse(url));

    // Write the file to disk.
    final file = File('$imagesDir/$filename');
    await file.writeAsBytes(response.bodyBytes);

    print('File downloaded and saved to: ${file.path}');
    return file.path;
  }

  static String compareDates(String date1, String date2) {
    DateTime dateTime1 = DateTime.parse(
        date1.replaceAll(':', '-').substring(0, 10) +
            ' ' +
            date1.substring(11));
    DateTime dateTime2 = DateTime.parse(
        date2.replaceAll(':', '-').substring(0, 10) +
            ' ' +
            date2.substring(11));

// Compare the dates
    int dateComparison = dateTime1.compareTo(dateTime2);
    if (dateComparison > 0) {
      print('dateTime1 is greater');
      return "date1";
    } else if (dateComparison < 0) {
      print('dateTime2 is greater');
      return "date2";
    } else {
      // Dates are the same, compare the times
      if (dateTime1.timeZoneOffset.inHours > dateTime2.timeZoneOffset.inHours) {
        print('dateTime1 is greater');
        return "date1";
      } else if (dateTime1.timeZoneOffset.inHours <
          dateTime2.timeZoneOffset.inHours) {
        print('dateTime2 is greater');
        return "date2";
      } else if (dateTime1.minute > dateTime2.minute) {
        print('dateTime1 is greater');
        return "date1";
      } else if (dateTime1.minute < dateTime2.minute) {
        print('dateTime2 is greater');
        return "date2";
      } else if (dateTime1.second > dateTime2.second) {
        print('dateTime1 is greater');
        return "date1";
      } else if (dateTime1.second < dateTime2.second) {
        print('dateTime2 is greater');
        return "date2";
      } else {
        print('Both DateTimes are the same');
        return "same";
      }
    }
  }
}
