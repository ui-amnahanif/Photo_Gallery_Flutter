import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery/Models/albums.dart';
import 'package:photo_gallery/Screens/camera.dart';
import 'package:photo_gallery/Screens/photosScreen.dart';
import 'package:photo_gallery/Screens/search.dart';
import 'package:photo_gallery/Utilities/CustomWdigets/customalbum.dart';
import 'package:photo_gallery/Utilities/CustomWdigets/custombutton.dart';
import 'package:photo_gallery/Utilities/Global/global.dart';

class AlbummsScreen extends StatefulWidget {
  @override
  State<AlbummsScreen> createState() => _AlbummsScreenState();
}

class _AlbummsScreenState extends State<AlbummsScreen>
    with TickerProviderStateMixin {
  List<Album> alist = [];
  double? width;
  double? height;
  @override
  void initState() {
    // TODO: implement initState
    alist = Album.getAlbums();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    TabController _tabController = TabController(length: 3, vsync: this);
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
            child: TabBarView(
                controller: _tabController,
                children: [peoplealbums(), peoplealbums(), peoplealbums()]),
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
                    return PhotoScreen(e.title);
                  }));
                },
                child: CustomAlbum(e.title, e.image, 85, 100)),
          ),
          ...alist.map(
            (e) => CustomAlbum(e.title, e.image, 85, 100),
          ),
        ],
      ),
    );

    // return Padding(
    //   padding: const EdgeInsets.only(top: 15, left: 15),
    //   child: Wrap(
    //     spacing: 14,
    //     runSpacing: 15,
    //     children: [
    //       ...alist.map(
    //         (e) => CustomAlbum(e.title, e.image, 85, 100),
    //       ),
    //       ...alist.map(
    //         (e) => CustomAlbum(e.title, e.image, 85, 100),
    //       ),
    //     ],
    //   ),
    // );
  }
}
