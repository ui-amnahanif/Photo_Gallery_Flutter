import 'package:flutter/material.dart';
import 'package:photo_gallery/Models/person.dart';
import 'package:photo_gallery/Models/event.dart';
import 'package:photo_gallery/Utilities/CustomWdigets/customtext.dart';
import 'package:photo_gallery/Utilities/Global/global.dart';
import '../DBHelper/dbhelper.dart';
import '../Models/photo.dart';

class viewDetailsScreen extends StatefulWidget {
  int photo_id;
  viewDetailsScreen(this.photo_id);

  @override
  State<viewDetailsScreen> createState() => _viewDetailsScreenState();
}

class _viewDetailsScreenState extends State<viewDetailsScreen> {
  Photo photo = Photo();
  List<Person> plist = [];
  List<Event> elist = [];
  String persons = "";
  String events = "";
  String? location;
  double? width;
  double? height;
  @override
  void initState() {
    // TODO: implement initState
    getPhotoDetails();
  }

  getPhotoDetails() async {
    photo = await DbHelper.instance.getPhotoById(widget.photo_id);
    plist = await DbHelper.instance.getPersonDetailsByPhotoId(widget.photo_id);
    elist = await DbHelper.instance.getEventDetailsByPhotoId(widget.photo_id);
    for (int i = 0; i < plist.length; i++) {
      persons = "$persons ${plist[i].name} , ";
    }
    for (int i = 0; i < elist.length; i++) {
      events = "$events ${elist[i].name} , ";
    }
    if (photo.lat != null) {
      location =
          await DbHelper.instance.getCityFromLatLong(photo.lat!, photo.lng!);
    }

    setState(() {});
  }

  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
        backgroundColor: primaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
              photo.title != null ? "Title : ${photo.title}" : "Title : none",
              15,
              null,
              FontWeight.w400,
              0.1),
          CustomText(persons != "" ? "Persons : ${persons}" : "Persons : none",
              15, null, FontWeight.w400, 0.1),
          CustomText(events != "" ? "Events : ${events}" : "Events : none", 15,
              null, FontWeight.w400, 0.1),
          CustomText(
              photo.label != null ? "Label : ${photo.label}" : "Label : none",
              15,
              null,
              FontWeight.w400,
              0.1),
          CustomText(
              location != null ? "Location : $location" : "Location : none",
              15,
              null,
              FontWeight.w400,
              0.1),
          CustomText(
              photo.date_taken != null
                  ? "Date taken : ${photo.date_taken}"
                  : "Date taken : none",
              15,
              null,
              FontWeight.w400,
              0.1),

          // CustomText(
          //     photo.last_modified_date != null
          //         ? "Last modified date : ${photo.last_modified_date}"
          //         : "Last modified date : none",
          //     15,
          //     null,
          //     FontWeight.w400,
          //     0.1),
        ],
      ),
    );
  }
}
