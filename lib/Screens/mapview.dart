// import 'dart:async';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong2/latlong.dart' as LatLong;
import 'package:photo_gallery/DBHelper/dbhelper.dart';
import 'package:photo_gallery/Models/photo.dart';
import 'package:photo_gallery/Screens/albumsOfAlbums.dart';
import 'package:photo_gallery/Utilities/Global/global.dart';

class MapViewScreen extends StatefulWidget {
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(33.6412, 73.0635),
    zoom: 14.4746,
  );

  const MapViewScreen({super.key});

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

  Future<ui.Image> getImageFromPath(String imagePath) async {
    // final response = await http.get(Uri.parse(imageUrl));
    // final imageBytes = response.bodyBytes;
    File imageFile = File(imagePath);
    Uint8List imageBytes = imageFile.readAsBytesSync();
    final Completer<ui.Image> completer = Completer();

    ui.decodeImageFromList(imageBytes, (ui.Image img) {
      return completer.complete(img);
    });

    return completer.future;
  }

  Future<BitmapDescriptor> getMarkerIcon(
    String text,
    String imagePath,
  ) async {
    Size size = const Size(120, 120);

    var icon = await createCustomMarkerBitmapWithTextAndImage(
      text,
      imagePath,
      size,
    );

    return icon;
  }

  Future<BitmapDescriptor> createCustomMarkerBitmapWithTextAndImage(
    String text,
    String imagePath,
    Size size,
  ) async {
    TextSpan span = TextSpan(
      style: const TextStyle(
        height: 1.2,
        color: Colors.white,
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
      ),
      text: text,
    );

    TextPainter tp = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    tp.layout();

    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas canvas = Canvas(recorder);

    const double shadowWidth = 15.0;
    const double borderWidth = 3.0;
    const double imageOffset = shadowWidth + borderWidth;

    final Radius radius = Radius.circular(size.width / 2);

    final Paint shadowCirclePaint = Paint()
      ..color = primaryColor.withAlpha(180);
    // final Paint paint = Paint()..color = primaryColor;
    // final Radius radius = Radius.circular(size.width / 2);
    // canvas.clipPath(Path()
    //   ..moveTo(0, size.height / 2.7)
    //   ..lineTo(size.width / 2, size.height.toDouble())
    //   ..lineTo(size.width.toDouble(), size.height / 2.7)
    //   ..arcToPoint(
    //     Offset(size.width.toDouble(), 0),
    //   )
    //   ..arcToPoint(const Offset(0, 0)));
    // canvas.drawRRect(
    //   RRect.fromRectAndCorners(
    //     Rect.fromLTWH(0.0, 0.0, size.width.toDouble(), size.height.toDouble()),
    //     topLeft: radius,
    //     topRight: radius,
    //     bottomLeft: radius,
    //     bottomRight: radius,
    //   ),
    //   paint,
    // );

    // // Add shadow circle
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(size.width / 8, size.width / 2, size.width, size.height),
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: radius,
      ),
      shadowCirclePaint,
    );

    // TEXT BOX BACKGROUND
    Paint textBgBoxPaint = Paint()..color = primaryColor.withAlpha(180);

    Rect rect = Rect.fromLTWH(
      0,
      0,
      tp.width + 35,
      50,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(10.0)),
      textBgBoxPaint,
    );

    //ADD TEXT WITH ALIGN TO CANVAS
    tp.paint(canvas, const Offset(20.0, 5.0));

    /* Do your painting of the custom icon here, including drawing text, shapes, etc. */

    Rect oval = Rect.fromLTWH(35, 78, size.width - (imageOffset * 2),
        size.height - (imageOffset * 2));

    // ADD  PATH TO OVAL IMAGE
    canvas.clipPath(Path()..addOval(oval));

    ui.Image image = await getImageFromPath(imagePath);
    paintImage(canvas: canvas, image: image, rect: oval, fit: BoxFit.fitWidth);

    ui.Picture p = recorder.endRecording();
    final pngBytes = await (await p.toImage(300, 300))
        .toByteData(format: ui.ImageByteFormat.png);
    if (pngBytes == null) return BitmapDescriptor.defaultMarker;

    Uint8List data = Uint8List.view(pngBytes.buffer);
    return BitmapDescriptor.fromBytes(data);
  }

  @override
  void initState() {
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
    super.initState();
  }

  void reset() {
    setState(() {});
  }

  getMarkers() async {
    List<List<Photo>> plist = await getDistanceGroups();
    markers = await setMarkers(plist);
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

  Future<List<Marker>> setMarkers(List<List<Photo>> photos) async {
    List<Marker> mlist = [];
    for (int i = 0; i < photos.length; i++) {
      final photo = photos[i][0];
      final photoCount = photos[i].length;
      final imagePath = photo.path;
      Marker myMarker = Marker(
        markerId: MarkerId(i.toString()),
        // icon: await BitmapDescriptor.fromAssetImage(""),
        // anchor: Offset(0.5, 0.5),
        // icon: BitmapDescriptor.fromBytes(
        //     await _createMarkerImageFromText("hello")),
        position: LatLng(photo.lat!, photo.lng!),
        onTap: () async {
          String city = await DbHelper.instance
              .getCityFromLatLong(photo.lat!, photo.lng!);
          // await Navigator.push(context,
          //     MaterialPageRoute(builder: (context) {
          //   return AlbumsOfAlbumsScreen(photos[i], city);
          // }));
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AlbumsOfAlbumsScreen(photos[i], city,
                  onBack: () => reset())));
        },
        icon: await getMarkerIcon(
          "photo count ${photoCount.toString()}",
          imagePath,
        ),
        // infoWindow: InfoWindow(
        //     title: "photo count = ${photos[i].length}",
        //     onTap: () async {
        //       String city = await DbHelper.instance
        //           .getCityFromLatLong(photo.lat!, photo.lng!);
        //       // await Navigator.push(context,
        //       //     MaterialPageRoute(builder: (context) {
        //       //   return AlbumsOfAlbumsScreen(photos[i], city);
        //       // }));
        //       Navigator.of(context).push(MaterialPageRoute(
        //           builder: (context) => AlbumsOfAlbumsScreen(photos[i], city,
        //               onBack: () => reset())));
        //     }),
      );

      mlist.add(myMarker);
    }
    return mlist;
  }

  // Future<Uint8List> _createMarkerImageFromText(String text) async {
  //   // Create a TextPainter object to draw the text
  //   final TextPainter painter = TextPainter(
  //     text: TextSpan(
  //       text: text,
  //       style: TextStyle(fontSize: 20.0),
  //     ),
  //     textDirection: TextDirection.ltr,
  //   );
  //   painter.layout();

  //   // Create a PictureRecorder object to record a picture
  //   final PictureRecorder recorder = PictureRecorder();
  //   final Canvas canvas = Canvas(recorder);

  //   // Draw the text on the canvas at the top-left position
  //   painter.paint(canvas, Offset.zero);

  //   // End recording and generate an image
  //   final Picture picture = recorder.endRecording();
  //   final img =
  //       await picture.toImage(painter.width.toInt(), painter.height.toInt());
  //   final data = await img.toByteData(format: ImageByteFormat.png);

  //   // return the byte array as a Uint8List
  //   return data!.buffer.asUint8List();
  // }
}
