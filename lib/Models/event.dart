import '../DBHelper/dbhelper.dart';

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
  static Future<void> insertEvents(List<Event> events, int photoId) async {
    //get all event from db
    List<Event> elist = await DbHelper.instance.getAllEvents();
    bool isEventPresent = false;
    int presentEventId = -1;
    //loop through every event
    for (int i = 0; i < events.length; i++) {
      //loop through every event that are in db
      for (int j = 0; j < elist.length; j++) {
        if (events[i].name == elist[j].name) {
          isEventPresent = true;
          presentEventId = elist[j].id!;
        }
      }
      //if event is not present in db
      if (!isEventPresent) {
        //insert into event table
        int eventId = await DbHelper.instance.insertEvent(events[i]);
        //insert into photoEvent table
        int id = await DbHelper.instance.insertPhotoEvent(eventId, photoId);
        print("New event added");
      } else {
        //else insert into photoEvent
        int id =
            await DbHelper.instance.insertPhotoEvent(presentEventId, photoId);
        print("Event already present");
      }
    }
  }

  static Future<void> updateEvents(List<Event> elist) async {
    for (int i = 0; i < elist.length; i++) {
      await DbHelper.instance.UpdateEvent(elist[i]);
    }
  }

  static Future<void> deleteEvent(int eventId, int photoId) async {
    int affectedRows =
        await DbHelper.instance.deletePhotoEvent(eventId, photoId);
    int photoEventCount =
        await DbHelper.instance.getPhotoEventCountbyEventId(eventId);
    if (photoEventCount == 0) {
      int affectedRows = await DbHelper.instance.deleteEventbyId(eventId);
    }
  }
}
