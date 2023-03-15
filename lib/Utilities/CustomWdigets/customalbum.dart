import 'package:flutter/material.dart';

class CustomAlbum extends StatefulWidget {
  String? text;
  String image;
  double height;
  double width;
  CustomAlbum(this.text, this.image, this.height, this.width);

  @override
  State<CustomAlbum> createState() => _CustomAlbumState();
}

class _CustomAlbumState extends State<CustomAlbum> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
              // child: Image(image: AssetImage(image)),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(widget.image),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(13),
              ),
              height: widget.height, //85,
              width: widget.width //100,
              ),
          SizedBox(height: widget.text != null ? 6 : 0),
          Text(
            widget.text != null ? widget.text! : " ",
            style: const TextStyle(fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}
