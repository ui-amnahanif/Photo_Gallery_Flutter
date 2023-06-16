import 'package:flutter/material.dart';
import 'package:photo_gallery/Models/photo.dart';
import 'package:photo_gallery/Screens/photoScreen.dart';
import 'package:photo_gallery/Utilities/CustomWdigets/customalbum.dart';
import 'package:photo_gallery/Utilities/CustomWdigets/custompicture.dart';
import 'package:photo_gallery/Utilities/Global/global.dart';

class SimplePhotosScreen extends StatefulWidget {
  List<Photo> pplist;
  SimplePhotosScreen(this.pplist);

  @override
  State<SimplePhotosScreen> createState() => _SimplePhotosScreenState();
}

class _SimplePhotosScreenState extends State<SimplePhotosScreen> {
  List<Photo> plist = [];
  @override
  void initState() {
    // TODO: implement initState
    plist = widget.pplist;
    setState(() {});
  }

  double? width;
  double? height;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Photos'),
        backgroundColor: primaryColor,
      ),
      body: GridView.count(
        padding: EdgeInsets.only(top: height! * 0.020),
        crossAxisCount: 3,
        children: [
          ...plist.map(
            (e) => GestureDetector(
              onTap: () async {
                bool? isDeleted = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return PhotoScreen(
                    e,
                    onBack: () {},
                  );
                }));
                if (isDeleted != null) {
                  if (isDeleted) {
                    plist.remove(e);
                    //  getAllPhotos(photoToDisplaylist);
                    setState(() {});
                  }
                }
              },
              child:
                  CustomPicture(null, e.path, height! * 0.138, width! * 0.31),
            ),
          ),
        ],
      ),
    );
  }
}
