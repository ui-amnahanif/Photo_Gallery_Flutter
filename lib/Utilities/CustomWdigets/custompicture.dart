import 'dart:io';

import 'package:flutter/material.dart';

class CustomPicture extends StatefulWidget {
  String? text;
  String image;
  double height;
  double width;
  CustomPicture(this.text, this.image, this.height, this.width);

  @override
  State<CustomPicture> createState() => _CustomPictureState();
}

class _CustomPictureState extends State<CustomPicture> {
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
      // color: Colors.amber,
      // height: 700,
      child: Column(
        children: [
          Container(
              // child: Image(image: AssetImage(image))
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(File(widget.image)),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(13),
              ),
              height: widget.height, //85,
              width: widget.width //100,
              ),
          // SizedBox(
          //     height: widget.text != null &&
          //             widget.width > width! * 0.175 &&
          //             widget.width > width! * 0.22
          //         ? 6
          //         : 0),

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
                overflow: TextOverflow.ellipsis,
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
