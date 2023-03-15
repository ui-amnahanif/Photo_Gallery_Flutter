import 'package:flutter/material.dart';
import 'package:photo_gallery/Utilities/Global/global.dart';

class CustomTextFormField extends StatefulWidget {
  double height;
  double width;
  String? hintText;
  TextEditingController cont;

  CustomTextFormField(
    this.height,
    this.width,
    this.hintText,
    this.cont,
  );

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Container(
          width: widget.width,
          height: widget.height,
          child: TextFormField(
            style: TextStyle(fontSize: 18),
            cursorColor: primaryColor,
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  borderSide: BorderSide(
                    width: 2,
                    color: primaryColor,
                  )),
              hintText: widget.hintText != null ? widget.hintText : null,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide: BorderSide(
                  width: 2,
                  color: primaryColor,
                ),
              ),
            ),
            //  onChanged: (value) => widget.func(),
            // onChanged: (value) {
            //   final controller = widget.cont;
            // },
            controller: widget.cont,
          ),
        ),
      ],
    );
  }
}
