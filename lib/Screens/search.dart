// import 'package:flutter/material.dart';
// import 'package:photo_gallery/Utilities/CustomWdigets/customtextformfield.dart';
// import 'package:photo_gallery/Utilities/Global/global.dart';

// import '../Models/album.dart';

// class SearchScreen extends StatefulWidget {
//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   List<Album> alist = [];
//   double? height;
//   double? width;
//   TextEditingController searchController = TextEditingController();
//   @override
//   void initState() {
//     // TODO: implement initState
//     // alist = Album.getAlbums();
//     // setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     height = MediaQuery.of(context).size.height;
//     width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Search",
//         ),
//         backgroundColor: primaryColor,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             SizedBox(
//               height: height! * 0.015,
//             ),
//             searchBar(),
//             SizedBox(
//               height: height! * 0.02,
//             ),
//             getalbums(),
//             SizedBox(
//               height: height! * 0.015,
//             ),
//             getpictures(),
//           ],
//         ),
//       ),
//     );
//   }

//   Row searchBar() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         CustomTextFormField(
//           50,
//           300,
//           "Search",
//           searchController,
//         ),
//         IconButton(
//           onPressed: () {
//             // showDialog(context: context, builder: (context) {return Container()});
//           },
//           icon: Icon(
//             Icons.filter_alt,
//             size: 40,
//             color: primaryColor,
//           ),
//         ),
//       ],
//     );
//   }
// // Future<void> showFilterDialog(BuildContext context)async{
// // return await showDialog(context: context, builder: (context){

// //   return Container();
// // });
// // }
//   Widget getalbums() {
//     return Container(
//       //color: Colors.amber,
//       height: height! * 0.15,
//       width: width,
//       child: ListView.builder(
//         itemCount: alist.length,
//         scrollDirection: Axis.horizontal,
//         itemBuilder: (context, index) {
//           return Row(
//             children: [
//               const SizedBox(
//                 width: 10,
//               ),
//               // CustomAlbum(alist[index].title, alist[index].image, 85, 100),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Widget getpictures() {
//     return Container(
//       padding: EdgeInsets.only(left: width! * 0.02),
//       height: height! * 0.85,
//       width: width,
//       child: Wrap(
//         spacing: width! * 0.02, //7,
//         runSpacing: width! * -0.03,
//         // children: [
//         //   ...alist.map(
//         //     (e) => CustomAlbum(null, e.image, 100, 110),
//         //   ),
//         // ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:photo_gallery/DBHelper/dbhelper.dart';
import 'package:photo_gallery/Models/person.dart';
import 'package:photo_gallery/Utilities/CustomWdigets/custombutton.dart';
import 'package:photo_gallery/Utilities/CustomWdigets/customradiobutton.dart';
import 'package:photo_gallery/Utilities/Global/global.dart';
import '../Models/event.dart';
import '../Models/photo.dart';
import '../Utilities/CustomWdigets/customtext.dart';
import '../Utilities/CustomWdigets/customtextformfield.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DateTime selectedDate = DateTime.now();
  String formattedDate = "";
  double? height;
  double? width;
  // String rdPeople = "";
  // String rdEvent = "";
  // String rdLabel = "";
//String rdDate = "";
//  String rdLocation = "";
  List<Person> personslist = [];
  List<Event> eventslist = [];
  List<String> labelslist = [];
  List<String> locationslist = [];
