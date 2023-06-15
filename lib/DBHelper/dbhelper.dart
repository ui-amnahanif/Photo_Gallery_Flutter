import 'package:geocoding/geocoding.dart';
import 'package:sqflite/sqflite.dart';
import '../Models/album.dart';
import '../Models/event.dart';
import '../Models/person.dart';
import '../Models/photo.dart';

class DbHelper {
  DbHelper._privateConstructor();
  static DbHelper instance = DbHelper._privateConstructor();
  Database? _database;
  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    String path = await getDatabasesPath();
    path += "photogallerydb";
    var db = await openDatabase(path, version: 1, onCreate: _createDB);
    return db;
  }

  // static Future _onConfigure(Database db) async {
  //   await db.execute('PRAGMA foreign_keys = ON');
  // }

  void _createDB(Database db, int version) {
    String query = '''
                    create table Photo
                    (
                      id integer primary key autoincrement,
                      title text,
                      lat real,
                      lng real,
                      path text,
                      label text,
                      date_taken text,
                      last_modified_date text,
                      isSynced integer
                    )
                  ''';
    db.execute(query);
    query = '''
            create table Album
            (
              id integer primary key autoincrement,
              title text,
              cover_photo text
            )
''';
    db.execute(query);
    query = '''
            create table AlbumPhoto
            (
              album_id REFERENCES Album(id),
              photo_id REFERENCES Photo(id)
            )
''';
    db.execute(query);
    query = '''
            create table Person
            (
              id integer primary key autoincrement,
              name text
            )
    ''';

    db.execute(query);
    query = '''
            create table Event
            (
              id integer primary key autoincrement,
              name text
            )
''';
    db.execute(query);
    query = '''
            create table PhotoPerson
            (
              photo_id REFERENCES Photo(id) ,
              person_id REFERENCES Person(id)
            )
''';

    db.execute(query);
    query = '''
            create table PhotoEvent
            (
            photo_id REFERENCES Photo(id),
            event_id REFERENCES Event(id)
            )
''';
    db.execute(query);
//     print("DB CREATED");
//     query = '''
//           Insert into photo(title, path,date_taken) values
//           ("image1","assets/images/amna-1.jpeg","2023:02:21 14:57:20"),
//           ("IMG-20210703-WA0091.jpg","assets/images/IMG-20210703-WA0091.jpg","2021:02:21 14:57:20"),
//           ("image3","assets/images/amna-3.jpg","2022:02:21 14:57:20"),
//           ("image4","assets/images/amna-alesha.jpg","2020:02:21 14:57:20"),
//           ("image5","assets/images/amna-hassan-1.jpeg","2023:02:21 14:57:20"),
//           ("image6","assets/images/amna-hassan-2.jpg","2023:02:21 14:57:20"),
//           ("image7","assets/images/amna-hassan-3.jpg","2023:02:21 14:57:20"),
//           ("image8","assets/images/amna-saman.jpeg","2023:02:21 14:57:20"),
//           ("image9","assets/images/amna-siqlain-mama-papa.jpg","2022:02:21 14:57:20"),
//           ("image10","assets/images/hassan-1.jpeg","2023:02:21 14:57:20"),
//           ("WhatsAppImage2023-03-20at5.21.41AM","assets/images/WhatsAppImage2023-03-20at5.21.41AM.jpeg","2022:02:21 14:57:20"),
//           ("IMG-20210704-WA0002","assets/images/IMG-20210704-WA0002.jpg","2021:02:21 14:57:20"),
//           ("IMG-20210704-WA0003","assets/images/IMG-20210704-WA0003.jpg","2021:02:21 14:57:20"),
//           ("WhatsAppImage2023-03-20at5.22.24AM","assets/images/WhatsAppImage2023-03-20at5.22.24AM.jpeg","2022:02:21 14:57:20"),
//           ("IMG_20210509_140207_181","assets/images/IMG_20210509_140207_181.jpg","2020:02:21 14:57:20"),
//           ("IMG-20220506-WA0007","assets/images/IMG-20220506-WA0007.jpg","2022:02:21 14:57:20"),
//           ("IMG-20220506-WA0009","assets/images/IMG-20220506-WA0009.jpg","2022:02:21 14:57:20")

// ''';
//     db.rawInsert(query);
//     print("Inserted into picture's table");

//     query = '''
//           Insert into Album(title, cover_photo) values
//            ("others","assets/images/amna-siqlain-mama-papa.jpg")

// ''';
//     // ("Amna","assets/images/amna-2.jpg"),
//     // ("Hassan","assets/images/hassan-1.jpeg"),
//     // ("Saman","assets/images/amna-saman.jpeg"),
//     // ("Alesha","assets/images/amna-alesha.jpg"),
//     // ("Siqlain","assets/images/amna-siqlain-mama-papa.jpg"),
//     // ("Mama","assets/images/amna-siqlain-mama-papa.jpg"),
//     // ("Papa","assets/images/amna-siqlain-mama-papa.jpg")
//     db.rawInsert(query);
//     print("Inserted into albumPhoto table");

//     query = '''
//           Insert into AlbumPhoto(album_id, photo_id) values
//          (1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,7),(1,8),(1,9),(1,10),(1,11),(1,12),(1,13),(1,14)

// ''';
//     // (1,"1111"),(1,"2222"),(1,"3333"),(1,"4444"),(1,"5555"),(1,"6666"),(1,"7777"),(1,"8888"),(1,"9999"),
//     // (2,"5555"),(2,"6666"),(2,"7777"),(2,"0000"),(2,"0111"),(2,"0222"),
//     // (3,"8888"),
//     // (4,"4444"),
//     // (5,"9999"),(5,"0222"),
//     // (6,"9999"),(6,"0222"),
//     // (7,"9999"),(7,"0222")
//     db.rawInsert(query);
//     print("Inserted into ALBUMPHOTO table");
  }

  Future<int> insertPhoto(Photo p) async {
    Database db = await instance.database;
    int r = await db.insert("photo", p.toMap());
    List<Map<String, dynamic>> data = await db.query("photo");
    for (int i = 0; i < data.length; i++) {
      print(
          "id = ${data[i]["id"]} title = ${data[i]["title"]} lat = ${data[i]["lat"]} lng = ${data[i]["lng"]} path = ${data[i]["path"]} label = ${data[i]["label"]} datetaken = ${data[i]["date_taken"]} lastmodifieddate = ${data[i]["last_modified_date"]}");
    }
    print("inserted");
    return r;
  }

  Future<List<Album>> getAllAlbums() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> data = await db.query("Album");
    List<Album> album_list = [];
    for (int i = 0; i < data.length; i++) {
      Album a = Album.fromMap(data[i]);
      album_list.add(a);
    }
    print("data length ${album_list.length}");
    return album_list;
  }

  Future<List<Album>> getPeopleAlbums() async {
    List<Person> person_list = [];
    List<Album> album_list = [];
    Database db = await instance.database;
    List<Map<String, dynamic>> data1 = await db.query("Person");
    for (int i = 0; i < data1.length; i++) {
      person_list.add(Person.fromMap(data1[i]));
    }
    for (int i = 0; i < person_list.length; i++) {
      List<Map<String, dynamic>> data = await db
          .query("Album", where: 'title=?', whereArgs: [person_list[i].name]);
      album_list.add(Album.fromMap(data[0]));
    }
    return album_list;
  }

  Future<List<Person>> getAllPersons() async {
    List<Person> person_list = [];
    Database db = await instance.database;
    List<Map<String, dynamic>> data1 = await db.query("Person");
    for (int i = 0; i < data1.length; i++) {
      person_list.add(Person.fromMap(data1[i]));
    }
    return person_list;
  }

  Future<List<Event>> getAllEvents() async {
    List<Event> event_list = [];
    Database db = await instance.database;
    List<Map<String, dynamic>> data1 = await db.query("Event");
    for (int i = 0; i < data1.length; i++) {
      event_list.add(Event.fromMap(data1[i]));
    }
    return event_list;
  }

  Future<List<String>> getAllLabels() async {
    List<String> label_list = [];
    Database db = await instance.database;
    List<Map<String, dynamic>> data1 =
        await db.query("Photo", columns: ['label'], distinct: true);
    for (int i = 0; i < data1.length; i++) {
      if (data1[i]["label"] != null) {
        label_list.add(data1[i]["label"].toString());
      }
    }
    return label_list;
  }

  Future<List<String>> getAllLocations() async {
    List<String> places = [];
    List<Photo> plist = await getAllPhotoHavingLatLng();
    for (int i = 0; i < plist.length; i++) {
      String p = await getCityFromLatLong(plist[i].lat!, plist[i].lng!);
      if (!places.contains(p)) {
        places.add(p); //do mot add repeated places
      }
    }
    return places;
  }

  Future<List<Album>> getEventAlbums() async {
    List<Event> event_list = [];
    List<Album> album_list = [];
    Database db = await instance.database;
    List<Map<String, dynamic>> data1 = await db.query("Event");
    for (int i = 0; i < data1.length; i++) {
      event_list.add(Event.fromMap(data1[i]));
    }
    for (int i = 0; i < event_list.length; i++) {
      List<Map<String, dynamic>> data = await db
          .query("Album", where: 'title=?', whereArgs: [event_list[i].name]);
      album_list.add(Album.fromMap(data[0]));
    }
    return album_list;
  }

  Future<List<Album>> getLabelAlbums() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> data =
        await db.query("Photo", columns: ["label"]);
    List<String> labels = [];
    for (int i = 0; i < data.length; i++) {
      if (data[i]["label"] != null) {
        labels.add(data[i]["label"]);
      }
    }
    Set<String> distinctItems = labels.toSet();
    labels = distinctItems.toList();
    List<Album> album_list = [];
    for (int i = 0; i < labels.length; i++) {
      List<Map<String, dynamic>> data =
          await db.query("Album", where: 'title=?', whereArgs: [labels[i]]);
      if (data != null) {
        album_list.add(Album.fromMap(data[0]));
      }
    }
    return album_list;
  }

  Future<List<Album>> getDateAlbums() async {
    List<Album> album_list = [];
    Album a;
    Database db = await instance.database;
    String query =
        "SELECT DISTINCT SUBSTR(date_taken, 1, 10) AS distinct_date FROM photo;";
    List<Map<String, dynamic>> distict_dates = await db.rawQuery(query);
    // query = "SELECT DISTINCT date_taken AS distinct_date FROM photo;";
    // List<Map<String, dynamic>> distict_datesWithTIme = await db.rawQuery(query);
    for (int i = 0; i < distict_dates.length; i++) {
      a = Album();
      a.title =
          distict_dates[i]["distinct_date"].toString().replaceAll(":", "-");
      List<String> dateComponents =
          distict_dates[i]["distinct_date"].toString().split(':');
      int year = int.parse(dateComponents[0]);
      int month = int.parse(dateComponents[1]);
      int day = int.parse(dateComponents[2]);
      a.id = int.parse('$year$month$day');
      String query =
          "SELECT path from photo where SUBSTR(date_taken, 1, 10) like '${distict_dates[i]["distinct_date"]}' limit 1;";
      List<Map<String, dynamic>> data1 = await db.rawQuery(query);
      // List<Map<String, dynamic>> data1 = await db.query("photo",
      //     columns: ["path"],
      //     where: "date_taken = ? ",
      //     whereArgs: [distict_datesWithTIme[i]["distinct_date"]],
      //     limit: 1);
      a.cover_photo = data1[0]["path"];
      album_list.add(a);
    }
    return album_list;
  }

  Future<List<Album>> getLocationAlbums() async {
    List<Album> album_list = [];
    Album a;
    List<String> places = [];
    List<Photo> plist = await getAllPhotoHavingLatLng();
    List<Photo> photoforpathList = [];
    // plist.forEach((element) async {
    //   String p = await getCityFromLatLong(element.lat!, element.lng!);
    //   places.add(p);
    // });
    for (int i = 0; i < plist.length; i++) {
      String p = await getCityFromLatLong(plist[i].lat!, plist[i].lng!);
      if (!places.contains(p)) {
        places.add(p); //do mot add repeated places
        photoforpathList.add(plist[i]);
      }
    }
    // // Remove repeated elements from the list.
    // Set<String> newList = Set.from(places);
    // // Convert the set to a list.
    // List<String> uniquePlacesList = newList.toList();
    for (int i = 0; i < photoforpathList.length; i++) {
      a = Album();
      a.id = 0 - (i + 1);
      a.title = places[i];
      a.cover_photo = photoforpathList[i].path;
      album_list.add(a);
    }
    return album_list;
  }

  Future<List<Photo>> getPhotosOfAlbum(int id, String title) async {
    Database db = await instance.database;

    List<Map<String, dynamic>> data =
        await db.query("AlbumPhoto", where: "album_id=?", whereArgs: [id]);
    List<int> photo_ids = [];
    List<Photo> photo_list = [];
    if (data.length != 0) {
      for (int i = 0; i < data.length; i++) {
        photo_ids.add(data[i]["photo_id"]);
      }

      for (int i = 0; i < photo_ids.length; i++) {
        data =
            await db.query("Photo", where: "id=?", whereArgs: [photo_ids[i]]);
        photo_list.add(Photo.fromMap(data[0]));
      }
      print("data length ${photo_ids}");
    } else if (title.contains("-")) {
      // String escaped_date_str = title.replaceAll(':', r'\\:');
      String query =
          "SELECT * FROM photo where SUBSTR(date_taken, 1, 10) = '${title.replaceAll("-", ":")}' ;";
      data = await db.rawQuery(query);

      for (int i = 0; i < data.length; i++) {
        photo_list.add(Photo.fromMap(data[i]));
      }
    } else {
      List<Photo> plist = await getAllPhotoHavingLatLng();
      for (int i = 0; i < plist.length; i++) {
        String p = await getCityFromLatLong(plist[i].lat!, plist[i].lng!);
        if (p == title) {
          photo_list.add(plist[i]);
        }
      }
    }
    return photo_list;
  }

  Future<List<Album>> getAlbumsOfPhotos(List<Photo> plist) async {
    Database db = await instance.database;
    List<Album> alist = [];
    String query;
    for (int i = 0; i < plist.length; i++) {
      query =
          "select * from Album inner join albumphoto on album.id=albumphoto.album_id where albumphoto.photo_id=${plist[i].id}";
      List<Map<String, dynamic>> data = await db.rawQuery(query);
      for (int j = 0; j < data.length; j++) {
        alist.add(Album.fromMap(data[j]));
      }
    }
    //alist = alist.toSet().toList();
    var seen = Set<String>();
    List<Album> uniqueAlbumlist =
        alist.where((album) => seen.add(album.id.toString())).toList();
    return uniqueAlbumlist;
  }

  Future<Photo> getPhotoById(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> data =
        await db.query("Photo", where: "id=?", whereArgs: [id]);
    Photo p = Photo.fromMap(data[0]);
    return p;
  }

  Future<Photo> getPhotoByTitle(String title) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> data =
        await db.query("Photo", where: "title=?", whereArgs: [title]);
    Photo p = Photo.fromMap(data[0]);
    return p;
  }

  Future<List<Photo>> getAllPhotos() async {
    Database db = await instance.database;
    List<Photo> plist = [];
    List<Map<String, dynamic>> data = await db.query("Photo");
    for (int i = 0; i < data.length; i++) {
      plist.add(Photo.fromMap(data[i]));
    }

    return plist;
  }

  Future<List<Person>> getPersonDetailsByPhotoId(int id) async {
    Database db = await instance.database;
    List<int> person_ids = [];
    List<Person> plist = [];
    List<Map<String, dynamic>> data2 = [];
    List<Map<String, dynamic>> data =
        await db.query("PhotoPerson", where: "Photo_id=?", whereArgs: [id]);
    for (int i = 0; i < data.length; i++) {
      data2 = await db
          .query("Person", where: "id=?", whereArgs: [data[i]["person_id"]]);

      for (int i = 0; i < data2.length; i++) {
        plist.add(Person.fromMap(data2[i]));
      }
    }
    return plist;
  }

  Future<List<Event>> getEventDetailsByPhotoId(int id) async {
    Database db = await instance.database;
    List<int> event_ids = [];
    List<Event> elist = [];
    List<Map<String, dynamic>> data =
        await db.query("PhotoEvent", where: "photo_id=?", whereArgs: [id]);
    for (int i = 0; i < data.length; i++) {
      List<Map<String, dynamic>> data1 = await db
          .query("Event", where: "id=?", whereArgs: [data[i]["event_id"]]);
      elist.add(Event.fromMap(data1[i]));
    }
    return elist;
  }

  Future<void> editPhotobyid(Photo p) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> existingPhoto =
        await db.query("Photo", where: "id=?", whereArgs: [p.id]);
    Photo existingPhotoData = Photo.fromMap(existingPhoto[0]);
    if (p.label != null) {
      if (existingPhotoData.label == null) {
        db.update("Photo", p.toMap(), where: "id=?", whereArgs: [p.id]);
        List<Map<String, dynamic>> albumExist =
            await db.query("Album", where: "title=?", whereArgs: [p.label]);
        if (albumExist.length == 0) {
          Album a =
              Album(); //hamesha album ni bnani. agr album exist krti h toh us ki id le k photo k sath link krni h
          a.title = p.label!;
          a.cover_photo = p.path;
          int a_id = await db.insert("Album", a.toMap()); //inserting into album
          var value = {'album_id': a_id, 'photo_id': p.id};
          db.insert("AlbumPhoto", value);
        } else {
          Album albumExistData = Album.fromMap(albumExist[0]);
          var value = {'album_id': albumExistData.id, 'photo_id': p.id};
          db.insert("AlbumPhoto", value);
        }
      } else {
        db.update("Photo", p.toMap(), where: "id=?", whereArgs: [p.id]);
        // Album a = Album();
        // a.title = p.label!;

        String query =
            "UPDATE album SET title = '${p.label}' WHERE title = '${existingPhotoData.label}';";
        db.execute(query);
        // db.update("Album", a.toMap(),
        //     where: "title=?", whereArgs: [existingPhotoData.label]);
      }
    }
    if (p.label == null) {
      db.update("Photo", p.toMap(), where: "id=?", whereArgs: [p.id]);
    }

    List<Map<String, dynamic>> data = await db.query("Photo");

    print("Photo Table updated succesfully");
  }

  Future<void> inserteditPersonAndAlbumbyid(
      Photo photo, List<Person> plist) async {
    Database db = await instance.database;
    List<Person> personsList = [];
    bool isAlbuminserted = false;
    List<Map<String, dynamic>> data = await db.query("Person");

    for (int i = 0; i < data.length; i++) {
      personsList.add(Person.fromMap(data[i]));
    }

    for (int i = 0; i < plist.length; i++) {
      bool isidpresent = false;
      bool isnamepresent = false;
      Person presentPerson = Person();
      for (int j = 0; j < personsList.length; j++) {
        if (plist[i].id == personsList[j].id) {
          isidpresent = true;
        }
        if (plist[i].name == personsList[j].name) {
          isnamepresent = true;
          presentPerson = personsList[j];
        }
      }
      if (isidpresent) {
        db.update("Person", plist[i].toMap(), //updating name of a person
            where: "id=?",
            whereArgs: [plist[i].id]);
        String query =
            "SELECT id FROM album WHERE title = '${plist[i].name}';"; //to get album id
        List<Map<String, dynamic>> id_data = await db.rawQuery(query);
        int id = int.parse(id_data[0]["id"].toString());
        db.update("Album", plist[i].toMap(), //edit album name
            where: "id=?",
            whereArgs: [id]);
      } else if (isnamepresent) {
        var value = {'photo_id': photo.id, 'person_id': presentPerson.id};
        db.insert("PhotoPerson",
            value); //if person already exists than add in photoperson table
        List<Map<String, dynamic>> data3 = await db
            .query("Album", where: "title=?", whereArgs: [presentPerson.name]);
        Album a = Album.fromMap(data3[0]);
        value = {
          'album_id': a.id,
          'photo_id': photo.id
        }; //if album already exists then insert into albumphoto
        db.insert("AlbumPhoto", value);
        isAlbuminserted = true;
      } else {
        int person_id = await db.insert("Person",
            plist[i].toMap()); //inserting into person and photoperson table
        var value = {'photo_id': photo.id, 'person_id': person_id};
        db.insert("PhotoPerson", value);
        Album a = Album();
        a.title = plist[i].name;
        a.cover_photo = photo.path;
        int a_id = await db.insert("Album", a.toMap()); //inserting into album
        value = {'album_id': a_id, 'photo_id': photo.id};
        db.insert("AlbumPhoto", value);
        isAlbuminserted = true;
      }
    }
    // if (isAlbuminserted) {
    //   await db.delete('AlbumPhoto',
    //       where: 'album_id = ? AND photo_id=?', whereArgs: [1, photo.id]);
    // }
  }

  Future<void> inserteditEventbyid(
      Photo photo, List<Event> elist, int album_id) async {
    Database db = await instance.database;
    bool isAlbuminserted = false;
    List<Event> eventsList = [];
    List<Map<String, dynamic>> data = await db.query("Event");

    for (int i = 0; i < data.length; i++) {
      eventsList.add(Event.fromMap(data[i]));
    }

    for (int i = 0; i < elist.length; i++) {
      bool isidpresent = false;
      bool isnamepresent = false;
      Event presentEvent = Event();
      for (int j = 0; j < eventsList.length; j++) {
        if (elist[i].id == eventsList[j].id) {
          isidpresent = true;
        }
        if (elist[i].name == eventsList[j].name) {
          isnamepresent = true;
          presentEvent = eventsList[j];
        }
      }
      if (isidpresent) {
        db.update("Event", elist[i].toMap(),
            where: "id=?", whereArgs: [elist[i].id]);
        db.update("Album", elist[i].toMap(), //edit album name
            where: "id=?",
            whereArgs: [album_id]);
      } else if (isnamepresent) {
        var value = {'photo_id': photo.id, 'event_id': presentEvent.id};
        db.insert("PhotoEvent", value);
        List<Map<String, dynamic>> data3 = await db
            .query("Album", where: "title=?", whereArgs: [presentEvent.name]);
        Album a = Album.fromMap(data3[0]);
        value = {
          'album_id': a.id,
          'photo_id': photo.id
        }; //if album already exists then insert into albumphoto
        db.insert("AlbumPhoto", value);
        isAlbuminserted = true;
      } else {
        int event_id = await db.insert("Event", elist[i].toMap());
        var value = {'photo_id': photo.id, 'event_id': event_id};
        db.insert("PhotoEvent", value);
        Album a = Album();
        a.title = elist[i].name;
        a.cover_photo = photo.path;
        int a_id = await db.insert("Album", a.toMap()); //inserting into album
        value = {'album_id': a_id, 'photo_id': photo.id};
        db.insert("AlbumPhoto", value);
        isAlbuminserted = true;
      }
    }
    if (isAlbuminserted) {
      await db.delete('AlbumPhoto',
          where: 'album_id = ? AND photo_id=?', whereArgs: [1, photo.id]);
    }
  }

  Future<List<Photo>> getAllPhotoHavingLatLng() async {
    Database db = await instance.database;
    List<Photo> plist = [];
    String query = "SELECT * FROM Photo WHERE lat IS NOT NULL;";
    List<Map<String, dynamic>> data = await db.rawQuery(query);
    for (int i = 0; i < data.length; i++) {
      plist.add(Photo.fromMap(data[i]));
    }
    return plist;
  }

  Future<String> getCityFromLatLong(double lat, double lon) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
    if (placemarks != null && placemarks.isNotEmpty) {
      return placemarks[0].locality!;
    } else {
      return "incorrect coordinates";
    }
  }

  Future<Photo> getLastInsertedPhoto() async {
    Database db = await instance.database;
    String query = "SELECT * FROM Photo ORDER BY id DESC LIMIT 1;";
    List<Map<String, dynamic>> photo_data = await db.rawQuery(query);
    Photo p = Photo.fromMap(photo_data[0]);
    return p;
  }

  //NEW . . . . . . . . .
  Future<int> insertPerson(Person p) async {
    Database db = await instance.database;
    int id = await db.insert("Person", p.toMap());
    return id;
  }

  Future<int> insertPhotoPerson(int personId, int photoId) async {
    Database db = await instance.database;
    var value = {'photo_id': photoId, 'person_id': personId};
    int id = await db.insert("PhotoPerson", value);
    return id;
  }

  Future<int> UpdatePerson(Person p) async {
    Database db = await instance.database;
    int affectedRows =
        await db.update("Person", p.toMap(), //updating name of a person
            where: "id=?",
            whereArgs: [p.id]);
    return affectedRows;
  }

  Future<String> updateIsSyncedTo1() async {
    Database db = await instance.database;
    String query = "update photo set isSynced = 1";
    await db.rawUpdate(query);
    return "updated";
  }

  Future<int> insertEvent(Event e) async {
    Database db = await instance.database;
    int id = await db.insert("Event", e.toMap());
    return id;
  }

  Future<int> insertPhotoEvent(int eventId, int photoId) async {
    Database db = await instance.database;
    var value = {'photo_id': photoId, 'event_id': eventId};
    int id = await db.insert("PhotoEvent", value);
    return id;
  }

  Future<int> UpdateEvent(Event e) async {
    Database db = await instance.database;
    int affectedRows =
        await db.update("Event", e.toMap(), //updating name of a person
            where: "id=?",
            whereArgs: [e.id]);
    return affectedRows;
  }

  Future<Photo> getFirstPhotoOfPersonById(int personId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> res = await db.query('PhotoPerson',
        columns: ['photo_id'],
        where: 'person_id=?',
        whereArgs: [personId],
        limit: 1);
    int photoId = int.parse(res[0]["photo_id"].toString());
    Photo p = await getPhotoById(photoId);
    return p;
  }

  Future<Photo> getFirstPhotoOfEventById(int eventId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> res = await db.query('PhotoEvent',
        columns: ['photo_id'],
        where: 'event_id=?',
        whereArgs: [eventId],
        limit: 1);
    int photoId = int.parse(res[0]["photo_id"].toString());
    Photo p = await getPhotoById(photoId);
    return p;
  }

  Future<List<Map<String, dynamic>>> getDistinctLocationAndTheirPhotos() async {
    List<String> places = [];
    List<Photo> plist = await getAllPhotoHavingLatLng();
    List<Map<String, dynamic>> locationPhotoMap = [];
    for (int i = 0; i < plist.length; i++) {
      String p = await getCityFromLatLong(plist[i].lat!, plist[i].lng!);
      if (!places.contains(p)) {
        Map<String, dynamic> map = Map();
        map[p] = plist[i];
        locationPhotoMap.add(map);
        places.add(p); //do mot add repeated places
      }
    }
    return locationPhotoMap;
  }

  Future<List<Photo>> getDistinctLabelPhotos() async {
    Database db = await instance.database;
    List<Photo> plist = [];
    String query = "SELECT DISTINCT label FROM photo WHERE label IS NOT NULL;";
    List<Map<String, dynamic>> data = await db.rawQuery(query);
    List<String> labels = [];
    for (int i = 0; i < data.length; i++) {
      labels.add(data[i]["label"]);
    }
    for (int i = 0; i < labels.length; i++) {
      data = await db.query('photo',
          where: 'label=?', whereArgs: [labels[i]], limit: 1);
      plist.add(Photo.fromMap(data[0]));
    }
    return plist;
  }

  Future<List<Photo>> getDistinctDatesPhotos() async {
    Database db = await instance.database;
    List<Photo> plist = [];
    String query =
        "SELECT DISTINCT SUBSTR(date_taken, 1, 10) AS distinct_date FROM photo;";
    List<Map<String, dynamic>> distict_dates = await db.rawQuery(query);
    List<Map<String, dynamic>> sortedDates =
        List<Map<String, dynamic>>.from(distict_dates);

// Sorting the new list by date values in ascending order
    sortedDates
        .sort((a, b) => b["distinct_date"].compareTo(a["distinct_date"]));
    for (int i = 0; i < sortedDates.length; i++) {
      String query =
          "SELECT * from photo where SUBSTR(date_taken, 1, 10) like '${sortedDates[i]["distinct_date"]}' limit 1;";
      List<Map<String, dynamic>> data1 = await db.rawQuery(query);
      if (data1.length >= 1) {
        plist.add(Photo.fromMap(data1[0]));
      }
    }
    return plist;
  }

  Future<List<Photo>> getPhotosofPersonById(int personId) async {
    Database db = await instance.database;
    List<Photo> plist = [];
    String query =
        "SELECT * from photo inner join photoperson on photo.id = photoperson.photo_id where photoperson.person_id=${personId} ;";
    List<Map<String, dynamic>> personsPhotos = await db.rawQuery(query);
    for (int i = 0; i < personsPhotos.length; i++) {
      plist.add(Photo.fromMap(personsPhotos[i]));
    }
    return plist;
  }

  Future<List<Photo>> getPhotosofUnknownPersons() async {
    Database db = await instance.database;
    List<Photo> plist = [];
    // String query =
    //     "SELECT p.* FROM Person p JOIN PhotoPerson pp ON p.id = pp.person_id JOIN Photo ph ON pp.photo_id = ph.id WHERE  SUBSTR(p.name, 1, INSTR(p.name, '_') - 1) LIKE '%unknown%';";
    String query =
        "Select ph.* From Photo ph Join PhotoPerson pp ON ph.id = pp.photo_id JOIN Person p on pp.person_id=p.id WHERE SUBSTR(p.name, 1, INSTR(p.name, '_') - 1) LIKE '%unknown%';";
    List<Map<String, dynamic>> personsPhotos = await db.rawQuery(query);
    for (int i = 0; i < personsPhotos.length; i++) {
      if (plist.length == 0) {
        plist.add(Photo.fromMap(personsPhotos[i]));
      } else if (!plist.any((element) =>
          element.id == int.parse(personsPhotos[i]["id"].toString()))) {
        plist.add(Photo.fromMap(personsPhotos[i]));
      }
    }
    return plist;
  }

  Future<List<Photo>> getPhotosofEventById(int eventId) async {
    Database db = await instance.database;
    List<Photo> plist = [];
    String query =
        "SELECT * from photo inner join photoevent on photo.id = photoevent.photo_id where photoevent.event_id=${eventId} ;";
    List<Map<String, dynamic>> personsPhotos = await db.rawQuery(query);
    for (int i = 0; i < personsPhotos.length; i++) {
      plist.add(Photo.fromMap(personsPhotos[i]));
    }
    return plist;
  }

  Future<List<Photo>> getPhotosofDateByPhotoId(int id) async {
    Database db = await instance.database;
    List<Photo> plist = [];
    List<Map<String, dynamic>> datePhotoData =
        await db.query('Photo', where: 'id=?', whereArgs: [id]);
    Photo datePhoto = Photo.fromMap(datePhotoData[0]);
    String query =
        "SELECT * from photo where SUBSTR(date_taken, 1, 10) like '${datePhoto.date_taken!.split(" ")[0]}';";
    List<Map<String, dynamic>> datePhotosData = await db.rawQuery(query);
    for (int i = 0; i < datePhotosData.length; i++) {
      plist.add(Photo.fromMap(datePhotosData[i]));
    }
    return plist;
  }

  Future<List<Photo>> getPhotosofLabelByTitle(String label) async {
    Database db = await instance.database;
    List<Photo> plist = [];
    List<Map<String, dynamic>> labelPhotos =
        await db.query('Photo', where: 'label=?', whereArgs: [label]);
    for (int i = 0; i < labelPhotos.length; i++) {
      plist.add(Photo.fromMap(labelPhotos[i]));
    }
    return plist;
  }

  Future<List<Photo>> getPhotosofLocationByTitle(String location) async {
    List<String> places = [];
    List<Photo> photosList = [];
    List<Photo> plist = await getAllPhotoHavingLatLng();
    for (int i = 0; i < plist.length; i++) {
      String p = await getCityFromLatLong(plist[i].lat!, plist[i].lng!);
      if (p == location) {
        photosList.add(plist[i]);
      }
    }
    return photosList;
  }

  Future<int> deletePhotoEvent(int eventId, int photoId) async {
    Database db = await instance.database;
    int affectedRows = await db.delete('PhotoEvent',
        where: 'photo_id=? AND event_id=?', whereArgs: [photoId, eventId]);
    return affectedRows;
  }

  Future<int> getPhotoEventCountbyEventId(int event_id) async {
    Database db = await instance.database;
    String query =
        'SELECT COUNT(*) AS event_count FROM photoEvent WHERE event_id = ${event_id};';
    List<Map<String, dynamic>> data = await db.rawQuery(query);
    return int.parse(data[0]["event_count"].toString());
  }

  Future<int> getPhotoPersonCountbyPersonId(int person_id) async {
    Database db = await instance.database;
    String query =
        'SELECT COUNT(*) AS person_count FROM photoPerson WHERE person_id = ${person_id};';
    List<Map<String, dynamic>> data = await db.rawQuery(query);
    return int.parse(data[0]["person_count"].toString());
  }

  Future<int> deleteEventbyId(int id) async {
    Database db = await instance.database;
    int affectedRows = await db.delete('Event', where: 'id=?', whereArgs: [id]);
    return affectedRows;
  }

  Future<int> deletePhotobyId(int id) async {
    Database db = await instance.database;
    int affectedRows = await db.delete('Photo', where: 'id=?', whereArgs: [id]);
    return affectedRows;
  }

  Future<int> deletePersonbyId(int id) async {
    Database db = await instance.database;
    int affectedRows =
        await db.delete('Person', where: 'id=?', whereArgs: [id]);
    return affectedRows;
  }

  Future<int> deletePhotoEventByPhotoId(int photoId) async {
    Database db = await instance.database;
    int affectedRows = await db
        .delete('PhotoEvent', where: 'photo_id=?', whereArgs: [photoId]);
    return affectedRows;
  }

  Future<int> deletePhotoPersonByPhotoId(int photoId) async {
    Database db = await instance.database;
    int affectedRows = await db
        .delete('PhotoPerson', where: 'photo_id=?', whereArgs: [photoId]);
    return affectedRows;
  }

  // Future<int> getPhotoPersonCountbyPersonId(int person_id) async {
  //   Database db = await instance.database;
  //   String query =
  //       'SELECT COUNT(*) AS person_count FROM photoPerson WHERE person_id = ${person_id};';
  //   List<Map<String, dynamic>> data = await db.rawQuery(query);
  //   return int.parse(data[0]["person_count"].toString());
  // }

  Future<List<Person>> getAllPersonsByPhotoId(int pid) async {
    Database db = await instance.database;
    List<Person> plist = [];
    String query =
        "SELECT * from person inner join photoperson on person.id = photoperson.person_id where photoperson.photo_id=${pid} ;";
    List<Map<String, dynamic>> data = await db.rawQuery(query);
    for (int i = 0; i < data.length; i++) {
      plist.add(Person.fromMap(data[i]));
    }
    return plist;
  }

  Future<List<Event>> getAllEventsByPhotoId(int pid) async {
    Database db = await instance.database;
    List<Event> elist = [];
    String query =
        "SELECT * from event inner join photoevent on event.id = photoevent.event_id where photoevent.photo_id=${pid} ;";
    List<Map<String, dynamic>> data = await db.rawQuery(query);
    for (int i = 0; i < data.length; i++) {
      elist.add(Event.fromMap(data[i]));
    }
    return elist;
  }

