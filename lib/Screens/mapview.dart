import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photo_gallery/Utilities/Global/global.dart';

class MapViewScreen extends StatefulWidget {
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(33.6412, 73.0635),
    zoom: 14.4746,
  );

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  // GoogleMapController _mapController;

  List<Marker> markers = [];
  double lat = 33.6412;
  double lng = 73.0635;
  late Marker myMarker;
  @override
  void initState() {
    // TODO: implement initState
    getCurrentLocation().then((value) {
      lat = value.latitude;
      lng = value.longitude;
    });
    myMarker = Marker(
        markerId: MarkerId('1'),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: "my position"));
    markers.add(myMarker);
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("location service is disabled");
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("location permissions are denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error("location permissions are permanently denied");
    }
    return Geolocator.getCurrentPosition();
  }

  Widget build(BuildContext context) {
    GoogleMapController _mapController;
    LatLng _centerLocation = LatLng(0, 0);
    return Scaffold(
      appBar: AppBar(
        title: Text("Map View"),
        backgroundColor: primaryColor,
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          // _mapController = controller;
        },
        onCameraMove: (position) {
          position.target.latitude;
        },
        // onCameraIdle: () async {
        //   if (_mapController != null) {
        //     LatLng coordinates = await _mapController.getCenter();
        //     print(
        //         "Latitude: ${coordinates.latitude}, Longitude: ${coordinates.longitude}");
        //   } else {
        //     print("Controller is not initialized yet");
        //   }
        // },
        onTap: (latlng) {
          myMarker = Marker(
              markerId: MarkerId('1'),
              position: LatLng(latlng.latitude, latlng.longitude),
              infoWindow: InfoWindow(title: "my position"));
          setState(() {
            markers.add(myMarker);
          });
        },
        markers: markers.toSet(),
        initialCameraPosition: MapViewScreen._kGooglePlex,
      ),
    );
  }
}
