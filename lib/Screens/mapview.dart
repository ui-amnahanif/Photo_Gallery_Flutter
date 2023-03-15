import 'dart:async';
import 'package:flutter/material.dart';
import 'package:photo_gallery/Utilities/Global/global.dart';

class MapViewScreen extends StatelessWidget {
  // static const CameraPosition _kGooglePlex = CameraPosition(
  //   target: LatLng(37.42796133580664, -122.085749655962),
  //   zoom: 14.4746,
  // );
  // final Completer<GoogleMapController> _controller =
  //     Completer<GoogleMapController>();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Map View"),
        backgroundColor: primaryColor,
      ),
      // body: GoogleMap(
      //   initialCameraPosition: _kGooglePlex,
      //   onMapCreated: (GoogleMapController controller){
      //     _controller.complete(controller);
      //   },
      // ),
    );
  }
}
