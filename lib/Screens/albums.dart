import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery/Models/albums.dart';
import 'package:photo_gallery/Screens/camera.dart';
import 'package:photo_gallery/Screens/search.dart';
import 'package:photo_gallery/Utilities/CustomWdigets/customalbum.dart';
import 'package:photo_gallery/Utilities/CustomWdigets/custombutton.dart';
import 'package:photo_gallery/Utilities/Global/global.dart';

class AlbummsScreen extends StatefulWidget {
  @override
  State<AlbummsScreen> createState() => _AlbummsScreenState();
}

class _AlbummsScreenState extends State<AlbummsScreen> {
  List<Album> alist = [];
  @override
  void initState() {
    // TODO: implement initState
    alist = Album.getAlbums();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Albums"),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 15),
          child: Wrap(
            spacing: 14,
            runSpacing: 15,
            children: [
              ...alist.map(
                (e) => CustomAlbum(e.title, e.image, 85, 100),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
