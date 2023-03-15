import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  String text;
  double height;
  double width;
  Color color;
  Color borderColor;
  Color textColor;
  Function func;
  CustomButton(this.text, this.height, this.width, this.color, this.borderColor,
      this.textColor, this.func);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          border: Border.all(color: widget.borderColor, width: 2),
          color: widget.color,
        ),
        width: widget.width,
        height: widget.height,
        child: Center(
          child: Text(
            widget.text,
            textScaleFactor: 1.5,
            style: TextStyle(
              color: widget.textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      onTap: () => widget.func(),
    );
  }
}
