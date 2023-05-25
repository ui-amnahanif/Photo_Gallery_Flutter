import 'package:photo_gallery/DBHelper/dbhelper.dart';
import 'package:photo_gallery/Models/event.dart';
import 'package:photo_gallery/Models/person.dart';
import 'package:photo_gallery/Models/photo.dart';

class Album {
  int? id;
  late String title;
  String? cover_photo;
  Album();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> amap = Map<String, dynamic>();
    amap["id"] = id;
    amap["title"] = title;
    amap["cover_photo"] = cover_photo;
    return amap;
  }

  Album.fromMap(Map<String, dynamic> a) {
    id = a["id"];
    title = a["title"];
    cover_photo = a["cover_photo"];
  }

  static Future<List<Album>> getAllPersonsAlbums() async {
    List<Album> alist = [];
    Photo p;
    //get all persons from db
    List<Person> plist = await DbHelper.instance.getAllPersons();
    Album a;
    for (int i = 0; i < plist.length; i++) {
      a = Album();
      a.id = plist[i].id;
      a.title = plist[i].name;
      p = await DbHelper.instance.getFirstPhotoOfPersonById(plist[i].id!);
      a.cover_photo = p.path;
      alist.add(a);
    }
    return alist;
  }

  static Future<List<Album>> getAllEventsAlbums() async {
    List<Album> alist = [];
    Photo p;
    //get all events from db
    List<Event> elist = await DbHelper.instance.getAllEvents();
    Album a;
    for (int i = 0; i < elist.length; i++) {
      a = Album();
      a.id = elist[i].id;
      a.title = elist[i].name;
      p = await DbHelper.instance.getFirstPhotoOfEventById(elist[i].id!);
      a.cover_photo = p.path;
      alist.add(a);
    }
    return alist;
  }

  static Future<List<Album>> getAllLocationAlbums() async {
    List<Album> alist = [];
    Album a;
    Map<String, dynamic> locationPhoto =
        await DbHelper.instance.getDistinctLocationAndTheirPhotos();
    List<String> locations = locationPhoto.keys.toList();
    List<Photo> photos = locationPhoto.values.map((e) => e as Photo).toList();
    for (int i = 0; i < locations.length; i++) {
      a = Album();
      a.id = photos[i].id;
      a.title = locations[i];
      a.cover_photo = photos[i].path;
      alist.add(a);
    }
    return alist;
  }

  static Future<List<Album>> getAllLabelAlbums() async {
    List<Album> alist = [];
    Album a;
    List<Photo> plist = await DbHelper.instance.getDistinctLabelPhotos();
    for (int i = 0; i < plist.length; i++) {
      a = Album();
      a.id = plist[i].id;
      a.title = plist[i].label!;
      a.cover_photo = plist[i].path;
      alist.add(a);
    }
    return alist;
  }

  static Future<List<Album>> getAllDatesAlbums() async {
    List<Album> alist = [];
    Album a;
    List<Photo> plist = await DbHelper.instance.getDistinctDatesPhotos();
    for (int i = 0; i < plist.length; i++) {
      a = Album();
      a.id = plist[i].id;
      a.title = plist[i].date_taken!.split(" ")[0];
      a.cover_photo = plist[i].path;
      alist.add(a);
    }
    return alist;
  }

  static Future<List<Album>> getPersonsAlbumsByPhotos(List<Photo> plist) async {
    List<Album> alist = [];
    Album a;
    for (int i = 0; i < plist.length; i++) {
      List<Person> personlist =
          await DbHelper.instance.getAllPersonsByPhotoId(plist[i].id!);
      for (int j = 0; j < personlist.length; j++) {
        if (alist.length == 0) {
          a = Album();
          a.id = personlist[j].id;
          a.title = personlist[j].name;
          Photo p = await DbHelper.instance
              .getFirstPhotoOfPersonById(personlist[j].id!);
          a.cover_photo = p.path;
          alist.add(a);
        } else if (!alist
            .where((album) => album.title == personlist[j].name)
            .isNotEmpty) {
          a = Album();
          a.id = personlist[j].id;
          a.title = personlist[j].name;
          Photo p = await DbHelper.instance
              .getFirstPhotoOfPersonById(personlist[j].id!);
          a.cover_photo = p.path;
          alist.add(a);
        }
      }
    }

    return alist;
  }

  static Future<List<Album>> getEventsAlbumsByPhotos(List<Photo> plist) async {
    List<Album> alist = [];
    Album a;
    for (int i = 0; i < plist.length; i++) {
      List<Event> eventlist =
          await DbHelper.instance.getAllEventsByPhotoId(plist[i].id!);
      for (int j = 0; j < eventlist.length; j++) {
        if (alist.length == 0) {
          a = Album();
          a.id = eventlist[j].id;
          a.title = eventlist[j].name;
          Photo p = await DbHelper.instance
              .getFirstPhotoOfEventById(eventlist[j].id!);
          a.cover_photo = p.path;
          alist.add(a);
        } else if (!alist
            .where((album) => album.title == eventlist[j].name)
            .isNotEmpty) {
          a = Album();
          a.id = eventlist[j].id;
          a.title = eventlist[j].name;
          Photo p = await DbHelper.instance
              .getFirstPhotoOfEventById(eventlist[j].id!);
          a.cover_photo = p.path;
          alist.add(a);
        }
      }
    }
    return alist;
  }

  static Future<List<Album>> getLabelsAlbumsByPhotos(List<Photo> plist) async {
    List<Album> alist = [];
    Album a;
    final Set<String> uniqueLabelsSet = {};
    // Set.from(plist.map((photo) => photo.label));
    // final uniqueLabelsList = uniqueLabelsSet.toList();

    for (Photo photo in plist) {
      if (photo.label != null) {
        // Extract only the first 10 characters (yyyy:mm:dd)
        uniqueLabelsSet
            .add(photo.label!); // Add the date to the set of distinct dates
      }
    }
    List<String> uniqueLabelsList = uniqueLabelsSet.toList();

    for (int i = 0; i < uniqueLabelsList.length; i++) {
      a = Album();
      Photo p = plist.firstWhere((photo) => photo.label == uniqueLabelsList[i]);
      a.id = p.id;
      a.title = p.label!;
      a.cover_photo = p.path;
      alist.add(a);
    }
    return alist;
  }

  static Future<List<Album>> getDatesAlbumsByPhotos(List<Photo> plist) async {
    List<Album> alist = [];
    Album a;
    Set<String> distinctDatesSet = {};

    for (Photo photo in plist) {
      String date = photo.date_taken!.substring(
          0, 10); // Extract only the first 10 characters (yyyy:mm:dd)
      distinctDatesSet.add(date); // Add the date to the set of distinct dates
    }
    List<String> distinctDatesList = distinctDatesSet.toList();
    for (int i = 0; i < distinctDatesList.length; i++) {
      a = Album();
      Photo p = plist.firstWhere((photo) =>
          photo.date_taken!.substring(0, 10) == distinctDatesList[i]);
      a.id = p.id;
      a.title = distinctDatesList[i];
      a.cover_photo = p.path;
      alist.add(a);
    }
    return alist;
  }

  static Future<List<Album>> getLocationsAlbumsByPhotos(
      List<Photo> plist) async {
    List<Album> alist = [];
    Album a;
    for (int i = 0; i < plist.length; i++) {
      if (plist[i].lat != null) {
        String place = await DbHelper.instance
            .getCityFromLatLong(plist[i].lat!, plist[i].lng!);
        if (alist.length == 0) {
          a = Album();
          a.id = plist[i].id;
          a.title = place;
          a.cover_photo = plist[i].path;
          alist.add(a);
        } else if (!alist.where((album) => album.title == place).isNotEmpty) {
          a = Album();
          a.id = plist[i].id;
          a.title = place;
          a.cover_photo = plist[i].path;
          alist.add(a);
        }
      }
    }
    return alist;
  }
  // static List<Album> getAlbums() {
  //   List<Album> alist = [];
  //   Album a = new Album();
  //   a.id = 1;
  //   a.title = "Hassan";
  //   a.image = "assets/images/boy1.jpg";
  //   alist.add(a);
  //   a = new Album();
  //   a.id = 1;
  //   a.title = "Hassan";
  //   a.image = "assets/images/boy2.jpg";
  //   alist.add(a);
  //   a = new Album();
  //   a.id = 1;
  //   a.title = "Amna";
  //   a.image = "assets/images/girl1.png";
  //   alist.add(a);
  //   a = new Album();
  //   a.id = 1;
  //   a.title = "Amna";
  //   a.image = "assets/images/girl2.jpg";
  //   alist.add(a);
  //   a = new Album();
  //   a.id = 1;
  //   a.title = "Amna";
  //   a.image = "assets/images/girl4.jpg";
  //   alist.add(a);
  //   a = new Album();
  //   a.id = 1;
  //   a.title = "Amna";
  //   a.image = "assets/images/girl5.jpg";
  //   alist.add(a);
  //   a = new Album();
  //   a.id = 1;
  //   a.title = "Amna";
  //   a.image = "assets/images/girl1.png";
  //   alist.add(a);
  //   return alist;
  // }
}
