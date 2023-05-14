import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photo_gallery/Models/photo.dart';
import 'package:photo_gallery/Utilities/Global/global.dart';

class FullMapScreen extends StatefulWidget {
  Photo photo;
  FullMapScreen(this.photo);
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(33.6412, 73.0635),
    zoom: 14.4746,
  );
  @override
  State<FullMapScreen> createState() => _FullMapScreenState();
}

class _FullMapScreenState extends State<FullMapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  List<Marker> markers = [];
  Marker myMarker = Marker(
      markerId: MarkerId('1'),
      position: LatLng(33.6412, 73.0635),
      infoWindow: InfoWindow(title: "my position"));
  @override
  void initState() {
    // TODO: implement initState
    if (widget.photo.lat == null) {
      getCurrentLatLng();
    } else {
      getPhotoLatLng();
    }
    markers.add(myMarker);
  }

  late double currentLat;
  late double currentLng;
  getCurrentLatLng() {
    getCurrentLocation().then((value) async {
      myMarker = Marker(
          markerId: MarkerId('1'),
          position: LatLng(value.latitude, value.longitude),
          infoWindow: InfoWindow(title: "current position"));
      markers.add(myMarker);
      CameraPosition cameraPosition = CameraPosition(
        target: LatLng(value.latitude, value.longitude),
        zoom: 14.4746,
      );
      currentLat = value.latitude;
      currentLng = value.longitude;
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      setState(() {});
    });
  }

  getPhotoLatLng() async {
    myMarker = Marker(
        markerId: MarkerId('1'),
        position: LatLng(widget.photo.lat!, widget.photo.lng!),
        infoWindow: InfoWindow(title: "current position"));
    markers.add(myMarker);
    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(widget.photo.lat!, widget.photo.lng!),
      zoom: 14.4746,
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    setState(() {});
  }

  Future<Position> getCurrentLocation() async {
    // bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    // if (!serviceEnabled) {
    //   return Future.error("location service is disabled");
    // }
    // LocationPermission permission = await Geolocator.checkPermission();
    // if (permission == LocationPermission.denied) {
    //   permission = await Geolocator.requestPermission();
    //   if (permission == LocationPermission.denied) {
    //     return Future.error("location permissions are denied");
    //   }
    // }
    // if (permission == LocationPermission.deniedForever) {
    //   return Future.error("location permissions are permanently denied");
    // }
    // return Geolocator.getCurrentPosition();
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print("Error" + error.toString());
    });
    return Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Map View"),
        backgroundColor: primaryColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (widget.photo.lat == null) {
            widget.photo.lat = currentLat;
            widget.photo.lng = currentLng;
          }
          Navigator.pop(context, widget.photo);
        },
        backgroundColor: primaryColor,
        child: Icon(Icons.check),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        onTap: (latlng) {
          myMarker = Marker(
              markerId: MarkerId('1'),
              position: LatLng(latlng.latitude, latlng.longitude),
              infoWindow: InfoWindow(title: "my position"));
          setState(() {
            widget.photo.lat = latlng.latitude;
            widget.photo.lng = latlng.longitude;
            markers.add(myMarker);
          });
        },
        markers: markers.toSet(),
        initialCameraPosition: FullMapScreen._kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
