import 'dart:io';
import 'package:ease_video_player/Screens/screen_functions/Screenwidgets/screenwidgets.dart';

import '../../main.dart';

import 'package:ease_video_player/Screens/fileSection/foldervideos.dart';
import 'package:flutter/material.dart';

var folderList = [];
var templist = [];

class FileScreen extends StatelessWidget {
  FileScreen({Key? key}) : super(key: key);
  @override
  
  @override
  Widget build(BuildContext context) {
    

    folderList.clear();
    templist.clear();
    for (String item in pathList) {
      var temp = item.split("/");

      temp.removeLast();

      var path = temp.join("/");

      if (folderList.contains(path)) {
        templist.add(path);
        continue;
      } else {
        folderList.add(path);
      }
    }

    return Scaffold(
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 16.0, left: 20, bottom: 10),
            child: Text(
              'Files',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: folderList.length,
            itemBuilder: (BuildContext context, int index) {
              File file = File(folderList[index]);
              String fileName = file.path.split('/').last;
              int count = 1;

              var name = fileName;
              for (int i = 0; i < templist.length; i++) {
                if (folderList[index].contains(templist[i])) {
                  count++;
                }
              }

              return ListTile(
                  title: Text(name),
                  subtitle:
                      count == 1 ? Text('$count video') : Text('$count videos'),
                  leading: const Icon(
                    Icons.folder,
                    size: 60,
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) =>
                            FolderVideos(name: name, path: folderList[index])));
                  });
            },
          ),
        ],
      ),
    );
  }
}
