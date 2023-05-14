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
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:photo_gallery/DBHelper/dbhelper.dart';
import 'package:photo_gallery/Models/person.dart';
import 'package:photo_gallery/Utilities/CustomWdigets/custombutton.dart';
import 'package:photo_gallery/Utilities/CustomWdigets/customradiobutton.dart';
import 'package:photo_gallery/Utilities/Global/global.dart';
import '../Models/event.dart';
import '../Utilities/CustomWdigets/customtext.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DateTime selectedDate = DateTime.now();
  double? height;
  double? width;
  String rdPeople = "peopleIncluded";
  String rdEvent = "eventIncluded";
  String rdLabel = "labelIncluded";
  String rdDate = "dateIncluded";
  String rdLocation = "locationIncluded";
  List<Person> plist = [];
  List<Event> elist = [];
  List<String> llist = [];
  var selectedPerson;
  var selectedEvent;
  var selectedLabel;
  List<Person> selectedPersonsList = [];
  List<Event> selectedEventList = [];

  List<DropdownMenuItem<String>> getPersons() {
    List<DropdownMenuItem<String>> itemslist = [];
    plist.forEach((element) {
      DropdownMenuItem<String> m = DropdownMenuItem(
        child: Text(element.name),
        value: element.name.toString(),
      );
      itemslist.add(m);
    });
    return itemslist;
  }

  List<DropdownMenuItem<String>> getEvents() {
    List<DropdownMenuItem<String>> itemslist = [];
    elist.forEach((element) {
      DropdownMenuItem<String> m = DropdownMenuItem(
        child: Text(element.name),
        value: element.name.toString(),
      );
      itemslist.add(m);
    });
    return itemslist;
  }

  List<DropdownMenuItem<String>> getLabels() {
    List<DropdownMenuItem<String>> itemslist = [];
    llist.forEach((element) {
      DropdownMenuItem<String> m = DropdownMenuItem(
        child: Text(
          element,
          overflow: TextOverflow.ellipsis,
        ),
        value: element.toString(),
      );
      itemslist.add(m);
    });
    return itemslist;
  }

  @override
  void initState() {
    getData();
    setState(() {});
  }

  void getData() async {
    plist = await DbHelper.instance.getAllPersons();
    elist = await DbHelper.instance.getAllEvents();
    llist = await DbHelper.instance.getAllLabels();
    // Person p = Person();
    // p.name = "";
    // plist.add(p);
    // selectedPerson = plist[0].name;
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomRadioButton(
                      "Included",
                      "peopleIncluded",
                      rdPeople,
                      (String? value) {
                        setState(() {
                          rdPeople = value!;
                        });
                      },
                    ),
                    CustomRadioButton(
                      "Only",
                      "peopleOnly",
                      rdPeople,
                      (String? value) {
                        setState(() {
                          rdPeople = value!;
                        });
                      },
                    ),
                    CustomRadioButton(
                      "Excluded",
                      "peopleExcluded",
                      rdPeople,
                      (String? value) {
                        setState(() {
                          rdPeople = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 15),
                width: 350,
                child: DropdownButton(
                    underline: Container(
                      height: 1.5,
                      color: primaryColor,
                    ),
                    isExpanded: true,
                    isDense: true,
                    value: selectedPerson,
                    items: getPersons(),
                    hint: Text("Select person"),
                    onChanged: (v) async {
                      selectedPerson = v!;
                      setState(() {});
                    }),
              ),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomRadioButton(
                      "Included",
                      "eventIncluded",
                      rdEvent,
                      (String? value) {
                        setState(() {
                          rdEvent = value!;
                        });
                      },
                    ),
                    CustomRadioButton(
                      "Only",
                      "eventOnly",
                      rdEvent,
                      (String? value) {
                        setState(() {
                          rdEvent = value!;
                        });
                      },
                    ),
                    CustomRadioButton(
                      "Excluded",
                      "eventExcluded",
                      rdEvent,
                      (String? value) {
                        setState(() {
                          rdEvent = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 15),
                width: 350,
                child: DropdownButton(
                    underline: Container(
                      height: 1.5,
                      color: primaryColor,
                    ),
                    isExpanded: true,
                    isDense: true,
                    value: selectedEvent,
                    items: getEvents(),
                    hint: Text("Select event"),
                    onChanged: (v) async {
                      selectedEvent = v!;
                      setState(() {});
                    }),
              ),
              CustomText("Label", 10, null, FontWeight.w500, 0.1),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomRadioButton(
                    "Included",
                    "labelIncluded",
                    rdLabel,
                    (String? value) {
                      setState(() {
                        rdLabel = value!;
                      });
                    },
                  ),
                  CustomRadioButton(
                    "Excluded",
                    "labelExcluded",
                    rdLabel,
                    (String? value) {
                      setState(() {
                        rdLabel = value!;
                      });
                    },
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(left: 15),
                width: 350,
                child: DropdownButton(
                    underline: Container(
                      height: 1.5,
                      color: primaryColor,
                    ),
                    isExpanded: true,
                    isDense: true,
                    value: selectedLabel,
                    items: getLabels(),
                    hint: Text("Select label"),
                    onChanged: (v) async {
                      selectedLabel = v!;
                      setState(() {});
                    }),
              ),
              CustomText("Date", 10, null, FontWeight.w500, 0.1),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomRadioButton(
                    "Included",
                    "dateIncluded",
                    rdDate,
                    (String? value) {
                      setState(() {
                        rdDate = value!;
                      });
                    },
                  ),
                  CustomRadioButton(
                    "Excluded",
                    "dateExcluded",
                    rdDate,
                    (String? value) {
                      setState(() {
                        rdDate = value!;
                      });
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Text("${selectedDate}"),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomRadioButton(
                      "Included",
                      "locationIncluded",
                      rdLocation,
                      (String? value) {
                        setState(() {
                          rdLocation = value!;
                        });
                      },
                    ),
                    CustomRadioButton(
                      "Only",
                      "locationOnly",
                      rdLocation,
                      (String? value) {
                        setState(() {
                          rdLocation = value!;
                        });
                      },
                    ),
                    CustomRadioButton(
                      "Excluded",
                      "locationExcluded",
                      rdLocation,
                      (String? value) {
                        setState(() {
                          rdLocation = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: 340,
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: "Enter Location",
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                          ),
                        ),
                      )),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: CustomButton("Search", 40, 130, primaryColor,
                    primaryColor, Colors.white, () {}),
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
    if (picked != null && picked != selectedDate) selectedDate = picked;
    setState(() {});
  }
}
