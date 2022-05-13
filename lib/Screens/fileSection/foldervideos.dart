import 'package:ease_video_player/Screens/screen_functions/Screenwidgets/screenwidgets.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class FolderVideos extends StatelessWidget {
  final name;
  final path;
  const FolderVideos({Key? key, required this.name, required this.path})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    videolist.clear();

    for (String item in pathList) {
      var temp = item.split("/");

      temp.removeLast();

      var newpath = temp.join("/");

      if (newpath == path) {
        videolist.add(item);
      }
    }

    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Color(0xff585D67), Color(0xff233F78)]),
            ),
          ),
          title: Text(name),
        ),
        body: ListVideos(
          name: videolist,
        ));
  }
}

var videolist = [];
