import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:photo_gallery/Models/photo.dart';
import 'package:photo_gallery/Screens/photosScreen.dart';
import 'package:photo_gallery/Utilities/Global/global.dart';

import '../DBHelper/dbhelper.dart';
import '../Models/album.dart';
import '../Models/event.dart';
import '../Models/person.dart';
import '../Utilities/CustomWdigets/customalbum.dart';

class AlbumsOfAlbumsScreen extends StatefulWidget {
  String albumTitle;
  int album_id;
  AlbumsOfAlbumsScreen(this.albumTitle, this.album_id);

  @override
  State<AlbumsOfAlbumsScreen> createState() => _AlbumsOfAlbumsScreenState();
}

class _AlbumsOfAlbumsScreenState extends State<AlbumsOfAlbumsScreen>
    with TickerProviderStateMixin {
  List<Photo> plist = [];
  List<Album> alist = [];
  List<Album> peopleAlbumsList = [];
  List<Album> eventAlbumsList = [];
  List<Album> locationAlbumsList = [];
  List<Album> labelAlbumsList = [];
  List<Album> dateAlbumsList = [];
  List<Person> personList = [];
  List<Event> eventList = [];
  List<String> labelList = [];
  List<String> dateList = [];
  //locationlist
  double? width;
  double? height;

  @override
  void initState() {
    getAllAlbums();
  }

  void getAllAlbums() async {
    plist = await DbHelper.instance.getPhotosOfAlbum(widget.album_id);
    alist = await DbHelper.instance.getAlbumsOfPhotos(plist);
    personList = await DbHelper.instance.getAllPersons();
    eventList = await DbHelper.instance.getAllEvents();
    labelList = await DbHelper.instance.getAllLabels();
    for (int i = 0; i < alist.length; i++) {
      personList.forEach((element) {
        if (element.name == alist[i].title) {
          peopleAlbumsList.add(alist[i]);
        }
      });
      eventList.forEach((element) {
        if (element.name == alist[i].title) {
          eventAlbumsList.add(alist[i]);
        }
      });
      labelList.forEach((element) {
        if (element == alist[i].title) {
          labelAlbumsList.add(alist[i]);
        }
      });
      // for location and for date too
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    TabController _tabController = TabController(length: 5, vsync: this);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.albumTitle),
        backgroundColor: primaryColor,
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: Icon(Icons.camera_alt),
      //   elevation: 18,
      //   backgroundColor: primaryColor,
      // ),
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
            child: TabBarView(controller: _tabController, children: [
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
  //   return Container(
  //     padding: EdgeInsets.only(top: 15),
  //     child: GridView.count(
  //       crossAxisCount: 3,
  //       children: [
  //         ...alist.map(
  //           (e) => GestureDetector(
  //             onTap: () {
  //               Navigator.push(context, MaterialPageRoute(builder: (context) {
  //                 return PhotosScreen(e.title, e.id!, plist);
  //               }));
  //             },
  //             child: CustomAlbum(e.title, e.cover_photo, height! * 0.11,
  //                 width! * 0.3), //85 100
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget peopleAlbums() {
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: GridView.count(
        crossAxisCount: 3,
        children: [
          ...peopleAlbumsList.map(
            (e) => GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return PhotosScreen(e.title, e.id!, plist);
                }));
              },
              child: CustomAlbum(e.title, e.cover_photo, height! * 0.11,
                  width! * 0.3), //85 100
            ),
          ),
        ],
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
                  return PhotosScreen(e.title, e.id!, plist);
                }));
              },
              child: CustomAlbum(e.title, e.cover_photo, height! * 0.11,
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
                  return PhotosScreen(e.title, e.id!, plist);
                }));
              },
              child: CustomAlbum(e.title, e.cover_photo, height! * 0.11,
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
                  return PhotosScreen(e.title, e.id!, plist);
                }));
              },
              child: CustomAlbum(e.title, e.cover_photo, height! * 0.11,
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
          ...locationAlbumsList.map(
            (e) => GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return PhotosScreen(e.title, e.id!, plist);
                }));
              },
              child: CustomAlbum(e.title, e.cover_photo, height! * 0.11,
                  width! * 0.3), //85 100
            ),
          ),
        ],
      ),
    );
  }
}
