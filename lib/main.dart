import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:ease_video_player/Screens/SplashScreens/splashscreen.dart';
import 'package:ease_video_player/db/models/favourite.dart';
import 'package:ease_video_player/db/models/model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screens/SplashScreens/splashscreen2.dart';

int? initScreen;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(FavoritesModelAdapter().typeId)) {
    Hive.registerAdapter(FavoritesModelAdapter());
  }
  if (!Hive.isAdapterRegistered(PlaylistModelAdapter().typeId)) {
    Hive.registerAdapter(PlaylistModelAdapter());
  }
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = await prefs.getInt("initScreen");
  await prefs.setInt("initScreen", 1);
  print('initScreen ${initScreen}');

  runApp(VideoPlayerApp(savedThemeMode: savedThemeMode));
}

bool isdark = false;

List<String> pathList = [];
var access = false;

Future<void> requestStoragePermission() async {
  final serviceStatusstorage = await Permission.storage.isGranted;

  bool isStorage = serviceStatusstorage == ServiceStatus.enabled;
  access = isStorage;

  final status = await Permission.storage.request();

  if (status == PermissionStatus.granted) {
  } else if (status == PermissionStatus.denied) {
    print('Permission denied');
  } else if (status == PermissionStatus.permanentlyDenied) {
    print('Permission Permanently Denied');
    await openAppSettings();
  }
}

class VideoPlayerApp extends StatefulWidget {
  final AdaptiveThemeMode? savedThemeMode;
  VideoPlayerApp({Key? key, this.savedThemeMode}) : super(key: key);

  @override
  State<VideoPlayerApp> createState() => _VideoPlayerAppState();
}

class _VideoPlayerAppState extends State<VideoPlayerApp> {
  @override
  void initState() {
    requestStoragePermission();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        listTileTheme: const ListTileThemeData(
          iconColor: Color(0x617d7d7d),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xff233F78)),
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
          primary: const Color(0xff233F78),
        )),
        scaffoldBackgroundColor: const Color.fromARGB(255, 251, 244, 244),
        primaryColor: const Color(0xffffffff),
      ),
      dark: ThemeData.dark(),
      initial: widget.savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
          theme: theme,
          darkTheme: darkTheme,
          home: initScreen == null || initScreen == 0
              ? SplashScreen()
              : SplashScreen2(),
          debugShowCheckedModeBanner: false),
    );
  }
}
