import 'dart:io';

import 'package:ease_video_player/Screens/myscreenSection/myscreen.dart';
import 'package:ease_video_player/Screens/screen_functions/Screenwidgets/screenwidgets.dart';
import 'package:ease_video_player/Screens/playvideos/playlist.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../../db/models/watchlater.dart';
import '../../main.dart';


class Watchlistscreen extends StatelessWidget {
  Watchlistscreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        automaticallyImplyLeading: true,
        title: Text('Watch later'),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_outlined)),
        // actions: [
        //   Padding(
        //       padding: const EdgeInsets.only(right: 20.0),
        //       child: IconButton(
        //           onPressed: () {},
        //           icon: const Icon(Icons.auto_delete_outlined)))
        // ],
      ),
      body: Watchlaterlist.value.isEmpty
          ? const Center(
              child: Text("No items in Watch later"),
            )
          : listmywatchlater(),
    );
  }

  listmywatchlater() {
    return ValueListenableBuilder(
      valueListenable: Watchlaterlist,
      builder: (BuildContext context, List watchlater, Widget? child) {
        return ListView(
          children: [
            const SizedBox(
              height: 10,
            ),
            ListView.separated(
              reverse: true,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: watchlater.length,
              itemBuilder: (BuildContext context, int index) {
                var i = pathList.indexOf(watchlater[index]);

                File file = File(watchlater[index]);
                String fileName = file.path.split('/').last;
                var videoname = basenameWithoutExtension(fileName);
                return ListTile(
                  onTap: (() => Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) =>
                          PLaylistPage(data: watchlater, index: index)))),
                  title: Text(videoname),
                  leading: Container(
                    alignment: Alignment.topRight,
                    width: 97,
                    height: 57,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: thumblist[i] == null
                            ? Image.asset("asset/images/s.png").image
                            : MemoryImage(thumblist[i]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  trailing: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: IconButton(
                          onPressed: () {
                            delwatchlistitem(context, videoname, index);
                          },
                          icon: const Icon(Icons.delete))),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                height: 10,
                indent: 120,
              ),
            ),
          ],
        );
      },
    );
  }
}
