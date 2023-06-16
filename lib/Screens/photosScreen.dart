import 'package:flutter/material.dart';
import 'package:photo_gallery/Screens/photoScreen.dart';
import 'package:photo_gallery/Utilities/Global/global.dart';
import '../DBHelper/dbhelper.dart';
import '../Models/photo.dart';
import '../Utilities/CustomWdigets/customalbum.dart';
import '../Utilities/CustomWdigets/custompicture.dart';

class PhotosScreen extends StatefulWidget {
  String albumTitle;
  int album_id;
  List<Photo> photolist;
  String type;
  PhotosScreen(this.albumTitle, this.album_id, this.photolist, this.type,
      {required Function() onBack});

  @override
  State<PhotosScreen> createState() => _PhotosScreenState();
}

class _PhotosScreenState extends State<PhotosScreen> {
  List<Photo> plist = [];
  //List<Photo> photoToDisplaylist = [];
  double? width;
  double? height;
  @override
  void initState() {
    getAllPhotos(widget.photolist, widget.album_id, widget.albumTitle);
  }

  void reset() {
    getAllPhotos(widget.photolist, widget.album_id, widget.albumTitle);
  }

  getAllPhotos(List<Photo> pplist, int id, String title) async {
    // plist = await DbHelper.instance
    //     .getPhotosOfAlbum(widget.album_id, widget.albumTitle);
    // for (int i = 0; i < widget.photolist.length; i++) {
    //   for (int j = 0; j < plist.length; j++) {
    //     if (widget.photolist[i].id == plist[j].id) {
    //       photoToDisplaylist.add(plist[j]);
    //     }
    //   }
    // }

    if (widget.type == "person") {
      plist = await Photo.getPersonPhotosFromPhotosList(pplist, id);
    } else if (widget.type == "event") {
      plist = await Photo.getEventnPhotosFromPhotosList(pplist, id);
    } else if (widget.type == "date") {
      plist = await Photo.getDatesPhotosFromPhotosList(pplist, id);
    } else if (widget.type == "label") {
      plist = await Photo.getLabelPhotosFromPhotosList(pplist, title);
    } else if (widget.type == "location") {
      plist = await Photo.getLocationPhotosFromPhotosList(pplist, title);
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
        padding: EdgeInsets.only(top: height! * 0.010),
        crossAxisCount: 2,
        children: [
          ...plist.map(
            (e) => GestureDetector(
              onTap: () async {
                bool? isDeleted = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  // return PhotoScreen(e.title!, e.id!, widget.album_id);
                  return PhotoScreen(
                    e,
                    onBack: () {},
                  );
                }));
                if (isDeleted != null) {
                  if (isDeleted) {
                    plist.remove(e);
                    //  getAllPhotos(photoToDisplaylist);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Photo deleted successfully'),
                      ),
                    );
                    setState(() {});
                  }
                }
              },
              child: CustomPicture(
                  e.title, e.path, height! * 0.19, width! * 0.43), //0.138 0.31
            ),
          ),
        ],
      ),
    );
  }
}
