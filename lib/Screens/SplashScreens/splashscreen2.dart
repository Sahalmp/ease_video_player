import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:ease_video_player/Screens/screen_functions/Screenwidgets/screenwidgets.dart';
import 'package:ease_video_player/functions/search_files.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../main.dart';
import '../homescreen.dart';



class SplashScreen2 extends StatefulWidget {
  var themeNotifier;
  SplashScreen2({Key? key, this.themeNotifier}) : super(key: key);

  @override
  _SplashScreen2State createState() => _SplashScreen2State();
}

class _SplashScreen2State extends State<SplashScreen2> {
  @override
  void initState() {
    super.initState();
  }

  //   Timer(
  //       const Duration(seconds: 3),
  //       () => Navigator.of(context).pushReplacement(MaterialPageRoute(
  //           builder: (BuildContext context) => HomeScreen())));
  // }

  videosall() async {
    final value = ['.mkv', '.mp4', '.mov'];
    SearchFilesInStorage.searchInStorage(
      value,
      (List<String> data) async {
        pathList.clear();

        setState(() {
          pathList.addAll(data);
        });
      },
      (error) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   backgroundColor: Colors.white,
    //   body: Center(
    //     child: Image.asset(
    //       'asset/images/logo.png',
    //       width: 200,
    //     ),
    //   ),
    // );
    return AnimatedSplashScreen.withScreenFunction(
        splash: 'asset/images/logo.png',
        splashIconSize: MediaQuery.of(context).size.width * 0.30,
        screenFunction: () async {
          if (await Permission.storage.isGranted) {
            
            await videosall();
          }

          return HomeScreen();
        });
  }
}
