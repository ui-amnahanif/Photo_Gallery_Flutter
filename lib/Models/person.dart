import 'dart:convert';

import 'package:photo_gallery/DBHelper/dbhelper.dart';
import 'package:photo_gallery/Utilities/Global/global.dart';
import 'package:http/http.dart' as http;

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

  static void insertPersons(List<Person> persons, int photoId) async {
    //get all persons from db
    List<Person> plist = await DbHelper.instance.getAllPersons();
    bool isPersonPresent = false;
    int presentPersonId = -1;
    //loop through every person
    for (int i = 0; i < persons.length; i++) {
      //loop through every persons that are in db
      for (int j = 0; j < plist.length; j++) {
        if (persons[i].name == plist[j].name) {
          isPersonPresent = true;
          presentPersonId = plist[j].id!;
        }
      }
      //if person is not present in db
      if (!isPersonPresent) {
        //insert into person table
        int personId = await DbHelper.instance.insertPerson(persons[i]);
        //insert into phtotperson table
        int id = await DbHelper.instance.insertPhotoPerson(personId, photoId);
        print("New person added");
      } else {
        //else insert into photoperson
        int id =
            await DbHelper.instance.insertPhotoPerson(presentPersonId, photoId);
        print("person already present");
      }
    }
  }

  static Future<void> updatePersons(List<Person> plist) async {
    for (int i = 0; i < plist.length; i++) {
      await DbHelper.instance.UpdatePerson(plist[i]);
    }
  }

  static updatePersonFromApi(List<String> oldList, List<String> newList) async {
    Map<String, dynamic> dataToSend = Map<String, dynamic>();
    dataToSend["old_names"] = oldList;
    dataToSend["new_names"] = newList;
    String url = '${ip}/updateName';
    Uri uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(dataToSend),
        headers: <String, String>{'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return "names updated";
    } else {
      return "names not updated";
    }
  }
}
