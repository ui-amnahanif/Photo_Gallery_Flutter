import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:photo_gallery/Models/albums.dart';
import 'package:photo_gallery/Utilities/Global/global.dart';

import '../Utilities/CustomWdigets/customalbum.dart';

class PhotoScreen extends StatefulWidget {
  String albumTitle;
  PhotoScreen(this.albumTitle);

  @override
  State<PhotoScreen> createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  List<Album> alist = [];
  double? width;
  double? height;
  @override
  void initState() {
    // TODO: implement initState
    alist = Album.getAlbums();
    setState(() {});
  }

  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.albumTitle),
        backgroundColor: primaryColor,
      ),
      body: GridView.count(
        padding: EdgeInsets.only(top: 15),
        crossAxisCount: 3,
        children: [
          ...alist.map(
            (e) => CustomAlbum(null, e.image, 100, 115),
          ),
          ...alist.map(
            (e) => CustomAlbum(null, e.image, 100, 115),
          ),
        ],
      ),
    );
  }
}
