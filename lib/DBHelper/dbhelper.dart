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
          Insert into photo(title, path) values
          ("image1","assets/images/amna-1.jpeg"),
          ("image2","assets/images/amna-2.jpg"),
          ("image3","assets/images/amna-3.jpg"),
          ("image4","assets/images/amna-alesha.jpg"),
          ("image5","assets/images/amna-hassan-1.jpeg"),
          ("image6","assets/images/amna-hassan-2.jpg"),
          ("image7","assets/images/amna-hassan-3.jpg"),
          ("image8","assets/images/amna-saman.jpeg"),
          ("image9","assets/images/amna-siqlain-mama-papa.jpg"),
          ("image0","assets/images/hassan-1.jpeg"),
          ("image10","assets/images/hassan-2.jpg"),
          ("image11","assets/images/hassan-siqlain-mama-papa.jpg")
''';
    db.rawInsert(query);
    print("Inserted into picture's table");

    query = '''
          Insert into Album(title, cover_photo) values
           ("others","assets/images/amna-2.jpg")
         
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
         (1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,7),(1,8),(1,9),(1,10),(1,11)
          
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
    //not completed
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
    db.update("Photo", p.toMap(), where: "id=?", whereArgs: [p.id]);
    print("Photo Table updated succesfully");
  }

  Future<void> inserteditPersonbyid(int id, List<Person> plist) async {
    Database db = await instance.database;
    List<int> person_ids = [];
    List<Map<String, dynamic>> data =
        await db.query("PhotoPerson", where: "photo_id=?", whereArgs: [id]);
    for (int i = 0; i < data.length; i++) {
      person_ids.add(data[i]["person_id"]);
    }
    for (int i = 0; i < plist.length; i++) {
      bool ispresent = false;
      for (int j = 0; j < person_ids.length; j++) {
        if (plist[i].id == person_ids[j]) {
          ispresent = true;
        }
      }
      if (ispresent) {
        db.update("Person", plist[i].toMap(),
            where: "id=?", whereArgs: [plist[i].id]);
      } else {
        int person_id = await db.insert("Person", plist[i].toMap());
        var value = {'photo_id': id, 'person_id': person_id};
        db.insert("PhotoPerson", value);
      }
    }
  }

  Future<void> inserteditEventbyid(int id, List<Event> elist) async {
    Database db = await instance.database;
    List<int> event_ids = [];
    List<Map<String, dynamic>> data =
        await db.query("PhotoEvent", where: "photo_id=?", whereArgs: [id]);
    for (int i = 0; i < data.length; i++) {
      event_ids.add(data[i]["event_id"]);
    }
    for (int i = 0; i < elist.length; i++) {
      bool ispresent = false;
      for (int j = 0; j < event_ids.length; j++) {
        if (elist[i].id == event_ids[j]) {
          ispresent = true;
        }
      }
      if (ispresent) {
        db.update("Event", elist[i].toMap(),
            where: "id=?", whereArgs: [elist[i].id]);
      } else {
        int event_id = await db.insert("Event", elist[i].toMap());
        var value = {'photo_id': id, 'event_id': event_id};
        db.insert("PhotoEvent", value);
      }
    }
  }
}
