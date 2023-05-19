import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_gallery/DBHelper/dbhelper.dart';
import 'package:photo_gallery/Models/album.dart';
import 'package:photo_gallery/Screens/albumsOfAlbums.dart';
import 'package:photo_gallery/Utilities/CustomWdigets/customalbum.dart';
import 'package:photo_gallery/Utilities/Global/global.dart';

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
  double? width;
  double? height;
  double initialScale = 1.0;
  double scaleFactor = 1.0;
  @override
  void initState() {
    getAllAlbums();
  }

  void getAllAlbums() async {
    allAlbumslist = await DbHelper.instance.getAllAlbums();
    peopleAlbumsList = await DbHelper.instance.getPeopleAlbums();
    eventAlbumsList = await DbHelper.instance.getEventAlbums();
    labelAlbumsList = await DbHelper.instance.getLabelAlbums();
    dateAlbumsList = await DbHelper.instance.getDateAlbums();
    locationAlbumsList = await DbHelper.instance.getLocationAlbums();
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
                      final pickedFile = await picker.pickImage(
                        source: ImageSource.camera,
                      );

                      if (pickedFile != null) {
                        setState(() {
                          _image = File(pickedFile.path);
                        });
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
                        setState(() {
                          _image = File(pickedFile.path);
                        });
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
                tabs: [
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
  Widget allAlbums() {
    return InteractiveViewer(
      scaleEnabled: false,
      // onInteractionStart: (details) {
      //   scaleFactor = initialScale;
      // },
      maxScale: 2.0,
      onInteractionUpdate: (details) {
        setState(() {
          // print("pointer count : " + details.pointerCount.toString());
          scaleFactor = initialScale = details.scale;
          print("Scale = " + details.scale.toString());
        });
      },
      child: Container(
        padding: EdgeInsets.only(top: 15),
        child: GridView.count(
          // physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: scaleFactor == 1.0
              ? 3
              : double.parse(scaleFactor.toStringAsFixed(1)) > 1.0 &&
                      double.parse(scaleFactor.toStringAsFixed(1)) < 1.5
                  ? 2
                  : double.parse(scaleFactor.toStringAsFixed(1)) > 1.5 &&
                          double.parse(scaleFactor.toStringAsFixed(1)) < 2.0
                      ? 1
                      : double.parse(scaleFactor.toStringAsFixed(1)) < 1.0 &&
                              double.parse(scaleFactor.toStringAsFixed(1)) > 0.5
                          ? 4
                          : double.parse(scaleFactor.toStringAsFixed(1)) <=
                                      0.5 &&
                                  double.parse(scaleFactor.toStringAsFixed(1)) >
                                      0.0
                              ? 5
                              : 3,
          children: [
            ...allAlbumslist.map(
              (e) => GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AlbumsOfAlbumsScreen(e.title, e.id!);
                    //return PhotosScreen(e.title, e.id!, personlist)
                  }));
                },
                child: CustomAlbum(
                    e.title,
                    e.cover_photo!,
                    scaleFactor == 1.0
                        ? height! * 0.11
                        : double.parse(scaleFactor.toStringAsFixed(1)) > 1.0 &&
                                double.parse(scaleFactor.toStringAsFixed(1)) <
                                    1.5
                            ? height! * 0.18
                            : double.parse(scaleFactor.toStringAsFixed(1)) > 1.5 &&
                                    double.parse(scaleFactor.toStringAsFixed(1)) <
                                        2.0
                                ? height! * 0.40
                                : double.parse(scaleFactor.toStringAsFixed(1)) <= 0.5 &&
                                        double.parse(scaleFactor.toStringAsFixed(1)) >
                                            0.0
                                    ? height! * 0.08
                                    : double.parse(scaleFactor.toStringAsFixed(1)) < 1.0 &&
                                            double.parse(scaleFactor.toStringAsFixed(1)) >
                                                0.5
                                        ? height! * 0.1
                                        : height! * 0.11,
                    scaleFactor == 1.0
                        ? width! * 0.3
                        : double.parse(scaleFactor.toStringAsFixed(1)) > 1.0 &&
                                double.parse(scaleFactor.toStringAsFixed(1)) <
                                    1.5
                            ? width! * 0.45
                            : double.parse(scaleFactor.toStringAsFixed(1)) > 1.5 &&
                                    double.parse(scaleFactor.toStringAsFixed(1)) <
                                        2.0
                                ? width! * 0.85
                                : double.parse(scaleFactor.toStringAsFixed(1)) <=
                                            0.5 &&
                                        double.parse(scaleFactor.toStringAsFixed(1)) >
                                            0.0
                                    ? width! * 0.175
                                    : double.parse(scaleFactor.toStringAsFixed(1)) <
                                                1.0 &&
                                            double.parse(scaleFactor.toStringAsFixed(1)) > 0.5
                                        ? width! * 0.22
                                        : width! * 0.3),
                //85 100
              ),
            ),
          ],
        ),
      ),
    );
  }

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
          crossAxisCount: scaleFactor == 1.0 ? 3 : 2,
          children: [
            ...peopleAlbumsList.map(
              (e) => GestureDetector(
                onTap: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) {
                  //   return PhotosScreen(e.title, e.id!);
                  // }));
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AlbumsOfAlbumsScreen(e.title, e.id!);
                  }));
                },
                child: CustomAlbum(e.title, e.cover_photo!, height! * 0.11,
                    width! * 0.3), //85 100
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget eventAlbums() {
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: GridView.count(
        crossAxisCount: 3,
        children: [
          ...eventAlbumsList.map(
            (e) => GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AlbumsOfAlbumsScreen(e.title, e.id!);
                }));
              },
              child: CustomAlbum(e.title, e.cover_photo!, height! * 0.11,
                  width! * 0.3), //85 100
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
        crossAxisCount: 3,
        children: [
          ...labelAlbumsList.map(
            (e) => GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AlbumsOfAlbumsScreen(e.title, e.id!);
                }));
              },
              child: CustomAlbum(e.title, e.cover_photo!, height! * 0.11,
                  width! * 0.3), //85 100
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
        crossAxisCount: 3,
        children: [
          ...locationAlbumsList.map(
            (e) => GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AlbumsOfAlbumsScreen(e.title, e.id!);
                }));
              },
              child: CustomAlbum(e.title, e.cover_photo!, height! * 0.11,
                  width! * 0.3), //85 100
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
        crossAxisCount: 3,
        children: [
          ...dateAlbumsList.map(
            (e) => GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AlbumsOfAlbumsScreen(e.title, e.id!);
                }));
              },
              child: CustomAlbum(e.title, e.cover_photo!, height! * 0.11,
                  width! * 0.3), //85 100
            ),
          ),
        ],
      ),
    );
  }
}
