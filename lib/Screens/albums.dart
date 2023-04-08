import 'package:flutter/material.dart';
import 'package:photo_gallery/DBHelper/dbhelper.dart';
import 'package:photo_gallery/Models/album.dart';
import 'package:photo_gallery/Screens/albumsOfAlbums.dart';
import 'package:photo_gallery/Screens/photosScreen.dart';
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
  @override
  void initState() {
    getAllAlbums();
  }

  void getAllAlbums() async {
    allAlbumslist = await DbHelper.instance.getAllAlbums();
    peopleAlbumsList = await DbHelper.instance.getPeopleAlbums();
    eventAlbumsList = await DbHelper.instance.getEventAlbums();
    labelAlbumsList = await DbHelper.instance.getLabelAlbums();
    setState(() {});
  }

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
              allAlbums(),
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

  Widget allAlbums() {
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: GridView.count(
        crossAxisCount: 3,
        children: [
          ...allAlbumslist.map(
            (e) => GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AlbumsOfAlbumsScreen(e.title, e.id!);
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

  Widget peopleAlbums() {
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: GridView.count(
        crossAxisCount: 3,
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
                  return AlbumsOfAlbumsScreen(e.title, e.id!);
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
                  return AlbumsOfAlbumsScreen(e.title, e.id!);
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
                  return AlbumsOfAlbumsScreen(e.title, e.id!);
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
          ...dateAlbumsList.map(
            (e) => GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AlbumsOfAlbumsScreen(e.title, e.id!);
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
