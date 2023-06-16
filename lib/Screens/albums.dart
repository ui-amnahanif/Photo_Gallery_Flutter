import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:native_exif/native_exif.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallery/DBHelper/dbhelper.dart';
import 'package:photo_gallery/Models/album.dart';
import 'package:photo_gallery/Models/person.dart';
import 'package:photo_gallery/Models/photo.dart';
import 'package:photo_gallery/Screens/albumsOfAlbums.dart';
import 'package:photo_gallery/Screens/editeventalbums.dart';
import 'package:photo_gallery/Utilities/CustomWdigets/customalbum.dart';
import 'package:photo_gallery/Utilities/Global/global.dart';
import 'package:path/path.dart' as path;

import '../Models/event.dart';

class AlbummsScreen extends StatefulWidget {
  @override
  State<AlbummsScreen> createState() => _AlbummsScreenState();
}

class _AlbummsScreenState extends State<AlbummsScreen>
    with TickerProviderStateMixin {
  List<Album> allAlbumslist = [];
  List<Album> peopleAlbumsList = [];
  List<Album> eventAlbumsList = [];
  List<Album> locationAlbumsList = [];
  List<Album> dateAlbumsList = [];
  List<Album> labelAlbumsList = [];
  //List<Photo> plistToPass = [];
  double? width;
  double? height;
  double initialScale = 1.0;
  double scaleFactor = 1.0;
  @override
  void initState() {
    createFolder();
    getAllAlbums();
  }

  void createFolder() async {
    final Directory? appDir = await getExternalStorageDirectory();
    final String imagesDir = path.join(appDir!.path, 'images');
    if (!await Directory(imagesDir).exists()) {
      Directory(imagesDir).create(recursive: true);
    }
  }

  void reset() {
    getAllAlbums();
    setState(() {});
  }

  void getAllAlbums() async {
    // allAlbumslist = await DbHelper.instance.getAllAlbums();
    // peopleAlbumsList = await DbHelper.instance.getPeopleAlbums();
    // eventAlbumsList = await DbHelper.instance.getEventAlbums();
    // labelAlbumsList = await DbHelper.instance.getLabelAlbums();
    // dateAlbumsList = await DbHelper.instance.getDateAlbums();
    // locationAlbumsList = await DbHelper.instance.getLocationAlbums();
    // setState(() {});
    peopleAlbumsList = await Album.getAllPersonsAlbums();
    eventAlbumsList = await Album.getAllEventsAlbums();
    labelAlbumsList = await Album.getAllLabelAlbums();
    dateAlbumsList = await Album.getAllDatesAlbums();
    locationAlbumsList = await Album.getAllLocationAlbums();
    setState(() {});
  }

  late File _image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    TabController _tabController = TabController(length: 5, vsync: this);
    return Scaffold(
      appBar: AppBar(
        title: Text("Albums"),
        backgroundColor: primaryColor,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.camera_alt,
                        color: Color.fromRGBO(181, 97, 251, 1.0)),
                    title: const Text('Take photo'),
                    onTap: () async {
                      await Permission.storage.request();
                      final isPermissionGranted =
                          await Permission.storage.isGranted;
                      if (isPermissionGranted) {
                        final pickedFile = await picker.pickImage(
                          source: ImageSource.camera,
                        );

                        if (pickedFile != null) {
                          // Get a reference to the directory where images are stored.
                          final Directory? appDir =
                              await getExternalStorageDirectory();
                          final String imagesDir =
                              path.join(appDir!.path, 'images');
                          // if (!await Directory(imagesDir).exists()) {
                          //   Directory(imagesDir).create(recursive: true);
                          // }
                          // Directory dir = await Directory(imagesDir)
                          //     .create(recursive: true);

                          // Copy the image file to the app's directory.
                          final String fileName =
                              path.basename(pickedFile.path);

                          final String filePath =
                              path.join(imagesDir, fileName);
                          print(fileName);
                          print(filePath);
                          await File(pickedFile.path).copy(filePath);
                          await getImageLatLngDatePeople(
                              filePath, File(filePath), fileName);
                          _image = File(pickedFile.path);
                          setState(() {});
                        }
                      }

                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.photo,
                      color: Color.fromRGBO(181, 97, 251, 1.0),
                    ),
                    title: const Text('Choose from Gallery'),
                    onTap: () async {
                      final pickedFile = await picker.pickImage(
                        source: ImageSource.gallery,
                      );

                      if (pickedFile != null) {
                        await getImageLatLngDatePeople(pickedFile.path,
                            File(pickedFile.path), pickedFile.name);
                        _image = File(pickedFile.path);
                        setState(() {});
                      }
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.camera_alt),
        elevation: 18,
        backgroundColor: primaryColor,
      ),
      body: Column(
        children: [
          Container(
            height: height! * 0.08,
            child: TabBar(
                indicatorColor: primaryColor,
                controller: _tabController,
                labelColor: Colors.black,
                labelPadding: EdgeInsets.all(4),
                tabs: const [
                  Text(
                    "Date",
                  ),
                  Text(
                    "People",
                  ),
                  Text(
                    "Event",
                  ),
                  Text(
                    "Location",
                  ),
                  Text(
                    "Label",
                  )
                ]),
          ),
          Container(
            width: width,
            height: height! * 0.71,
            child: TabBarView(
                // physics: const NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: [
                  dateAlbums(),
                  peopleAlbums(),
                  eventAlbums(),
                  locationAlbums(),
                  labelAlbums(),
                ]),
          ),
        ],
      ),
    );
  }

  Future<void> getImageLatLngDatePeople(
      String ImagePath, File image, String title) async {
    Photo p = Photo();
    List<Person> plist = [];
    p.path = ImagePath;
    p.title = title;
    p.isSynced = 0;
    DateTime currentDateTime = DateTime.now();
    String formattedDateTime =
        DateFormat("yyyy:MM:dd HH:mm:ss").format(currentDateTime);
    //print(formattedDateTime);
    p.last_modified_date = formattedDateTime;
    List<String> people = [];
    final exif = await Exif.fromPath(ImagePath);
    final latlng = await exif.getLatLong();
    final data = await exif.getAttributes() ?? {};
    if (!data.isEmpty) {
      if (data.containsKey("DateTimeOriginal")) {
        p.date_taken = data["DateTimeOriginal"].toString();
      } else {
        p.date_taken = "2023:05:26 14:57:20";
      }
      if (data.containsKey("GPSLatitude")) {
        p.lat = double.parse(data["GPSLatitude"].toString());
      }
      if (data.containsKey("GPSLongitude")) {
        p.lng = double.parse(data["GPSLongitude"].toString());
      }
    }
    exif.close();
    // final fileBytes = File(ImagePath).readAsBytesSync();
    // final data = await readExifFromBytes(fileBytes);

    // if (!data.isEmpty) {
    //   if (data.containsKey("Image DateTime")) {
    //     p.date_taken = data["Image DateTime"].toString();
    //   }
    //   if (data.containsKey("GPS GPSLatitude")) {
    //     String latitude = data["GPS GPSLatitude"].toString();
    //     List<String> substrings =
    //         latitude.replaceAll('[', '').replaceAll(']', '').split(', ');

    //     // parse the substrings into double values
    //     double degrees = double.parse(substrings[0]);
    //     double minutes = double.parse(substrings[1]);
    //     List<String> parts = substrings[2].split("/");
    //     double numerator = double.parse(parts[0]);
    //     double denominator = double.parse(parts[1]);
    //     double seconds = numerator / denominator;

    //     // combine degrees, minutes and seconds into decimal degrees
    //     double decimalDegrees = degrees + (minutes / 60) + (seconds / 3600);
    //     p.lat = decimalDegrees;
    //   }
    //   if (data.containsKey("GPS GPSLongitude")) {
    //     String latitude = data["GPS GPSLongitude"].toString();
    //     List<String> substrings =
    //         latitude.replaceAll('[', '').replaceAll(']', '').split(', ');

    //     // parse the substrings into double values
    //     double degrees = double.parse(substrings[0]);
    //     double minutes = double.parse(substrings[1]);
    //     List<String> parts = substrings[2].split("/");
    //     double numerator = double.parse(parts[0]);
    //     double denominator = double.parse(parts[1]);
    //     double seconds = numerator / denominator;

    //     // combine degrees, minutes and seconds into decimal degrees
    //     double decimalDegrees = degrees + (minutes / 60) + (seconds / 3600);
    //     p.lng = decimalDegrees;
    //   }
    // }
    people = await Photo.saveImage(image);
    Person per;
    for (int i = 0; i < people.length; i++) {
      //adding people name in person list
      per = Person();
      per.name = people[i];
      plist.add(per);
    }
    //  int id=  await DbHelper.instance.insertPhoto(p);
    //   Photo lastInsertedPhoto = await DbHelper.instance.getLastInsertedPhoto();
    //   await DbHelper.instance
    //       .inserteditPersonAndAlbumbyid(lastInsertedPhoto, plist);

    int photoId = await DbHelper.instance.insertPhoto(p);
    await Person.insertPersons(plist, photoId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Albums created successfully'),
      ),
    );
    getAllAlbums();
  }

  // Widget allAlbums() {
  //   return GestureDetector(
  //     onScaleStart: (details) {
  //       scaleFactor = initialScale;
  //     },
  //     onScaleUpdate: (details) {
  //       setState(() {
  //         scaleFactor = initialScale = details.scale;
  //         print("Scale = " + details.scale.toString());
  //       });
  //     },
  //     child: Container(
  //       padding: EdgeInsets.only(top: 15),
  //       child: GridView.count(
  //         // physics: const NeverScrollableScrollPhysics(),
  //         crossAxisCount: scaleFactor == 1.0
  //             ? 3
  //             : double.parse(scaleFactor.toStringAsFixed(1)) > 1.0 &&
  //                     double.parse(scaleFactor.toStringAsFixed(1)) < 1.5
  //                 ? 2
  //                 : double.parse(scaleFactor.toStringAsFixed(1)) > 1.5 &&
  //                         double.parse(scaleFactor.toStringAsFixed(1)) < 2.0
  //                     ? 1
  //                     : 3,
  //         children: [
  //           ...allAlbumslist.map(
  //             (e) => GestureDetector(
  //               onTap: () {
  //                 Navigator.push(context, MaterialPageRoute(builder: (context) {
  //                   return AlbumsOfAlbumsScreen(e.title, e.id!);
  //                   //return PhotosScreen(e.title, e.id!, personlist)
  //                 }));
  //               },
  //               child: CustomAlbum(
  //                   e.title,
  //                   e.cover_photo,
  //                   scaleFactor == 1.0
  //                       ? height! * 0.11
  //                       : double.parse(scaleFactor.toStringAsFixed(1)) > 1.0 &&
  //                               double.parse(scaleFactor.toStringAsFixed(1)) <
  //                                   1.5
  //                           ? height! * 0.18
  //                           : double.parse(scaleFactor.toStringAsFixed(1)) >
  //                                       1.5 &&
  //                                   double.parse(
  //                                           scaleFactor.toStringAsFixed(1)) <
  //                                       2.0
  //                               ? height! * 0.40
  //                               : height! * 0.11,
  //                   scaleFactor == 1.0
  //                       ? width! * 0.3
  //                       : double.parse(scaleFactor.toStringAsFixed(1)) > 1.0 &&
  //                               double.parse(scaleFactor.toStringAsFixed(1)) <
  //                                   1.5
  //                           ? width! * 0.45
  //                           : double.parse(scaleFactor.toStringAsFixed(1)) >
  //                                       1.5 &&
  //                                   double.parse(
  //                                           scaleFactor.toStringAsFixed(1)) <
  //                                       2.0
  //                               ? width! * 0.85
  //                               : width! * 0.3), //85 100
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  // Widget allAlbums() {
  //   return InteractiveViewer(
  //     scaleEnabled: false,
  //     // onInteractionStart: (details) {
  //     //   scaleFactor = initialScale;
  //     // },
  //     maxScale: 2.0,
  //     onInteractionUpdate: (details) {
  //       setState(() {
  //         // print("pointer count : " + details.pointerCount.toString());
  //         scaleFactor = initialScale = details.scale;
  //         print("Scale = " + details.scale.toString());
  //       });
  //     },
  //     child: Container(
  //       padding: EdgeInsets.only(top: 15),
  //       child: GridView.count(
  //         // physics: const NeverScrollableScrollPhysics(),
  //         crossAxisCount: scaleFactor == 1.0
  //             ? 3
  //             : double.parse(scaleFactor.toStringAsFixed(1)) > 1.0 &&
  //                     double.parse(scaleFactor.toStringAsFixed(1)) < 1.5
  //                 ? 2
  //                 : double.parse(scaleFactor.toStringAsFixed(1)) > 1.5 &&
  //                         double.parse(scaleFactor.toStringAsFixed(1)) < 2.0
  //                     ? 1
  //                     : double.parse(scaleFactor.toStringAsFixed(1)) < 1.0 &&
  //                             double.parse(scaleFactor.toStringAsFixed(1)) > 0.5
  //                         ? 4
  //                         : double.parse(scaleFactor.toStringAsFixed(1)) <=
  //                                     0.5 &&
  //                                 double.parse(scaleFactor.toStringAsFixed(1)) >
  //                                     0.0
  //                             ? 5
  //                             : 3,
  //         children: [
  //           ...allAlbumslist.map(
  //             (e) => GestureDetector(
  //               onTap: () {
  //                 Navigator.push(context, MaterialPageRoute(builder: (context) {
  //                   return AlbumsOfAlbumsScreen(e.title, e.id!);
  //                   //return PhotosScreen(e.title, e.id!, personlist)
  //                 }));
  //               },
  //               child: CustomAlbum(
  //                   e.title,
  //                   e.cover_photo!,
  //                   scaleFactor == 1.0
  //                       ? height! * 0.11
  //                       : double.parse(scaleFactor.toStringAsFixed(1)) > 1.0 &&
  //                               double.parse(scaleFactor.toStringAsFixed(1)) <
  //                                   1.5
  //                           ? height! * 0.18
  //                           : double.parse(scaleFactor.toStringAsFixed(1)) > 1.5 &&
  //                                   double.parse(scaleFactor.toStringAsFixed(1)) <
  //                                       2.0
  //                               ? height! * 0.40
  //                               : double.parse(scaleFactor.toStringAsFixed(1)) <= 0.5 &&
  //                                       double.parse(scaleFactor.toStringAsFixed(1)) >
  //                                           0.0
  //                                   ? height! * 0.08
  //                                   : double.parse(scaleFactor.toStringAsFixed(1)) < 1.0 &&
  //                                           double.parse(scaleFactor.toStringAsFixed(1)) >
  //                                               0.5
  //                                       ? height! * 0.1
  //                                       : height! * 0.11,
  //                   scaleFactor == 1.0
  //                       ? width! * 0.3
  //                       : double.parse(scaleFactor.toStringAsFixed(1)) > 1.0 &&
  //                               double.parse(scaleFactor.toStringAsFixed(1)) <
  //                                   1.5
  //                           ? width! * 0.45
  //                           : double.parse(scaleFactor.toStringAsFixed(1)) > 1.5 &&
  //                                   double.parse(scaleFactor.toStringAsFixed(1)) <
  //                                       2.0
  //                               ? width! * 0.85
  //                               : double.parse(scaleFactor.toStringAsFixed(1)) <=
  //                                           0.5 &&
  //                                       double.parse(scaleFactor.toStringAsFixed(1)) >
  //                                           0.0
  //                                   ? width! * 0.175
  //                                   : double.parse(scaleFactor.toStringAsFixed(1)) <
  //                                               1.0 &&
  //                                           double.parse(scaleFactor.toStringAsFixed(1)) > 0.5
  //                                       ? width! * 0.22
  //                                       : width! * 0.3),
  //               //85 100
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget peopleAlbums() {
    return GestureDetector(
      onScaleStart: (details) {
        scaleFactor = initialScale;
      },
      onScaleUpdate: (details) {
        setState(() {
          scaleFactor = initialScale = details.scale;
          print("Scale = " + details.scale.toString());
        });
      },
      child: Container(
        padding: EdgeInsets.only(top: 15),
        child: GridView.count(
          crossAxisCount: 2, //scaleFactor == 1.0 ? 3 : 2,
          children: [
            ...peopleAlbumsList.map(
              (e) => GestureDetector(
                onTap: () async {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) {
                  //   return PhotosScreen(e.title, e.id!);
                  // }));
                  List<Photo> plistToPass = [];
                  if (e.title != "Unknown") {
                    plistToPass =
                        await DbHelper.instance.getPhotosofPersonById(e.id!);
                  } else {
                    plistToPass =
                        await DbHelper.instance.getPhotosofUnknownPersons();
                  }

                  await Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                    return AlbumsOfAlbumsScreen(
                      plistToPass,
                      e.title,
                      onBack: () {},
                    );
                  }));
                  getAllAlbums();
                },
                child: CustomAlbum(e.title, e.cover_photo!, height! * 0.15,
                    width! * 0.40, e.plist.length), //85 100
              ),
            ),
          ],
        ),
      ),
    );
  }

  Offset? pos;
  Widget eventAlbums() {
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: GridView.count(
        crossAxisCount: 2,
        children: [
          ...eventAlbumsList.map(
            (e) => GestureDetector(
              // onLongPressStart: (LongPressStartDetails details) {
              //   print(
              //       details.localPosition); // Gives you the position of the tap
              //   final tapPosition = details.globalPosition;
              //   _showPopupMenu(context, tapPosition);
              // },
              onTapDown: (position) => {
                pos = _getTapPosition(position) /* get screen tap position */
              },
              onLongPress: () async {
                Event eve = new Event();
                eve.name = e.title;
                eve.id = e.id;
                _showContextMenu(context, pos!, eve); /* action on long press */
              },

              onTap: () async {
                List<Photo> plistToPass =
                    await DbHelper.instance.getPhotosofEventById(e.id!);
                await Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return AlbumsOfAlbumsScreen(
                    plistToPass,
                    e.title,
                    onBack: () {},
                  );
                }));
                getAllAlbums();
              },
              child: CustomAlbum(e.title, e.cover_photo!, height! * 0.15,
                  width! * 0.40, e.plist.length), //85 100 //0.11 //0.3
            ),
          ),
        ],
      ),
    );
  }

  Widget labelAlbums() {
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: GridView.count(
        crossAxisCount: 2,
        children: [
          ...labelAlbumsList.map(
            (e) => GestureDetector(
              onTap: () async {
                List<Photo> plistToPass =
                    await DbHelper.instance.getPhotosofLabelByTitle(e.title);
                await Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return AlbumsOfAlbumsScreen(
                    plistToPass,
                    e.title,
                    onBack: () {},
                  );
                }));
                getAllAlbums();
              },
              child: CustomAlbum(e.title, e.cover_photo!, height! * 0.15,
                  width! * 0.40, e.plist.length), //85 100
            ),
          ),
        ],
      ),
    );
  }

  Widget locationAlbums() {
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: GridView.count(
        crossAxisCount: 2,
        children: [
          ...locationAlbumsList.map(
            (e) => GestureDetector(
              onTap: () async {
                List<Photo> plistToPass =
                    await DbHelper.instance.getPhotosofLocationByTitle(e.title);
                await Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return AlbumsOfAlbumsScreen(
                    plistToPass,
                    e.title,
                    onBack: () {},
                  );
                }));
                getAllAlbums();
              },
              child: CustomAlbum(e.title, e.cover_photo!, height! * 0.15,
                  width! * 0.40, e.plist.length), //85 100
            ),
          ),
        ],
      ),
    );
  }

  Widget dateAlbums() {
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: GridView.count(
        crossAxisCount: 2,
        children: [
          ...dateAlbumsList.map(
            (e) => GestureDetector(
              onTap: () async {
                List<Photo> plistToPass =
                    await DbHelper.instance.getPhotosofDateByPhotoId(e.id!);
                await Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return AlbumsOfAlbumsScreen(
                    plistToPass,
                    e.title,
                    onBack: () {},
                  );
                }));
                getAllAlbums();
              },
              child: CustomAlbum(e.title, e.cover_photo!, height! * 0.15,
                  width! * 0.40, e.plist.length), //85 100
            ),
          ),
        ],
      ),
    );
  }

  Offset _getTapPosition(TapDownDetails tapPosition) {
    final RenderBox referenceBox = context.findRenderObject() as RenderBox;

    Offset _tapPosition = referenceBox.globalToLocal(
        tapPosition.globalPosition); // store the tap positon in offset variable
    print(_tapPosition);

    return _tapPosition;
  }

  void _showContextMenu(
      BuildContext context, Offset _tapPosition, Event e) async {
    final RenderObject? overlay =
        Overlay.of(context).context.findRenderObject();

    final result = await showMenu(
        context: context,
        position: RelativeRect.fromRect(
            Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 100, 100),
            Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
                overlay.paintBounds.size.height)),
        items: [
          const PopupMenuItem(
            child: Text('edit'),
            value: "edit",
          ),
        ]);
    // perform action on selected menu item
    switch (result) {
      case 'edit':
        print("edit");
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return EditEventAlbum(e);
            },
          ),
        );
        getAllAlbums();
        break;
    }
  }
  // void _showPopupMenu(BuildContext context) async {
  //   // Display popup menu
  //   final result = await showMenu(
  //     context: context,
  //     position: RelativeRect.fromLTRB(1000.0, 0.0, 0.0, 0.0),
  //     items: [
  //       PopupMenuItem(value: 1, child: Text('Option 1')),
  //       PopupMenuItem(value: 2, child: Text('Option 2')),
  //       PopupMenuItem(value: 3, child: Text('Option 3')),
  //     ],
  //   );

  //   // Handle popup menu selection
  //   switch (result) {
  //     case 1:
  //       // Do something for option 1
  //       break;
  //     case 2:
  //       // Do something for option 2
  //       break;
  //     case 3:
  //       // Do something for option 3
  //       break;
  //   }
  // }

  // void _showPopupMenu(BuildContext context, Offset tapPosition) async {
  //   // Display popup menu
  //   final result = await showMenu(
  //     context: context,
  //     position: RelativeRect.fromLTRB(tapPosition.dx, tapPosition.dy, 0, 0),
  //     items: [
  //       PopupMenuItem(value: 1, child: Text('Option 1')),
  //       PopupMenuItem(value: 2, child: Text('Option 2')),
  //       PopupMenuItem(value: 3, child: Text('Option 3')),
  //     ],
  //   );

  //   // Handle popup menu selection
  //   switch (result) {
  //     case 1:
  //       // Do something for option 1
  //       break;
  //     case 2:
  //       // Do something for option 2
  //       break;
  //     case 3:
  //       // Do something for option 3
  //       break;
  //   }
  // }
}
