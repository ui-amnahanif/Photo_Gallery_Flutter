import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong2/latlong.dart' as LatLong;
import 'package:photo_gallery/DBHelper/dbhelper.dart';
import 'package:photo_gallery/Models/photo.dart';
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
  double _previousZoom = 14.4746;
  int markerDistance = 500;
  List<Marker> markers = [];
  double lat = 33.6412;
  double lng = 73.0635;
  // late Marker myMarker;
  @override
  void initState() {
    // TODO: implement initState
    // getCurrentLocation().then((value) {
    //   lat = value.latitude;
    //   lng = value.longitude;
    // });
    // myMarker = Marker(
    //     markerId: MarkerId('1'),
    //     position: LatLng(lat, lng),
    //     infoWindow: InfoWindow(title: "my position"));
    // markers.add(myMarker);
    getCurrentLatLngPosition();
  }

  getMarkers() async {
    List<List<Photo>> plist = await getDistanceGroups();
    markers = setMarkers(plist);
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

  getCurrentLatLngPosition() {
    getCurrentLocation().then((value) async {
      CameraPosition cameraPosition = CameraPosition(
        target: LatLng(value.latitude, value.longitude),
        zoom: 14.4746,
      );
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      setState(() {});
    });
  }

  Widget build(BuildContext context) {
    GoogleMapController _mapController;
    // Set<Circle> circles = Set.from([
    //   Circle(
    //       circleId: CircleId("0"),
    //       center: LatLng(lat, lng),
    //       radius: 1000,
    //       fillColor: Colors.blue.withOpacity(0.5),
    //       strokeColor: Colors.blue,
    //       strokeWidth: 2),
    // ]);
    LatLng _centerLocation = LatLng(0, 0);
    return Scaffold(
      appBar: AppBar(
        title: Text("Map View"),
        backgroundColor: primaryColor,
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        // circles: circles,

        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          // _mapController = controller;
        },
        markers: markers.toSet(),
        onCameraIdle: () async {
          final GoogleMapController controller = await _controller.future;
          final zoom = await controller.getZoomLevel();
          print('Zoom: $zoom');
          handleRegionChange(zoom);
          print('Maker Distance: $markerDistance');
          getMarkers();
        },

        // onTap: (latlng) {
        //   myMarker = Marker(
        //       markerId: MarkerId('1'),
        //       position: LatLng(latlng.latitude, latlng.longitude),
        //       infoWindow: InfoWindow(title: "my position"));
        //   setState(() {
        //     markers.add(myMarker);
        //   });
        // },

        initialCameraPosition: MapViewScreen._kGooglePlex,
      ),
    );
  }

  void handleRegionChange(double zoom) {
    if (zoom >= 14) {
      markerDistance = 500;
    } else if (zoom >= 13 && zoom < 14) {
      markerDistance = 1000;
    } else if (zoom >= 11 && zoom < 13) {
      markerDistance = 3000;
    } else if (zoom >= 9 && zoom < 11) {
      markerDistance = 8000;
    } else if (zoom >= 7 && zoom < 9) {
      markerDistance = 15000;
    } else if (zoom >= 5 && zoom < 7) {
      markerDistance = 25000;
    } else if (zoom >= 3 && zoom < 5) {
      markerDistance = 1000000;
    } else if (zoom >= 2 && zoom < 3) {
      markerDistance = 5000000;
    }
  }

  Future<List<List<Photo>>> getDistanceGroups() async {
    List<Photo> plist = await DbHelper.instance.getAllPhotoHavingLatLng();
    List<List<Photo>> photosWithinDistance =
        getPhotosWithinDistance(plist, markerDistance);
    print("List of List of Photos \n $photosWithinDistance");
    return photosWithinDistance;
  }

  List<List<Photo>> getPhotosWithinDistance(List<Photo> photos, int distance1) {
    final LatLong.Distance distance = new LatLong.Distance();
// Create a list of lists of photos.
    List<List<Photo>> photosWithinDistance = [];

// Iterate over the list of photos.
    for (Photo photo in photos) {
      if (!isPhotoPresent(photosWithinDistance, photo)) {
// Create a list of photos that are within the distance of the current photo.
        List<Photo> photosInDistance = photos.where((otherPhoto) {
          // Calculate the distance between the current photo and the other photo.
          final double meter = distance(LatLong.LatLng(photo.lat!, photo.lng!),
              LatLong.LatLng(otherPhoto.lat!, otherPhoto.lng!));
          // Return true if the distance between the photos is less than or equal to the distance that was passed in.
          return meter <= distance1;
        }).toList();
        photosWithinDistance.add(photosInDistance);
        // if (!photosWithinDistance.contains(photosInDistance)) {
        //   // Add the list of photos that are within the distance to the list of lists of photos.
        //   photosWithinDistance.add(photosInDistance);
        // }
      }
    }
// Return the list of lists of photos.
    return photosWithinDistance;
  }

  bool isPhotoPresent(List<List<Photo>> photos, Photo photo) {
    for (List<Photo> listOfPhotos in photos) {
      if (listOfPhotos.contains(photo)) {
        return true;
      }
    }
    return false;
  }

  List<Marker> setMarkers(List<List<Photo>> photos) {
    List<Marker> mlist = [];
    for (int i = 0; i < photos.length; i++) {
      Marker myMarker = Marker(
          markerId: MarkerId(i.toString()),
          position: LatLng(photos[i][0].lat!, photos[i][0].lng!),
          infoWindow: InfoWindow(title: "photo count = ${photos[i].length}"));
      mlist.add(myMarker);
    }
    return mlist;
  }
}