////////////////          Functions For Searching             ///////////////////
  Future<List<Photo>> getPhotosofPersons(List<Person> personsList) async {
    Database db = await instance.database;
    List<Photo> plist = [];
    // Build the query based on the input names
    // String query = '''
    //   SELECT * FROM Photo
    //   INNER JOIN photoperson ON Photo.id= photoperson.photo_id
    //   WHERE photoperson.person_id IN (${personsList.map((n) => "'${n.id}'").join(',')})
    // ''';

    String query = '''
    SELECT *
    FROM Photo
    INNER JOIN photoperson ON Photo.id= photoperson.photo_id 
    WHERE 1=1 ${personsList.map((n) => 'AND photoperson.person_id = ${n.id}').join()}
''';
    List<Map<String, dynamic>> personsPhotos = await db.rawQuery(query);
    for (int i = 0; i < personsPhotos.length; i++) {
      plist.add(Photo.fromMap(personsPhotos[i]));
    }
    return plist;
  }

  Future<List<Photo>> getPhotosofEvents(List<Event> eventsList) async {
    Database db = await instance.database;
    List<Photo> plist = [];
    // Build the query based on the input names
    String query = '''
      SELECT * FROM Photo
      INNER JOIN photoevent ON Photo.id= photoevent.photo_id 
      WHERE photoevent.event_id IN (${eventsList.map((n) => "'${n.id}'").join(',')})
    ''';
    List<Map<String, dynamic>> eventsPhotos = await db.rawQuery(query);
    for (int i = 0; i < eventsPhotos.length; i++) {
      plist.add(Photo.fromMap(eventsPhotos[i]));
    }
    return plist;
  }

  Future<List<Photo>> getPhotosofLabels(List<String> labelsList) async {
    Database db = await instance.database;
    List<Photo> plist = [];
    // Build the query based on the input names
    String query = '''
      SELECT * FROM Photo where label IN (${labelsList.map((n) => "'n'").join(',')})
    ''';
    List<Map<String, dynamic>> labelsPhotos = await db.rawQuery(query);
    for (int i = 0; i < labelsPhotos.length; i++) {
      plist.add(Photo.fromMap(labelsPhotos[i]));
    }
    return plist;
  }

  Future<List<Photo>> getPhotosofDate(String date) async {
    Database db = await instance.database;
    List<Photo> plist = [];
    // Build the query based on the input names
    String query = '''
      SELECT * FROM Photo where SUBSTR(date_taken, 1, 10) like $date
    ''';
    List<Map<String, dynamic>> datePhotos = await db.rawQuery(query);
    for (int i = 0; i < datePhotos.length; i++) {
      plist.add(Photo.fromMap(datePhotos[i]));
    }
    return plist;
  }

  Future<List<Photo>> getPhotosofLocation(List<String> locationList) async {
    List<String> places = [];
    List<Photo> photosList = [];
    List<Photo> plist = await getAllPhotoHavingLatLng();
    for (int i = 0; i < plist.length; i++) {
      String p = await getCityFromLatLong(plist[i].lat!, plist[i].lng!);
      if (locationList.contains(p)) {
        photosList.add(plist[i]);
      }
    }
    return photosList;
  }
}
