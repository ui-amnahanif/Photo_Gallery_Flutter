import 'package:flutter/material.dart';
import 'package:photo_gallery/Models/event.dart';
import 'package:photo_gallery/Models/person.dart';
import 'package:photo_gallery/Models/photo.dart';
import 'package:photo_gallery/Utilities/CustomWdigets/custombutton.dart';
import 'package:photo_gallery/Utilities/CustomWdigets/customtext.dart';
import 'package:photo_gallery/Utilities/CustomWdigets/customtextformfield.dart';
import 'package:photo_gallery/Utilities/Global/global.dart';

import '../DBHelper/dbhelper.dart';

class AddEditDetailsScreen extends StatefulWidget {
  int photo_id;
  int album_id;
  AddEditDetailsScreen(this.photo_id, this.album_id);

  @override
  State<AddEditDetailsScreen> createState() => _AddEditDetailsScreenState();
}

class _AddEditDetailsScreenState extends State<AddEditDetailsScreen> {
  Photo photo = Photo();
  List<Person> plist = [];
  List<Event> elist = [];
  String? location;
  double? width;
  double? height;
  int peopleeditIndex = -1;
  int eventeditIndex = -1;
  late TextEditingController peopleController = TextEditingController();
  late TextEditingController eventController = TextEditingController();
  late TextEditingController locationController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    getPeopleEventDetails();
  }

  getPeopleEventDetails() async {
    photo = await DbHelper.instance.getPhotoById(widget.photo_id);
    plist = await DbHelper.instance.getPersonDetailsByPhotoId(widget.photo_id);
    elist = await DbHelper.instance.getEventDetailsByPhotoId(widget.photo_id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Add/Edit Details"),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Expanded(
          child: Column(
            children: [
              CustomText("People", 10, null, FontWeight.w500, 0.1),
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      height! * 0.052,
                      width! * 0.75,
                      "",
                      peopleController,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (peopleeditIndex != -1 &&
                          peopleController.text != "") {
                        plist[peopleeditIndex].name = peopleController.text;
                        peopleController.text = "";
                        setState(() {});
                      }
                      if (peopleController.text != "" &&
                          peopleeditIndex == -1) {
                        Person p = Person();
                        p.name = peopleController.text;
                        plist.add(p);
                        peopleController.text = "";
                        setState(() {});
                      }
                    },
                    child: Icon(Icons.add),
                    style:
                        TextButton.styleFrom(primary: primaryColor // Text Color
                            ),
                  )
                ],
              ),
              plist.length >= 1
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: plist.length,
                      itemBuilder: (context, ind) {
                        return ListTile(
                          title: CustomText(
                              plist[ind].name, 0, 0, FontWeight.w400, 0),
                          trailing: Wrap(
                            spacing: -15, // space between two icons
                            children: [
                              IconButton(
                                onPressed: () {
                                  peopleController.text = plist[ind].name;
                                  peopleeditIndex = ind;
                                  setState(() {});
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: primaryColor,
                                ),
                              ), // icon-1
                              IconButton(
                                onPressed: () {
                                  plist.removeAt(ind);
                                  setState(() {});
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: primaryColor,
                                ),
                              ), // icon-2
                            ],
                          ),
                        );
                      })
                  : CustomText("no person", 10, null, FontWeight.w400, 0.1),
              CustomText("Event", 10, null, FontWeight.w500, 0.1),
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      height! * 0.052,
                      width! * 0.75,
                      "",
                      eventController,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (eventeditIndex != -1 && eventController.text != "") {
                        elist[eventeditIndex].name = eventController.text;
                        eventController.text = "";
                        setState(() {});
                      }
                      if (eventController.text != "" && eventeditIndex == -1) {
                        Event e = Event();
                        e.name = eventController.text;
                        elist.add(e);
                        eventController.text = "";
                        setState(() {});
                      }
                    },
                    child: Icon(Icons.add),
                    style:
                        TextButton.styleFrom(primary: primaryColor // Text Color
                            ),
                  )
                ],
              ),
              elist.length >= 1
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: elist.length,
                      itemBuilder: (context, ind) {
                        return ListTile(
                          title: CustomText(
                              elist[ind].name, 0, 0, FontWeight.w400, 0),
                          trailing: Wrap(
                            spacing: -15, // space between two icons
                            children: [
                              IconButton(
                                onPressed: () {
                                  eventController.text = elist[ind].name;
                                  eventeditIndex = ind;
                                  setState(() {});
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: primaryColor,
                                ),
                              ), // icon-1
                              IconButton(
                                onPressed: () {
                                  elist.removeAt(ind);
                                  setState(() {});
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: primaryColor,
                                ),
                              ), // icon-2
                            ],
                          ),
                        );
                      })
                  : CustomText("no event", 10, null, FontWeight.w400, 0.1),
              CustomText("Location", 10, null, FontWeight.w500, 0.1),
              Align(
                alignment: Alignment(-0.6, 0.0),
                child: CustomTextFormField(
                  height! * 0.052,
                  width! * 0.75,
                  "",
                  locationController,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              CustomButton("Add/Edit", 30, 150, primaryColor, primaryColor,
                  Colors.white, addeditfunction)
            ],
          ),
        ),
      ),
    );
  }

  addeditfunction() async {
    //location pe kaam krna hai
    await DbHelper.instance.editPhotobyid(photo);
    await DbHelper.instance
        .inserteditPersonAndAlbumbyid(photo, plist, widget.album_id);
    await DbHelper.instance.inserteditEventbyid(photo, elist, widget.album_id);
    setState(() {});
  }
}

