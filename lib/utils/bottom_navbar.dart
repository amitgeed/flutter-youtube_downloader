import 'package:flutter_app_youtube_demo/screens/download_screen.dart';
import 'package:flutter_app_youtube_demo/screens/home_screen.dart';
import 'package:flutter_app_youtube_demo/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_youtube_demo/screens/setting_screen.dart';

class MyBottomNavbar extends StatefulWidget {
  static const String id = 'bottom_navbar';
  @override
  _MyBottomNavbarState createState() => _MyBottomNavbarState();
}

class _MyBottomNavbarState extends State<MyBottomNavbar> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomeScreen(),
    SearchScreen(),
    DownloadScreen(),
    SettingScreen(),
  ];
  void onTappedBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black45,
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.shifting,
          onTap: onTappedBar,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                // color: Colors.white,
              ),
              title: Text(
                'Home',
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                // color: Colors.white,
              ),
              title: Text(
                'Search',
                style: TextStyle(
                    // color: Colors.black54,
                    ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.file_download,
                // color: Colors.white,
              ),
              title: Text(
                'Download',
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
                // color: Colors.white,
              ),
              title: Text(
                'Settings',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
