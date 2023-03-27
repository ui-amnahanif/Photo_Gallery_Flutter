import 'package:flutter/material.dart';
import 'package:photo_gallery/Screens/addEditDetailsScreen.dart';
import 'package:photo_gallery/Screens/viewDetailsScreen.dart';
import 'package:photo_gallery/Utilities/Global/global.dart';
import '../DBHelper/dbhelper.dart';
import '../Models/photo.dart';
import '../Utilities/CustomWdigets/customalbum.dart';

class PhotoScreen extends StatefulWidget {
  String photoTitle;
  int photo_id;
  int album_id;
  PhotoScreen(this.photoTitle, this.photo_id, this.album_id);

  @override
  State<PhotoScreen> createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  Photo photo = Photo();
  double? width;
  double? height;
  @override
  void initState() {
    // TODO: implement initState
    //alist = Album.getAlbums();
    getPhoto();
  }

  getPhoto() async {
    photo = await DbHelper.instance.getPhotoById(widget.photo_id);
    setState(() {});
  }

  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.photoTitle),
          backgroundColor: primaryColor,
          actions: [
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem<int>(
                  value: 0,
                  child: Text("Delete"),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: Text("View Details"),
                ),
                PopupMenuItem<int>(
                  value: 2,
                  child: Text("Edit Details"),
                ),
              ],
              onSelected: (item) => SelectedItem(context, item),
            )
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(photo.path), fit: BoxFit.contain),
          ),
        ));
  }

  SelectedItem(BuildContext context, int item) {
    switch (item) {
      case 0:
        print("Delete");
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return viewDetailsScreen(widget.photo_id);
        }));
        print("View Details");
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return AddEditDetailsScreen(widget.photo_id, widget.album_id);
        }));
        print("Edit Details");
        break;
    }
  }
}
