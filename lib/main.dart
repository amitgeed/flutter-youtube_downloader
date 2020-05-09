import 'package:flutter/material.dart';
import 'package:flutter_app_youtube_demo/screens/download_screen.dart';
import 'package:flutter_app_youtube_demo/screens/home_screen.dart';
import 'package:flutter_app_youtube_demo/screens/player_screen.dart';
import 'package:flutter_app_youtube_demo/screens/search_screen.dart';
import 'package:flutter_app_youtube_demo/screens/setting_screen.dart';
import 'package:flutter_app_youtube_demo/screens/splash_screen.dart';
import 'package:flutter_app_youtube_demo/screens/video_download.dart';
import 'package:flutter_app_youtube_demo/utils/bottom_navbar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyBottomNavbar(),
      initialRoute: SplashScreen.id,
      routes: {
        MyBottomNavbar.id: (context) => MyBottomNavbar(),
        SplashScreen.id: (context) => SplashScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        SearchScreen.id: (context) => SearchScreen(),
        DownloadScreen.id: (context) => DownloadScreen(),
        PlayerScreen.sid: (context) => PlayerScreen(),
        SettingScreen.id: (context) => SettingScreen(),
        VideoDownload.id: (context) => VideoDownload()
      },
    );
  }
}
