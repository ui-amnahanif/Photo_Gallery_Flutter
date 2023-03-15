import 'package:flutter/material.dart';
import 'package:photo_gallery/Models/album.dart';
import 'package:photo_gallery/Screens/photoScreen.dart';
import 'package:photo_gallery/Utilities/Global/global.dart';
import '../DBHelper/dbhelper.dart';
import '../Models/photo.dart';
import '../Utilities/CustomWdigets/customalbum.dart';

class PhotosScreen extends StatefulWidget {
  String albumTitle;
  int album_id;
  PhotosScreen(this.albumTitle, this.album_id);

  @override
  State<PhotosScreen> createState() => _PhotosScreenState();
}

class _PhotosScreenState extends State<PhotosScreen> {
  List<Photo> plist = [];
  double? width;
  double? height;
  @override
  void initState() {
    getAllPhotos();
  }

  getAllPhotos() async {
    plist = await DbHelper.instance.getPhotosOfAlbum(widget.album_id);
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
          ...plist.map(
            (e) => GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return PhotoScreen(e.title!, e.id!);
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
