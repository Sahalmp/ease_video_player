import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:ease_video_player/Screens/fileSection/filesscreen.dart';
import 'package:ease_video_player/Screens/otherScreens.dart';
import 'package:ease_video_player/Screens/SplashScreens/splashscreen.dart';
import 'package:ease_video_player/Screens/playvideos/videoplay.dart';
import 'package:ease_video_player/Screens/videoscreen.dart';
import 'package:ease_video_player/db/db_functions.dart';
import 'package:ease_video_player/db/models/history.dart';
import 'package:ease_video_player/main.dart';
import 'package:flutter/material.dart';

import 'myscreenSection/myscreen.dart';
import 'drawer section/watchhistory.dart';
import 'screen_functions/Screenwidgets/screenwidgets.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    getinfo();

    thumbnailGetter();
    super.initState();
  }

  int _selectedindex = 0;
  final screens = [
    FileScreen(),
    const VideoScreen(),
    const MyScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context: context),
      body: screens[_selectedindex],
      bottomNavigationBar: bottomnavbar(),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await gethistorylist();
            if (HistoryList.value.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('No recently played item in history')));
              return;
            }

            Navigator.of(context).push(MaterialPageRoute(
                builder: ((BuildContext context) => VideoPlay(
                    path: HistoryList.value[HistoryList.value.length - 1],
                    name: 'last played'))));
          },
          child: const Icon(
            Icons.play_arrow_rounded,
            size: 40,
          )),
      drawer: MenuDrawer(context),
    );
  }

  //MenuDrawer
  bool isSwitched = false;

  SizedBox MenuDrawer(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.60,
      child: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              ListTile(
                leading: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.menu, size: 40),
                ),
                title: const Padding(
                  padding: EdgeInsets.only(top: 11.0, left: 16.0),
                  child: Text(
                    'Menu',
                    style: TextStyle(fontSize: 22),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              menuitems(
                  menulisticon: Icons.dark_mode,
                  menulisttitle: 'Darkmode',
                  trailingitem: Switch(
                      value: isSwitched,
                      onChanged: (value) {
                        setState(() {
                          isSwitched = value;

                          isSwitched
                              ? AdaptiveTheme.of(context).setDark()
                              : AdaptiveTheme.of(context).setLight();
                        });
                      })),
              menuitems(
                  menulisticon: Icons.history,
                  menulisttitle: 'Watch History',
                  ontapfunction: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => const WatchHistory()));
                  }),
              menuitems(
                  menulisticon: Icons.share_outlined, menulisttitle: 'Share'),
              menuitems(
                  menulisticon: Icons.privacy_tip_outlined,
                  menulisttitle: 'Privacy Policy',
                  ontapfunction: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => PrivacyPolicyPage()));
                  }),
              menuitems(
                  menulisticon: Icons.info_outline,
                  menulisttitle: 'About',
                  ontapfunction: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => const AboutPage()));
                  }),
            ],
          ),
        ),
      ),
    );
  }

  ListTile menuitems(
      {required menulisticon,
      required menulisttitle,
      trailingitem = null,
      ontapfunction = null}) {
    return ListTile(
      leading: Icon(menulisticon),
      title: Text(
        menulisttitle,
      ),
      trailing: trailingitem,
      onTap: ontapfunction,
    );
  }

//

//Bottom navbar
  Widget bottomnavbar() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 0.5),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'Files'),
            BottomNavigationBarItem(
                icon: Icon(Icons.movie_creation), label: 'Videos'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'My')
          ],
          currentIndex: _selectedindex,
          onTap: (index) {
            setState(() {
              _selectedindex = index;
            });
          },
          selectedItemColor: const Color(0xff233F78),
        ),
      ),
    );
  }
}