//  var selectedPerson;
  // var selectedEvent;
  // var selectedLabel;
  List<Person> selectedPersonsList = [];
  List<Event> selectedEventList = [];
  List<String> selectedLabelList = [];
  List<String> selectedLocationList = [];

  TextEditingController peopleController = TextEditingController();
  TextEditingController eventController = TextEditingController();
  TextEditingController labelController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  List<Person> _filteredPersons = [];
  List<Event> _filteredEvents = [];
  List<String> _filteredLabels = [];
  List<String> _filteredLocations = [];

  //to store db data
  List<Photo> dbpersonphoto = [];
  List<Photo> dbeventphoto = [];
  List<Photo> dblabelphoto = [];
  List<Photo> dblocationphoto = [];
  List<Photo> dbdatephoto = [];

  // List<DropdownMenuItem<String>> getPersons() {
  //   List<DropdownMenuItem<String>> itemslist = [];
  //   plist.forEach((element) {
  //     DropdownMenuItem<String> m = DropdownMenuItem(
  //       child: Text(element.name),
  //       value: element.name.toString(),
  //     );
  //     itemslist.add(m);
  //   });
  //   return itemslist;
  // }

  // List<DropdownMenuItem<String>> getEvents() {
  //   List<DropdownMenuItem<String>> itemslist = [];
  //   elist.forEach((element) {
  //     DropdownMenuItem<String> m = DropdownMenuItem(
  //       child: Text(element.name),
  //       value: element.name.toString(),
  //     );
  //     itemslist.add(m);
  //   });
  //   return itemslist;
  // }

  // List<DropdownMenuItem<String>> getLabels() {
  //   List<DropdownMenuItem<String>> itemslist = [];
  //   llist.forEach((element) {
  //     DropdownMenuItem<String> m = DropdownMenuItem(
  //       child: Text(
  //         element,
  //         overflow: TextOverflow.ellipsis,
  //       ),
  //       value: element.toString(),
  //     );
  //     itemslist.add(m);
  //   });
  //   return itemslist;
  // }

  @override
  void initState() {
    getData();
    setState(() {});
  }

  void _onPeopleSearchTextChanged(String searchText) {
    _filteredPersons = personslist.where((person) {
      return person.name.toLowerCase().contains(searchText.toLowerCase());
    }).toList();
    setState(() {});
  }

  void _onEventSearchTextChanged(String searchText) {
    _filteredEvents = eventslist.where((event) {
      return event.name.toLowerCase().contains(searchText.toLowerCase());
    }).toList();
    setState(() {});
  }

  void _onLabelSearchTextChanged(String searchText) {
    _filteredLabels = labelslist.where((label) {
      return label.toLowerCase().contains(searchText.toLowerCase());
    }).toList();
    setState(() {});
  }

  void _onLocationSearchTextChanged(String searchText) {
    _filteredLocations = locationslist.where((loc) {
      return loc.toLowerCase().contains(searchText.toLowerCase());
    }).toList();
    setState(() {});
  }

  void getData() async {
    personslist = await DbHelper.instance.getAllPersons();
    eventslist = await DbHelper.instance.getAllEvents();
    labelslist = await DbHelper.instance.getAllLabels();
    locationslist =
        await DbHelper.instance.getAllLocations(); //make function in database

    // Person p = Person();
    // p.name = "";
    // plist.add(p);
    // selectedPerson = plist[0].name;
  }

  Person? getPersonByName(String name) {
    // Filter the list of persons by name
    final perList = personslist.where((person) => person.name == name).toList();

    // Return the first person object that has the same name as the argument passed in
    if (perList.isNotEmpty) return perList.first;

    // If the person is not found, return null
    return null;
  }

  Event? getEventByName(String name) {
    // Filter the list of persons by name
    final eveList = eventslist.where((event) => event.name == name).toList();

    // Return the first person object that has the same name as the argument passed in
    if (eveList.isNotEmpty) return eveList.first;

    // If the person is not found, return null
    return null;
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Search",
        ),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: height,
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText("People", 10, null, FontWeight.w500, 0.1),
              Container(
                width: 350,
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        height! * 0.052,
                        width! * 0.75,
                        "",
                        peopleController,
                        _onPeopleSearchTextChanged,
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (peopleController.text != "") {
                          Person? p = getPersonByName(peopleController.text);
                          if (p != null) {
                            selectedPersonsList.add(p);
                          }
                        }
                        peopleController.text = "";
                        setState(() {});
                      },
                      child: Icon(Icons.check),
                      style: TextButton.styleFrom(
                          primary: primaryColor // Text Color
                          ),
                    )
                  ],
                ),

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     CustomRadioButton(
                //       "Included",
                //       "peopleIncluded",
                //       rdPeople,
                //       (String? value) {
                //         setState(() {
                //           rdPeople = value!;
                //         });
                //       },
                //     ),
                //     CustomRadioButton(
                //       "Only",
                //       "peopleOnly",
                //       rdPeople,
                //       (String? value) {
                //         setState(() {
                //           rdPeople = value!;
                //         });
                //       },
                //     ),
                //     CustomRadioButton(
                //       "Excluded",
                //       "peopleExcluded",
                //       rdPeople,
                //       (String? value) {
                //         setState(() {
                //           rdPeople = value!;
                //         });
                //       },
                //     ),
                //   ],
                // ),
              ),
              Container(
                height: _filteredPersons.length != 0 ? 200 : 0,
                width: width! * 0.75,
                child: ListView.builder(
                  itemCount: _filteredPersons.length,
                  itemBuilder: (context, index) {
                    final per = _filteredPersons[index];
                    return ListTile(
                      title: Text(per.name),
                      // subtitle: Text(contact.phones!.first.value!),
                      // leading: CircleAvatar(
                      //   child: Text(contact.initials()),
                      // ),
                      onTap: () {
                        peopleController.text = _filteredPersons[index].name;
                        print(_filteredPersons[index].name);
                        _filteredPersons.clear();
                        setState(() {});
                      },
                    );
                  },
                ),
              ),
              selectedPersonsList.length >= 1
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: selectedPersonsList.length,
                      itemBuilder: (context, ind) {
                        return ListTile(
                          title: CustomText(selectedPersonsList[ind].name, 0, 0,
                              FontWeight.w400, 0),
                          trailing: Wrap(
                            spacing: -15, // space between two icons
                            children: [
                              // IconButton(
                              //   onPressed: () {
                              //     peopleController.text =
                              //         selectedPersonsList[ind].name;

                              //     setState(() {});
                              //   },
                              //   icon: Icon(
                              //     Icons.edit,
                              //     color: primaryColor,
                              //   ),
                              // ), // icon-1
                              IconButton(
                                onPressed: () {
                                  selectedPersonsList.removeAt(ind);
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
              // Container(
              //   padding: EdgeInsets.only(left: 15),
              //   width: 350,
              //   child: DropdownButton(
              //       underline: Container(
              //         height: 1.5,
              //         color: primaryColor,
              //       ),
              //       isExpanded: true,
              //       isDense: true,
              //       value: selectedPerson,
              //       items: getPersons(),
              //       hint: Text("Select person"),
              //       onChanged: (v) async {
              //         selectedPerson = v!;
              //         setState(() {});
              //       }),
              // ),
              // Row(
              //   children: [
              //     SizedBox(
              //       width: 10,
              //     ),
              //     Container(
              //       padding: EdgeInsets.only(right: 100),
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(40),
              //         border: Border.all(
              //           color: primaryColor,
              //           width: 1,
              //         ),
              //       ),
              //       width: 300,
              //       child: Row(
              //         children: [
              //           SizedBox(
              //             width: 15,
              //           ),
              //           DropdownButton(
              //               underline: SizedBox(),
              //               // isExpanded: true,
              //               // isDense: true,
              //               value: selectedPerson,
              //               items: getPersons(),
              //               hint: Text("Select person"),
              //               onChanged: (v) async {
              //                 selectedPerson = v!;
              //                 setState(() {});
              //               }),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
              CustomText("Event", 10, null, FontWeight.w500, 0.1),
              Container(
                width: 350,
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        height! * 0.052,
                        width! * 0.75,
                        "",
                        eventController,
                        _onEventSearchTextChanged,
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (eventController.text != "") {
                          Event? e = getEventByName(eventController.text);
                          if (e != null) {
                            selectedEventList.add(e);
                          }
                        }
                        eventController.text = "";
                        setState(() {});
                      },
                      child: Icon(Icons.check),
                      style: TextButton.styleFrom(
                          primary: primaryColor // Text Color
                          ),
                    )
                  ],
                ),
              ),
              Container(
                height: _filteredEvents.length != 0 ? 200 : 0,
                width: width! * 0.75,
                child: ListView.builder(
                  itemCount: _filteredEvents.length,
                  itemBuilder: (context, index) {
                    final eve = _filteredEvents[index];
                    return ListTile(
                      title: Text(eve.name),
                      onTap: () {
                        eventController.text = _filteredEvents[index].name;
                        print(_filteredEvents[index].name);
                        _filteredEvents.clear();
                        setState(() {});
                      },
                    );
                  },
                ),
              ),
              selectedEventList.length >= 1
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: selectedEventList.length,
                      itemBuilder: (context, ind) {
                        return ListTile(
                          title: CustomText(selectedEventList[ind].name, 0, 0,
                              FontWeight.w400, 0),
                          trailing: Wrap(
                            spacing: -15, // space between two icons
                            children: [
                              // IconButton(
                              //   onPressed: () {
                              //     peopleController.text =
                              //         selectedPersonsList[ind].name;

                              //     setState(() {});
                              //   },
                              //   icon: Icon(
                              //     Icons.edit,
                              //     color: primaryColor,
                              //   ),
                              // ), // icon-1
                              IconButton(
                                onPressed: () {
                                  selectedEventList.removeAt(ind);
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
              // Container(
              //   width: 350,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       CustomRadioButton(
              //         "Included",
              //         "eventIncluded",
              //         rdEvent,
              //         (String? value) {
              //           setState(() {
              //             rdEvent = value!;
              //           });
              //         },
              //       ),
              //       CustomRadioButton(
              //         "Only",
              //         "eventOnly",
              //         rdEvent,
              //         (String? value) {
              //           setState(() {
              //             rdEvent = value!;
              //           });
              //         },
              //       ),
              //       CustomRadioButton(
              //         "Excluded",
              //         "eventExcluded",
              //         rdEvent,
              //         (String? value) {
              //           setState(() {
              //             rdEvent = value!;
              //           });
              //         },
              //       ),
              //     ],
              //   ),
              // ),
              // Container(
              //   padding: EdgeInsets.only(left: 15),
              //   width: 350,
              //   child: DropdownButton(
              //       underline: Container(
              //         height: 1.5,
              //         color: primaryColor,
              //       ),
              //       isExpanded: true,
              //       isDense: true,
              //       value: selectedEvent,
              //       items: getEvents(),
              //       hint: Text("Select event"),
              //       onChanged: (v) async {
              //         selectedEvent = v!;
              //         setState(() {});
              //       }),
              // ),
              CustomText("Label", 10, null, FontWeight.w500, 0.1),
              Container(
                width: 350,
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        height! * 0.052,
                        width! * 0.75,
                        "",
                        labelController,
                        _onLabelSearchTextChanged,
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (labelController.text != "") {
                          selectedLabelList.add(labelController.text);
                        }
                        labelController.text = "";
                        setState(() {});
                      },
                      child: Icon(Icons.check),
                      style: TextButton.styleFrom(
                          primary: primaryColor // Text Color
                          ),
                    )
                  ],
                ),
              ),
              Container(
                height: _filteredLabels.length != 0 ? 200 : 0,
                width: width! * 0.75,
                child: ListView.builder(
                  itemCount: _filteredLabels.length,
                  itemBuilder: (context, index) {
                    final lbl = _filteredLabels[index];
                    return ListTile(
                      title: Text(lbl),
                      onTap: () {
                        labelController.text = _filteredLabels[index];
                        print(_filteredLabels[index]);
                        _filteredLabels.clear();
                        setState(() {});
                      },
                    );
                  },
                ),
              ),
              selectedLabelList.length >= 1
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: selectedLabelList.length,
                      itemBuilder: (context, ind) {
                        return ListTile(
                          title: CustomText(
                              selectedLabelList[ind], 0, 0, FontWeight.w400, 0),
                          trailing: Wrap(
                            spacing: -15, // space between two icons
                            children: [
                              IconButton(
                                onPressed: () {
                                  selectedLabelList.removeAt(ind);
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
                  : CustomText("no label", 10, null, FontWeight.w400, 0.1),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     CustomRadioButton(
              //       "Included",
              //       "labelIncluded",
              //       rdLabel,
              //       (String? value) {
              //         setState(() {
              //           rdLabel = value!;
              //         });
              //       },
              //     ),
              //     CustomRadioButton(
              //       "Excluded",
              //       "labelExcluded",
              //       rdLabel,
              //       (String? value) {
              //         setState(() {
              //           rdLabel = value!;
              //         });
              //       },
              //     ),
              //   ],
              // ),
              // Container(
              //   padding: EdgeInsets.only(left: 15),
              //   width: 350,
              //   child: DropdownButton(
              //       underline: Container(
              //         height: 1.5,
              //         color: primaryColor,
              //       ),
              //       isExpanded: true,
              //       isDense: true,
              //       value: selectedLabel,
              //       items: getLabels(),
              //       hint: Text("Select label"),
              //       onChanged: (v) async {
              //         selectedLabel = v!;
              //         setState(() {});
              //       }),
              // ),
              CustomText("Date", 10, null, FontWeight.w500, 0.1),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     CustomRadioButton(
              //       "Included",
              //       "dateIncluded",
              //       rdDate,
              //       (String? value) {
              //         setState(() {
              //           rdDate = value!;
              //         });
              //       },
              //     ),
              //     CustomRadioButton(
              //       "Excluded",
              //       "dateExcluded",
              //       rdDate,
              //       (String? value) {
              //         setState(() {
              //           rdDate = value!;
              //         });
              //       },
              //     ),
              //   ],
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                      width: 150,
                      child: Text(formattedDate != ""
                          ? formattedDate
                          : "no date selected")),
                  SizedBox(
                    width: 50,
                  ),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text("Select Date"),
                    style: ElevatedButton.styleFrom(
                      primary:
                          primaryColor, // Set the background color of the button
                      onPrimary: Colors.white, // Set the text color
                      elevation: 5, // Set the elevation
                      shape: RoundedRectangleBorder(
                        // Make the button rounded
                        borderRadius: BorderRadius.circular(60),
                      ),
                    ),
                  )
                ],
              ),
              CustomText("Location", 10, null, FontWeight.w500, 0.1),
              Container(
                width: 350,
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        height! * 0.052,
                        width! * 0.75,
                        "",
                        locationController,
                        _onLocationSearchTextChanged,
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (locationController.text != "") {
                          selectedLocationList.add(locationController.text);
                        }
                        locationController.text = "";
                        setState(() {});
                      },
                      child: Icon(Icons.check),
                      style: TextButton.styleFrom(
                          primary: primaryColor // Text Color
                          ),
                    )
                  ],
                ),
              ),
              Container(
                height: _filteredLocations.length != 0 ? 200 : 0,
                width: width! * 0.75,
                child: ListView.builder(
                  itemCount: _filteredLocations.length,
                  itemBuilder: (context, index) {
                    final loc = _filteredLocations[index];
                    return ListTile(
                      title: Text(loc),
                      onTap: () {
                        locationController.text = _filteredLocations[index];
                        print(_filteredLocations[index]);
                        _filteredLocations.clear();
                        setState(() {});
                      },
                    );
                  },
                ),
              ),
              selectedLocationList.length >= 1
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: selectedLocationList.length,
                      itemBuilder: (context, ind) {
                        return ListTile(
                          title: CustomText(selectedLocationList[ind], 0, 0,
                              FontWeight.w400, 0),
                          trailing: Wrap(
                            spacing: -15, // space between two icons
                            children: [
                              IconButton(
                                onPressed: () {
                                  selectedLocationList.removeAt(ind);
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
                  : CustomText("no location", 10, null, FontWeight.w400, 0.1),

              // Container(
              //   width: 350,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       CustomRadioButton(
              //         "Included",
              //         "locationIncluded",
              //         rdLocation,
              //         (String? value) {
              //           setState(() {
              //             rdLocation = value!;
              //           });
              //         },
              //       ),
              //       CustomRadioButton(
              //         "Only",
              //         "locationOnly",
              //         rdLocation,
              //         (String? value) {
              //           setState(() {
              //             rdLocation = value!;
              //           });
              //         },
              //       ),
              //       CustomRadioButton(
              //         "Excluded",
              //         "locationExcluded",
              //         rdLocation,
              //         (String? value) {
              //           setState(() {
              //             rdLocation = value!;
              //           });
              //         },
              //       ),
              //     ],
              //   ),
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Container(
              //         width: 340,
              //         child: TextFormField(
              //           decoration: InputDecoration(
              //             hintText: "Enter Location",
              //             enabledBorder: UnderlineInputBorder(
              //               borderSide: BorderSide(color: primaryColor),
              //             ),
              //             focusedBorder: UnderlineInputBorder(
              //               borderSide: BorderSide(color: primaryColor),
              //             ),
              //           ),
              //         )),
              //   ],
              // ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: CustomButton(
                    "Search", 40, 130, primaryColor, primaryColor, Colors.white,
                    () async {
                  dbpersonphoto = await DbHelper.instance
                      .getPhotosofPersons(selectedPersonsList);
                  dbeventphoto = await DbHelper.instance
                      .getPhotosofEvents(selectedEventList);
                  dblabelphoto = await DbHelper.instance
                      .getPhotosofLabels(selectedLabelList);
                  dbdatephoto =
                      await DbHelper.instance.getPhotosofDate(formattedDate);
                  dblocationphoto = await DbHelper.instance
                      .getPhotosofLocation(selectedLocationList);
                }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      DateTime date = DateTime.parse(selectedDate.toString());
      // Use the DateFormat class to format the date string
      formattedDate = DateFormat("yyyy:MM:dd").format(date);
      print(formattedDate); //
    }
    setState(() {});
  }
}
