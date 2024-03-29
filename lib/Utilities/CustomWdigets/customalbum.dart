import 'dart:io';

import 'package:flutter/material.dart';

class CustomAlbum extends StatefulWidget {
  String? text;
  int photoCount;
  String image;
  double height;
  double width;
  CustomAlbum(this.text, this.image, this.height, this.width, this.photoCount);

  @override
  State<CustomAlbum> createState() => _CustomAlbumState();
}

class _CustomAlbumState extends State<CustomAlbum> {
  double? height;
  double? width;
  bool is4gridcount = false;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    if (widget.width == width! * 0.22) {
      is4gridcount = true;
    }
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 40, 0),
            child: Text(
              widget.text != null && widget.width > width! * 0.175
                  ? "photo count = ${widget.photoCount}"
                  : " ",
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
              // child: Image(image: AssetImage(image))
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      "assets/images/folderimg.png"), // FileImage(File(widget.image)),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(13),
              ),
              height: widget.height, //85,
              width: widget.width //100,
              ),
          SizedBox(
              height: widget.text != null &&
                      widget.width > width! * 0.175 &&
                      widget.width > width! * 0.22
                  ? 6
                  : 0),
          Container(
            height: widget.text != null &&
                    widget.width > width! * 0.175 &&
                    widget.width != width! * 0.22
                ? 30
                : widget.width == width! * 0.22
                    ? 10
                    : 0,
            child: Text(
              widget.text != null && widget.width > width! * 0.175
                  ? widget.text!
                  : " ",
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
