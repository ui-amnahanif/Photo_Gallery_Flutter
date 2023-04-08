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
                      last_modified_date text
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
    print("DB CREATED");
    query = '''
          Insert into photo(title, path,date_taken) values
          ("image1","assets/images/amna-1.jpeg","2023:02:21 14:57:20"),
          ("IMG-20210703-WA0091.jpg","assets/images/IMG-20210703-WA0091.jpg","2021:02:21 14:57:20"),
          ("image3","assets/images/amna-3.jpg","2022:02:21 14:57:20"),
          ("image4","assets/images/amna-alesha.jpg","2020:02:21 14:57:20"),
          ("image5","assets/images/amna-hassan-1.jpeg","2023:02:21 14:57:20"),
          ("image6","assets/images/amna-hassan-2.jpg","2023:02:21 14:57:20"),
          ("image7","assets/images/amna-hassan-3.jpg","2023:02:21 14:57:20"),
          ("image8","assets/images/amna-saman.jpeg","2023:02:21 14:57:20"),
          ("image9","assets/images/amna-siqlain-mama-papa.jpg","2022:02:21 14:57:20"),
          ("image10","assets/images/hassan-1.jpeg","2023:02:21 14:57:20"),
          ("WhatsAppImage2023-03-20at5.21.41AM","assets/images/WhatsAppImage2023-03-20at5.21.41AM.jpeg","2022:02:21 14:57:20"),
          ("IMG-20210704-WA0002","assets/images/IMG-20210704-WA0002.jpg","2021:02:21 14:57:20"),
          ("IMG-20210704-WA0003","assets/images/IMG-20210704-WA0003.jpg","2021:02:21 14:57:20"),
          ("WhatsAppImage2023-03-20at5.22.24AM","assets/images/WhatsAppImage2023-03-20at5.22.24AM.jpeg","2022:02:21 14:57:20")
      
''';
    db.rawInsert(query);
    print("Inserted into picture's table");

    query = '''
          Insert into Album(title, cover_photo) values
           ("others","assets/images/amna-siqlain-mama-papa.jpg")
         
''';
    // ("Amna","assets/images/amna-2.jpg"),
    // ("Hassan","assets/images/hassan-1.jpeg"),
    // ("Saman","assets/images/amna-saman.jpeg"),
    // ("Alesha","assets/images/amna-alesha.jpg"),
    // ("Siqlain","assets/images/amna-siqlain-mama-papa.jpg"),
    // ("Mama","assets/images/amna-siqlain-mama-papa.jpg"),
    // ("Papa","assets/images/amna-siqlain-mama-papa.jpg")
    db.rawInsert(query);
    print("Inserted into albumPhoto table");

    query = '''
          Insert into AlbumPhoto(album_id, photo_id) values
         (1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,7),(1,8),(1,9),(1,10),(1,11),(1,12),(1,13),(1,14)
          
''';
    // (1,"1111"),(1,"2222"),(1,"3333"),(1,"4444"),(1,"5555"),(1,"6666"),(1,"7777"),(1,"8888"),(1,"9999"),
    // (2,"5555"),(2,"6666"),(2,"7777"),(2,"0000"),(2,"0111"),(2,"0222"),
    // (3,"8888"),
    // (4,"4444"),
    // (5,"9999"),(5,"0222"),
    // (6,"9999"),(6,"0222"),
    // (7,"9999"),(7,"0222")
    db.rawInsert(query);
    print("Inserted into ALBUMPHOTO table");
  }

  Future<int> insertPhoto(Photo p) async {
    Database db = await instance.database;
    int r = await db.insert("photo", p.toMap());
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
        await db.query("Photo", columns: ['label']);
    for (int i = 0; i < data1.length; i++) {
      if (data1[i]["label"] != null) {
        label_list.add(data1[i]["label"].toString());
      }
    }
    return label_list;
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
    //not completed.............................................
    Database db = await instance.database;
    List<Map<String, dynamic>> data =
        await db.query("Photo", columns: ["label"]);
    List<String> labels = [];
    for (int i = 0; i < data.length; i++) {
      if (data[i]["label"] != null) {
        labels.add(data[i]["label"]);
      }
    }
    List<Album> album_list = [];
    for (int i = 0; i < labels.length; i++) {
      List<Map<String, dynamic>> data =
          await db.query("Album", where: 'title=?', whereArgs: [labels[i]]);
      album_list.add(Album.fromMap(data[0]));
    }
    return album_list;
  }

  Future<List<Photo>> getPhotosOfAlbum(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> data =
        await db.query("AlbumPhoto", where: "album_id=?", whereArgs: [id]);
    List<int> photo_ids = [];
    List<Photo> photo_list = [];
    for (int i = 0; i < data.length; i++) {
      photo_ids.add(data[i]["photo_id"]);
    }

    for (int i = 0; i < photo_ids.length; i++) {
      data = await db.query("Photo", where: "id=?", whereArgs: [photo_ids[i]]);
      photo_list.add(Photo.fromMap(data[0]));
    }

    print("data length ${photo_ids}");
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
        Album a = Album();
        a.title = p.label!;
        a.cover_photo = p.path;
        int a_id = await db.insert("Album", a.toMap()); //inserting into album
        var value = {'album_id': a_id, 'photo_id': p.id};
        db.insert("AlbumPhoto", value);
      } else {
        db.update("Photo", p.toMap(), where: "id=?", whereArgs: [p.id]);
        Album a = Album();
        a.title = p.label!;
        db.update("Album", a.toMap(),
            where: "title=?", whereArgs: [existingPhotoData.label]);
      }
    } else {
      db.update("Photo", p.toMap(), where: "id=?", whereArgs: [p.id]);
    }
    print("Photo Table updated succesfully");
  }

  Future<void> inserteditPersonAndAlbumbyid(
      Photo photo, List<Person> plist, int album_id) async {
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
        db.update("Album", plist[i].toMap(), //edit album name
            where: "id=?",
            whereArgs: [album_id]);
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
    if (isAlbuminserted) {
      await db.delete('AlbumPhoto',
          where: 'album_id = ? AND photo_id=?', whereArgs: [1, photo.id]);
    }
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
}