// import 'package:flutter/material.dart';
// import 'package:photo_gallery/Models/person.dart';
// import 'package:photo_gallery/Utilities/CustomWdigets/custombutton.dart';
// import 'package:photo_gallery/Utilities/CustomWdigets/customtext.dart';
// import 'package:photo_gallery/Utilities/CustomWdigets/customtextformfield.dart';
// import 'package:photo_gallery/Utilities/Global/global.dart';
// import '../DBHelper/dbhelper.dart';
// import '../Models/event.dart';
// import '../Models/photo.dart';

// class AddEditDetailsScreen extends StatefulWidget {
//   int photo_id;
//   AddEditDetailsScreen(this.photo_id);

//   @override
//   State<AddEditDetailsScreen> createState() => _AddEditDetailsScreenState();
// }

// class _AddEditDetailsScreenState extends State<AddEditDetailsScreen> {
//   Photo photo = Photo();
//   List<Person> plist = [];
//   List<Event> elist = [];
//   String? location;
//   double? width;
//   do,uble? height;
//   late List<TextEditingController> peopleControllers;
//   late List<TextEditingController> eventControllers;
//   late TextEditingController locationController;
//   int length = 4;
//   void initState() {
//     super.initState();
//     getPhotoDetails();
//   }

//   getPhotoDetails() async {
//     photo = await DbHelper.instance.getPhotoById(widget.photo_id);
//     plist = await DbHelper.instance.getPersonDetailsByPhotoId(widget.photo_id);
//     elist = await DbHelper.instance.getEventDetailsByPhotoId(widget.photo_id);
//     setState(() {});
//   }

//   addeditfunction() async {
//     for (int i = 0; i < peopleControllers.length; i++) {
//       plist[i].name = peopleControllers[i].text;
//     }
//     // for (int i = 0; i < peopleControllers.length; i++) {
//     //   Person p = Person();
//     //   p.name = peopleControllers[i].text;
//     //   plist.add(p);
//     // }
//     print(plist.length);
//     for (int i = 0; i < eventControllers.length; i++) {
//       Event e = Event();
//       e.name = eventControllers[i].text;
//       elist.add(e);
//     }
//     print(elist.length);
//     await DbHelper.instance.editPhotobyid(photo);
//     await DbHelper.instance.inserteditPersonbyid(widget.photo_id, plist);
//     await DbHelper.instance.inserteditEventbyid(widget.photo_id, elist);
//   }

//   @override
//   Widget build(BuildContext context) {
//     peopleControllers = List.generate(
//         plist.length,
//         (i) => TextEditingController(
//             text: i + 1 > peopleControllers.length
//                 ? ""
//                 : peopleControllers.length == 0
//                     ? ""
//                     : peopleControllers[i].text));

//     eventControllers = List.generate(
//         elist.length, (i) => TextEditingController(text: elist[i].name));

//     locationController = TextEditingController(text: location);
//     height = MediaQuery.of(context).size.height;
//     width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Add/Edit Details"),
//         backgroundColor: primaryColor,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 CustomText("People", 10, null, FontWeight.w500, 0.1),
//                 TextButton(
//                   onPressed: () {
//                     Person p = Person();
//                     p.name = "";
//                     plist.add(p);
//                     setState(() {});
//                   },
//                   child: Icon(Icons.add),
//                   style:
//                       TextButton.styleFrom(primary: primaryColor // Text Color
//                           ),
//                 )
//               ],
//             ),
//             Row(
//               children: [
//                 Column(
//                   children: [
//                     for (int i = 0; i < plist.length; i++)
//                       Row(
//                         children: [
//                           CustomText('${i + 1} ', 30, null, FontWeight.w400, 0),
//                           CustomTextFormField(
//                             height! * 0.052,
//                             width! * 0.75,
//                             "",
//                             peopleControllers[i],
//                             (value) {
//                               plist[i].name = value;
//                               setState(() {});
//                             },
//                           ),
//                         ],
//                       ),
//                   ],
//                 )
//               ],
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 CustomText("Event", 10, null, FontWeight.w500, 0),
//                 TextButton(
//                   onPressed: () {
//                     Event e = new Event();
//                     e.name = "";
//                     elist.add(e);
//                     setState(() {});
//                   },
//                   child: Icon(Icons.add),
//                   style:
//                       TextButton.styleFrom(primary: primaryColor // Text Color
//                           ),
//                 )
//               ],
//             ),
//             Row(
//               children: [
//                 Column(
//                   children: [
//                     for (int i = 0; i < elist.length; i++)
//                       Row(
//                         children: [
//                           CustomText('${i + 1} ', 30, null, FontWeight.w400, 0),
//                           CustomTextFormField(
//                             height! * 0.052,
//                             width! * 0.75,
//                             "",
//                             eventControllers[i],
//                             (value) {
//                               elist[i].name = eventControllers[i].text;
//                             },
//                           ),
//                         ],
//                       )
//                   ],
//                 )
//               ],
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             CustomText("Location", 10, null, FontWeight.w500, 0),
//             Row(
//               children: [
//                 SizedBox(
//                   width: 50,
//                 ),
//                 CustomTextFormField(
//                     height! * 0.052, width! * 0.75, "", locationController,
//                     (value) {
//                   location = locationController.text;
//                 })
//               ],
//             ),
//             SizedBox(
//               height: 30,
//             ),
//             CustomButton("Add/Edit", 30, 150, primaryColor, primaryColor,
//                 Colors.white, addeditfunction)
//           ],
//         ),
//       ),
//     );
//   }
// }
