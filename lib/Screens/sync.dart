import 'package:flutter/material.dart';
import 'package:photo_gallery/Models/photo.dart';
import 'package:photo_gallery/Utilities/CustomWdigets/custombutton.dart';
import 'package:photo_gallery/Utilities/Global/global.dart';

class SyncScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sync Now"),
        backgroundColor: primaryColor,
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Icon(
                Icons.sync,
                size: 200,
                color: primaryColor,
              ),
              const SizedBox(
                height: 30,
              ),
              CustomButton("Sync Now", 50, 180, primaryColor, primaryColor,
                  Colors.white, Photo.syncingPhoto)
            ],
          ),
        ),
      ),
    );
  }
}
