import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:ease_video_player/Screens/SplashScreens/splashscreen2.dart';
import 'package:ease_video_player/Screens/screen_functions/Screenwidgets/screenwidgets.dart';
import 'package:ease_video_player/functions/search_files.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../main.dart';
import '../../main.dart';
import '../homescreen.dart';

class SplashScreen extends StatefulWidget {
  var themeNotifier;
  SplashScreen({Key? key, this.themeNotifier}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: InkWell(
        onTap: () {
          HapticFeedback.vibrate();

          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => SplashScreen2()));
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'asset/images/logo.png',
                width: 200,
              ),
              const Text('Tap to Begin')
            ],
          ),
        ),
      ),
    );
//     return AnimatedSplashScreen.withScreenFunction(
//       splash: 'asset/images/logo.png',
//       screenFunction: () async {
//         // await videosall();
//         return SplashScreen2();
//       },
//       splashTransition: SplashTransition.scaleTransition,
//     );
  }
}
