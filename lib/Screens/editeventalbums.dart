import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photo_gallery/Models/photo.dart';
import 'package:photo_gallery/Utilities/Global/global.dart';

import '../Models/event.dart';
import '../Utilities/CustomWdigets/custombutton.dart';
import '../Utilities/CustomWdigets/customtext.dart';
import '../Utilities/CustomWdigets/customtextformfield.dart';

class EditEventAlbum extends StatefulWidget {
  Event eve;
  EditEventAlbum(this.eve);
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(33.6412, 73.0635),
    zoom: 14.4746,
  );

  @override
  State<EditEventAlbum> createState() => _EditEventAlbumState();
}

class _EditEventAlbumState extends State<EditEventAlbum> {
  double? height;
  double? width;
  double? lat;
  double? lng;
  TextEditingController eventController = TextEditingController();
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
    eventController.text = widget.eve.name;
    getCurrentLatLng();
  }

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
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      setState(() {});
    });
  }

  Future<Position> getCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print("Error" + error.toString());
    });
    return Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Edit Event Album"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText("Event", 10, null, FontWeight.w500, 0.1),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                child: CustomTextFormField(
                    height! * 0.052, width! * 0.90, "", eventController, null),
              ),
              CustomText("Location", 10, null, FontWeight.w500, 0.1),
              const SizedBox(
                height: 5,
              ),
              Container(
                height: height! * 0.63,
                width: width! * 0.95,
                child: GoogleMap(
                  mapType: MapType.normal,
                  onTap: (latlng) {
                    myMarker = Marker(
                        markerId: MarkerId('1'),
                        position: LatLng(latlng.latitude, latlng.longitude),
                        infoWindow: InfoWindow(title: "my position"));
                    lat = latlng.latitude;
                    lng = latlng.longitude;
                    markers.add(myMarker);
                    setState(() {});
                  },
                  markers: markers.toSet(),
                  initialCameraPosition: EditEventAlbum._kGooglePlex,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              CustomButton(
                  "Edit", 30, 100, primaryColor, primaryColor, Colors.white,
                  () {
                //update event
                List<Event> elist = [];
                if (widget.eve.name != eventController.text) {
                  Event e = Event();
                  e.id = widget.eve.id;
                  e.name = eventController.text;
                  elist.add(e);
                  Event.updateEvents(elist);
                }
                print(lat);
                print(lng);
                //update location of all pictures of that event
                if (lat != null) {
                  Photo.updatePicturesLocationByEventId(
                      widget.eve.id!, lat!, lng!);
                }
                //show message that data is edited
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Updated successfully'),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
