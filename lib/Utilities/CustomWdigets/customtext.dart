import 'package:flutter/material.dart';

class CustomText extends StatefulWidget {
  String? text;
  double? leftsidewidth;
  double? rightsidewidth;
  FontWeight? fontweight;
  double? height;

  CustomText(this.text, this.leftsidewidth, this.rightsidewidth,
      this.fontweight, this.height);

  @override
  State<CustomText> createState() => _CustomTextState();
}

class _CustomTextState extends State<CustomText> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.leftsidewidth == null && widget.rightsidewidth == null)
          Text(
            widget.text!,
            style: TextStyle(
                fontSize: 19,
                fontWeight: widget.fontweight,
                height: 19 * widget.height!),
          )
        else if (widget.leftsidewidth != null && widget.rightsidewidth == null)
          Row(
            children: [
              SizedBox(
                width: widget.leftsidewidth,
              ),
              Text(
                widget.text!,
                style: TextStyle(
                    fontSize: 19,
                    fontWeight: widget.fontweight,
                    height: 19 * widget.height!),
              ),
              SizedBox(
                width: widget.rightsidewidth,
              ),
            ],
          )
        else if (widget.leftsidewidth == null && widget.rightsidewidth != null)
          Row(
            children: [
              Text(
                widget.text!,
                style: TextStyle(
                    fontSize: 19,
                    fontWeight: widget.fontweight,
                    height: 19 * widget.height!),
              ),
              SizedBox(
                width: widget.rightsidewidth,
              )
            ],
          )
        else
          Row(
            children: [
              SizedBox(
                width: widget.leftsidewidth,
              ),
              Text(
                widget.text!,
                style: TextStyle(
                    fontSize: 19,
                    fontWeight: widget.fontweight,
                    height: 19 * widget.height!),
              ),
              SizedBox(
                width: widget.rightsidewidth,
              ),
            ],
          )
      ],
    );
  }
}
