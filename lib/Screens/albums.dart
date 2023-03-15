import 'package:flutter/material.dart';
import 'package:photo_gallery/DBHelper/dbhelper.dart';
import 'package:photo_gallery/Models/album.dart';
import 'package:photo_gallery/Screens/photosScreen.dart';
import 'package:photo_gallery/Utilities/CustomWdigets/customalbum.dart';
import 'package:photo_gallery/Utilities/Global/global.dart';

class AlbummsScreen extends StatefulWidget {
  @override
  State<AlbummsScreen> createState() => _AlbummsScreenState();
}

class _AlbummsScreenState extends State<AlbummsScreen>
    with TickerProviderStateMixin {
  List<Album> alist = [];
  List<Album> peopleAlbumList = [];
  List<Album> eventAlbumList = [];
  List<Album> locationAlbumList = [];
  double? width;
  double? height;
  @override
  void initState() {
    // TODO: implement initState
    // alist = Album.getAlbums();
    //setState(() {});
    getAllAlbums();
  }

  void getAllAlbums() async {
    alist = await DbHelper.instance.getAllAlbums();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    TabController _tabController = TabController(length: 4, vsync: this);
    return Scaffold(
      appBar: AppBar(
        title: Text("Albums"),
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
                tabs: [
                  Text(
                    "All",
                  ),
                  Text(
                    "People",
                  ),
                  Text(
                    "Event",
                  ),
                  Text(
                    "Location",
                  )
                ]),
          ),
          Container(
            width: width,
            height: height! * 0.71,
            child: TabBarView(controller: _tabController, children: [
              peoplealbums(),
              peoplealbums(),
              peoplealbums(),
              peoplealbums()
            ]),
          ),
        ],
      ),
    );
  }

  Widget peoplealbums() {
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: GridView.count(
        crossAxisCount: 3,
        children: [
          ...alist.map(
            (e) => GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return PhotosScreen(e.title, e.id);
                }));
              },
              child: CustomAlbum(e.title, e.cover_photo, height! * 0.11,
                  width! * 0.5), //85 100
            ),
          ),
        ],
      ),
    );
  }
}
