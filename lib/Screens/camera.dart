import 'package:flutter/material.dart';

class CameraScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Camera"),
      ),
      body: Container(
        child: Center(
          child: Text(
            "Camera Screen",
            style: TextStyle(fontSize: 30),
          ),
        ),
      ),
    );
  }
}
