import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery/Screens/albums.dart';
import 'package:photo_gallery/Screens/camera.dart';
import 'package:photo_gallery/Screens/mapview.dart';
import 'package:photo_gallery/Screens/search.dart';
import 'package:photo_gallery/Screens/sync.dart';
import 'package:photo_gallery/Utilities/Global/global.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  PageController? _pageController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController!.dispose();
  }

  List<Widget> screens = [
    AlbummsScreen(),
    SearchScreen(),
    CameraScreen(),
    MapViewScreen(),
    SyncScreen()
  ];

  List<BottomNavyBarItem> itemsList = [
    BottomNavyBarItem(
      icon: Icon(Icons.photo_album_outlined),
      title: Text('Albums'),
      activeColor: primaryColor,
    ),
    BottomNavyBarItem(
      icon: Icon(Icons.search),
      title: Text('Search'),
      activeColor: primaryColor,
    ),
    BottomNavyBarItem(
      icon: Icon(Icons.camera_alt),
      title: Text('Camera'),
      activeColor: primaryColor,
    ),
    BottomNavyBarItem(
      icon: Icon(Icons.map_outlined),
      title: Text('MapView'),
      activeColor: primaryColor,
    ),
    BottomNavyBarItem(
      icon: Icon(Icons.sync),
      title: Text('Sync'),
      activeColor: primaryColor,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        items: itemsList,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController!.jumpToPage(index);
        },
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
        children: screens,
      ),
    );
  }
}
