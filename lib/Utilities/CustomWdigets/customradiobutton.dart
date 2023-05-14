import 'package:flutter/material.dart';
import 'package:photo_gallery/Utilities/Global/global.dart';

class CustomRadioButton extends StatefulWidget {
  String title;
  String value;
  String groupValue;
  Function onChanged;
  CustomRadioButton(this.title, this.value, this.groupValue, this.onChanged);

  @override
  State<CustomRadioButton> createState() => _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadioButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio(
          activeColor: primaryColor,
          fillColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            return primaryColor;
          }),
          value: widget.value,
          groupValue: widget.groupValue,
          onChanged: (value) => widget.onChanged(value),
        ),
        Text(widget.title)
      ],
    );
  }
}
