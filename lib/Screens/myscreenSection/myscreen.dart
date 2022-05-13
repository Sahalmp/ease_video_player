import 'dart:io';

import 'package:ease_video_player/Screens/myscreenSection/playlistscreen.dart';
import 'package:ease_video_player/Screens/myscreenSection/watchlistscreen.dart';
import 'package:ease_video_player/Screens/screen_functions/Screenwidgets/screenwidgets.dart';
import 'package:ease_video_player/Screens/playvideos/playlist.dart';
import 'package:ease_video_player/db/models/model.dart';
import 'package:ease_video_player/db/models/watchlater.dart';
import 'package:ease_video_player/db/db_functions.dart';
import 'package:ease_video_player/main.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';


class MyScreen extends StatefulWidget {
  const MyScreen({Key? key}) : super(key: key);

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final myController = TextEditingController();

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    getPlaylist();

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
      body: Column(
        children: [
          Container(
            height: 45,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              indicatorColor: const Color(0xff233F78),
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.playlist_play),
                      Text('PlayList')
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.favorite_outline),
                      Text('Favourites')
                    ],
                  ),
                ),
              ],
            ),
          ),
          // tab bar view here

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ListView(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(22.0),
                        child: InkWell(
                          onTap: () {
                            addplaylistdialog(context, myController);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: const Color.fromARGB(42, 0, 0, 0)),
                                borderRadius: BorderRadius.circular(6)),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.playlist_add),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Create New Playlist",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 20),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    ValueListenableBuilder(
                        valueListenable: playlistData,
                        builder:
                            (BuildContext ctx, List playlists, Widget? child) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemCount: playlists.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  ListTile(
                                    onTap: (() {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: ((context) =>
                                                  PlaylistScreen(
                                                      playlistdata:
                                                          playlists[index],
                                                      playindex: index))));
                                    }),
                                    onLongPress: () {
                                      deletePlaylist(context, index,
                                          playlists[index]['playlist']);
                                    },
                                    title: Text(playlists[index]['playlist']),
                                    leading:
                                        const Icon(Icons.playlist_add_check),
                                    trailing: Container(
                                      width: 230,
                                      child: const Divider(),
                                    ),
                                  ),
                                  playlists[index]['contents'].length == 0
                                      ? const Center(
                                          child: Text("No items in PlayList"),
                                        )
                                      : listmyplaylist(playlists[index], index)
                                ],
                              );
                            },
                          );
                        }),
                    ListTile(
                      onLongPress: () {
                        clearPlaylist(context);
                      },
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Watchlistscreen()));
                      },
                      title: const Text('Watch later'),
                      leading: const Icon(Icons.watch_later),
                      trailing: Container(
                        width: MediaQuery.of(context).size.width * 0.50,
                        child: const Divider(),
                      ),
                    ),
                    Watchlaterlist.value.isEmpty
                        ? const Center(
                            child: Text("No items in Watch later"),
                          )
                        : listwatchlater(),
                  ],
                ),
                listvideofav(name:favoritesList),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> deletePlaylist(BuildContext context, index, videoname) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(Icons.playlist_remove),
                Text(videoname),
              ],
            ),
            content: const Text('Are you sure to remove this Playlist'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                  onPressed: () {
                    removePlaylist(index);

                    playlistData.notifyListeners();
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('deleted playlist')));
                  },
                  child: const Text('Remove'))
            ],
          );
        });
  }

  Future<dynamic> clearPlaylist(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: const [
                Icon(Icons.playlist_remove),
                Text(' Watchlater'),
              ],
            ),
            content: const Text('Are you sure to clear the watchlater'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(onPressed: () {}, child: const Text('Clear'))
            ],
          );
        });
  }

  listmyplaylist(data, playindex) {
    return SizedBox(
      height: 130,
      child: ListView.builder(
        itemCount: data['contents'].length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          var i = pathList.indexOf(data['contents'][index]);

          File file = File(data['contents'][index]);

          String fileName = file.path.split('/').last;
          var videoname = fileName;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => PLaylistPage(data: data, index: index)));
              },
              onLongPress: () {
                delplaylistitem(context, videoname, playindex, index);
              },
              child: Container(
                alignment: Alignment.topRight,
                width: 150,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: thumblist.length <= i
                        ? Image.asset("asset/images/s.png").image
                        : MemoryImage(thumblist[i]),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                    width: 150,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(70, 194, 193, 193),
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(
                        videoname.trim(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                    )),
              ),
            ),
          );
        },
      ),
    );
  }

  listwatchlater() {
    return ValueListenableBuilder(
        valueListenable: Watchlaterlist,
        builder: (BuildContext context, List watchlist, Widget? child) {
          return SizedBox(
            height: 130,
            child: ListView.builder(
              itemCount: watchlist.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                var i = pathList.indexOf(watchlist[index]);

                File file = File(basenameWithoutExtension(watchlist[index]));

                String fileName = file.path.split('/').last;
                var videoname = fileName;

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) =>
                              PLaylistPage(data: watchlist[index])));
                    },
                    onLongPress: () {
                      delwatchlistitem(context, videoname, index);
                    },
                    child: Container(
                      alignment: Alignment.topRight,
                      width: 150,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: thumblist[i] == null
                              ? Image.asset("asset/images/s.png").image
                              : MemoryImage(thumblist[i]),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                          width: 150,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(70, 194, 193, 193),
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Text(
                              videoname,
                              style: TextStyle(fontSize: 10),
                              textAlign: TextAlign.center,
                            ),
                          )),
                    ),
                  ),
                );
              },
            ),
          );
        });
  }
}

Future<dynamic> delplaylistitem(
    BuildContext context, videoname, playindex, index) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.playlist_remove),
              Text(videoname),
            ],
          ),
          content:
              const Text('Are you sure to remove this Video from playlist'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
                onPressed: () {
                  removePlaylistitem(playindex, index);
                  playlistData.notifyListeners();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('deleted $videoname name from playlist')));
                },
                child: const Text('Remove'))
          ],
        );
      });
}

Future<dynamic> delwatchlistitem(BuildContext context, videoname, index) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.playlist_remove),
              Text(videoname),
            ],
          ),
          content:
              const Text('Are you sure to remove this Video from watchater'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
                onPressed: () {
                  delwatchlaterData(index);
                  Watchlaterlist.notifyListeners();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                          Text('deleted $videoname name from Watch later')));
                },
                child: const Text('Remove'))
          ],
        );
      });
}
