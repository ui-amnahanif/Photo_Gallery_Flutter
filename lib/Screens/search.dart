import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery/Utilities/CustomWdigets/customalbum.dart';
import 'package:photo_gallery/Utilities/CustomWdigets/customtextformfield.dart';
import 'package:photo_gallery/Utilities/Global/global.dart';

import '../Models/albums.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Album> alist = [];
  double? height;
  double? width;
  TextEditingController searchController = TextEditingController();
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Search",
        ),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: height! * 0.015,
            ),
            searchBar(),
            SizedBox(
              height: height! * 0.02,
            ),
            getalbums(),
            SizedBox(
              height: height! * 0.015,
            ),
            getpictures(),
          ],
        ),
      ),
    );
  }

  Row searchBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomTextFormField(
          50,
          300,
          "Search",
          searchController,
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.filter_alt,
            size: 40,
            color: primaryColor,
          ),
        ),
      ],
    );
  }

  Widget getalbums() {
    return Container(
      //color: Colors.amber,
      height: height! * 0.15,
      width: width,
      child: ListView.builder(
        itemCount: alist.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              CustomAlbum(alist[index].title, alist[index].image, 85, 100),
            ],
          );
        },
      ),
    );
  }

  Widget getpictures() {
    return Container(
      padding: EdgeInsets.only(left: width! * 0.02),
      height: height! * 0.85,
      width: width,
      child: Wrap(
        spacing: width! * 0.02, //7,
        runSpacing: width! * -0.03,
        children: [
          ...alist.map(
            (e) => CustomAlbum(null, e.image, 100, 110),
          ),
        ],
      ),
    );
  }
}
