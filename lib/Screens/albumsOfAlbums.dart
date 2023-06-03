import 'package:flutter/material.dart';
import 'package:photo_gallery/Models/photo.dart';
import 'package:photo_gallery/Screens/photoScreen.dart';
import 'package:photo_gallery/Screens/photosScreen.dart';
import 'package:photo_gallery/Utilities/Global/global.dart';
import '../Models/album.dart';
import '../Utilities/CustomWdigets/customalbum.dart';

class AlbumsOfAlbumsScreen extends StatefulWidget {
  // String albumTitle;
  // int album_id;
  // String type;
  // AlbumsOfAlbumsScreen(this.albumTitle, this.album_id, this.type);
  List<Photo> plist;
  String title;
  AlbumsOfAlbumsScreen(this.plist, this.title, {required Function() onBack});

  @override
  State<AlbumsOfAlbumsScreen> createState() => _AlbumsOfAlbumsScreenState();
}

class _AlbumsOfAlbumsScreenState extends State<AlbumsOfAlbumsScreen>
    with TickerProviderStateMixin {
  // List<Photo> plist = [];
  //List<Album> alist = [];
  List<Album> peopleAlbumsList = [];
  List<Album> eventAlbumsList = [];
  List<Album> locationAlbumsList = [];
  List<Album> labelAlbumsList = [];
  List<Album> dateAlbumsList = [];
  // List<Person> personList = [];
  //List<Event> eventList = [];
  //List<String> labelList = [];
  //locationlist
  double? width;
  double? height;

  @override
  void initState() {
    getAllAlbums();
  }

  void reset() {
    getAllAlbums();
  }

  void getAllAlbums() async {
    // if (widget.type == "person") {
    //   plist = await DbHelper.instance.getPhotosofPersonById(widget.album_id);
    // } else if (widget.type == "event") {
    //   plist = await DbHelper.instance.getPhotosofEventById(widget.album_id);
    // } else if (widget.type == "date") {
    //   plist = await DbHelper.instance.getPhotosofDateByPhotoId(widget.album_id);
    // } else if (widget.type == "label") {
    //   plist =
    //       await DbHelper.instance.getPhotosofLabelByTitle(widget.albumTitle);
    // } else if (widget.type == "location") {
    //   plist =
    //       await DbHelper.instance.getPhotosofLocationByTitle(widget.albumTitle);
    // }
    peopleAlbumsList = await Album.getPersonsAlbumsByPhotos(widget.plist);
    eventAlbumsList = await Album.getEventsAlbumsByPhotos(widget.plist);
    dateAlbumsList = await Album.getDatesAlbumsByPhotos(widget.plist);
    labelAlbumsList = await Album.getLabelsAlbumsByPhotos(widget.plist);
    locationAlbumsList = await Album.getLocationsAlbumsByPhotos(widget.plist);
    setState(() {});
    // plist = await DbHelper.instance
    //     .getPhotosOfAlbum(widget.album_id, widget.albumTitle);
    // alist = await DbHelper.instance.getAlbumsOfPhotos(plist);
    // personList = await DbHelper.instance.getAllPersons();
    // eventList = await DbHelper.instance.getAllEvents();
    // labelList = await DbHelper.instance.getAllLabels();
    // for (int i = 0; i < alist.length; i++) {
    //   personList.forEach((element) {
    //     if (element.name == alist[i].title) {
    //       peopleAlbumsList.add(alist[i]);
    //     }
    //   });
    //   eventList.forEach((element) {
    //     if (element.name == alist[i].title) {
    //       eventAlbumsList.add(alist[i]);
    //     }
    //   });
    //   labelList.forEach((element) {
    //     if (element == alist[i].title) {
    //       labelAlbumsList.add(alist[i]);
    //     }
    //   });
    //   // for location and for date too
    // }
    // dateAlbumsList = getDatesAlbums();
    // setState(() {});
  }

  // List<Album> getDatesAlbums() {
  //   List<Album> datesAlbumlist = [];
  //   List<String> distinctDates = [];
  //   Album a;
  //   late DateTime dateTime;
  //   for (var photo in plist) {
  //     String date =
  //         photo.date_taken!.replaceFirst(':', '-').replaceFirst(':', '-');
  //     ;
  //     dateTime = DateTime.parse(date);
  //     String dateFormatted =
  //         "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
  //     if (!distinctDates.contains(dateFormatted)) {
  //       distinctDates.add(dateFormatted);
  //     }
  //   }
  //   for (int i = 0; i < distinctDates.length; i++) {
  //     a = Album();
  //     a.id = int.parse(distinctDates[i].replaceAll("-", ""));
  //     a.title = distinctDates[i];
  //     Photo photoOfDate = plist.firstWhere(
  //       (photo) =>
  //           DateTime.parse(photo.date_taken!
  //                       .replaceFirst(':', '-')
  //                       .replaceFirst(':', '-'))
  //                   .year ==
  //               DateTime.parse(distinctDates[i]).year &&
  //           DateTime.parse(photo.date_taken!
  //                       .replaceFirst(':', '-')
  //                       .replaceFirst(':', '-'))
  //                   .month ==
  //               DateTime.parse(distinctDates[i]).month &&
  //           DateTime.parse(photo.date_taken!
  //                       .replaceFirst(':', '-')
  //                       .replaceFirst(':', '-'))
  //                   .day ==
  //               DateTime.parse(distinctDates[i]).day,
  //     );
  //     if (photoOfDate != null) {
  //       a.cover_photo = photoOfDate.path;
  //     }
  //     datesAlbumlist.add(a);
  //   }

  //   return datesAlbumlist;
  // }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    TabController _tabController = TabController(length: 5, vsync: this);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
              onTap: () async {
                await Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return PhotosScreen(
                    e.title,
                    e.id!,
                    widget.plist,
                    "person",
                    onBack: () {},
                  );
                }));
                getAllAlbums();
              },
              child: CustomAlbum(e.title, e.cover_photo!, height! * 0.11,
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
              onTap: () async {
                await Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return PhotosScreen(
                    e.title,
                    e.id!,
                    widget.plist,
                    "event",
                    onBack: () {},
                  );
                }));
                getAllAlbums();
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
              onTap: () async {
                await Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return PhotosScreen(
                    e.title,
                    e.id!,
                    widget.plist,
                    "label",
                    onBack: () {},
                  );
                }));
                getAllAlbums();
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
              onTap: () async {
                await Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return PhotosScreen(
                    e.title,
                    e.id!,
                    widget.plist,
                    "location",
                    onBack: () {},
                  );
                }));
                getAllAlbums();
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
              onTap: () async {
                await Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return PhotosScreen(
                    e.title,
                    e.id!,
                    widget.plist,
                    "date",
                    onBack: () {},
                  );
                }));
                getAllAlbums();
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
