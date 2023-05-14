import 'package:flutter/material.dart';
import 'package:photo_gallery/Screens/photoScreen.dart';
import 'package:photo_gallery/Utilities/Global/global.dart';
import '../DBHelper/dbhelper.dart';
import '../Models/photo.dart';
import '../Utilities/CustomWdigets/customalbum.dart';

class PhotosScreen extends StatefulWidget {
  String albumTitle;
  int album_id;
  List<Photo> photolist;
  PhotosScreen(this.albumTitle, this.album_id, this.photolist);

  @override
  State<PhotosScreen> createState() => _PhotosScreenState();
}

class _PhotosScreenState extends State<PhotosScreen> {
  List<Photo> plist = [];
  List<Photo> photoToDisplaylist = [];
  double? width;
  double? height;
  @override
  void initState() {
    getAllPhotos();
  }

  getAllPhotos() async {
    plist = await DbHelper.instance
        .getPhotosOfAlbum(widget.album_id, widget.albumTitle);
    for (int i = 0; i < widget.photolist.length; i++) {
      for (int j = 0; j < plist.length; j++) {
        if (widget.photolist[i].id == plist[j].id) {
          photoToDisplaylist.add(plist[j]);
        }
      }
    }
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
        padding: EdgeInsets.only(top: height! * 0.020),
        crossAxisCount: 3,
        children: [
          ...photoToDisplaylist.map(
            (e) => GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return PhotoScreen(e.title!, e.id!, widget.album_id);
                }));
              },
              child: CustomAlbum(null, e.path, height! * 0.138, width! * 0.31),
            ),
          ),
        ],
      ),
    );
  }
}
