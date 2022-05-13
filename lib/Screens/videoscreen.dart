import 'dart:io';

import 'package:ease_video_player/Screens/fileSection/filesscreen.dart';
import 'package:flutter/material.dart';

import '../main.dart';

import 'screen_functions/Screenwidgets/screenwidgets.dart';
import 'fileSection/foldervideos.dart';

var map = {};

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  var tablist = [];
  var newlist = [];
  var tempupdatelist = [];

  bool changed = false;
  var index = 0;

  @override
  void initState() {
    tempupdatelist.add('allvideos');
    tempupdatelist.addAll(folderList);
    tablist.add('All videos');
    

    for (var item in folderList) {
      File file = File(item);
      String fileName = file.path.split('/').last;

      tablist.add(fileName);
    }
    _tabController = TabController(length: tablist.length, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Container(
          height: 45,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              indicatorColor: const Color(0xff233F78),
              indicatorWeight: 3,
              isScrollable: true,
              tabs: tablist.map((tabName) {
                return Tab(child: Text(tabName));
              }).toList()),
        ),
        Expanded(
          child: TabBarView(
              controller: _tabController,
              // children: List<Widget>.generate(tablist.length, (int index) {
              //
              //     }
              //   });

              //   return ListVideos(name: videolist);
              // }),

              children: tempupdatelist.map((element) {
                return listfoldervideos(element);
              }).toList()),
        ),
      ]),
    );
  }

  Widget listfoldervideos(element) {
    videolist.clear();
    for (String item in pathList) {
      var temp = item.split("/");

      temp.removeLast();

      var newpath = temp.join("/");

      if (newpath == element) {
        videolist.add(item);
      } else if (element == tempupdatelist[0]) {
        map.addAll({tablist[0]: pathList});
        return ListVideos(name: map[tablist[0]].toList());
      }

      map.addAll({tablist[index]: videolist});
    }
    return ListVideos(name: map[tablist[index]].toList());
  }
}
