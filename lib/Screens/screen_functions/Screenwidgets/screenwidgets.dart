import 'dart:io';
import 'package:ease_video_player/Screens/screen_functions/searchdelegate.dart';
import 'package:filesize/filesize.dart';

import 'package:ease_video_player/Screens/playvideos/videoplay.dart';
import 'package:ease_video_player/db/models/history.dart';
import 'package:ease_video_player/db/models/model.dart';
import 'package:ease_video_player/db/db_functions.dart';
import 'package:ease_video_player/main.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:share_plus/share_plus.dart';

import 'package:video_thumbnail/video_thumbnail.dart';

AppBar appBar({required context}) {
  return AppBar(
    actions: [
      Row(
        children: [
          // IconButton(onPressed: () {}, icon: const Icon(Icons.sync)),
          Padding(
            padding: const EdgeInsets.only(right: 1.0),
            child: IconButton(
                onPressed: () {
                  showSearch(
                      context: context, delegate: CustomSearchDelegate());
                },
                icon: const Icon(Icons.search_outlined)),
          )
        ],
      )
    ],
    title: Row(children: const [
      Text(
        'Ease',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Padding(
        padding: EdgeInsets.only(top: 6.0),
        child: Text(
          ' Video Player',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w200,
          ),
        ),
      )
    ]),
    flexibleSpace: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[Color(0xff585D67), Color(0xff233F78)]),
      ),
    ),
  );
}
// getpropinfo(path) async {

//     var a = await videoInfo.getVideoInfo(path);

// }
String getTimeString(milliseconds) {
  if (milliseconds == null) {
    milliseconds = 0;
  }
  String hours =
      '${milliseconds / (1000 * 60 * 60).floor() % 24 < 10 ? 0 : ''}${milliseconds / (1000 * 60 * 60).floor() % 24}';

  String minutes =
      '${(milliseconds / 60000).floor() < 10 ? 0 : ''}${(milliseconds / 60000).floor()}';
  String seconds =
      '${(milliseconds / 1000).floor() % 60 < 10 ? 0 : ''}${(milliseconds / 1000).floor() % 60}';
  return '$hours:$minutes:$seconds';
}

var thumblist = [];

Future thumbnailGetter() async {
  for (var i = 0; i < pathList.length; i++) {
    //  print("\n\n\n\n\n\n\n\n$i");
    var tPic = (await VideoThumbnail.thumbnailData(
      video: pathList[i],
      imageFormat: ImageFormat.JPEG,
      maxWidth: 128,
      quality: 25,
    ));
    thumblist.add(tPic!);
  }
}

List videosize = [];
List duration = [];
final videoInfo = FlutterVideoInfo();
getinfo() async {
  for (int i = 0; i < pathList.length; i++) {
    var a = await videoInfo.getVideoInfo(pathList[i]);

    videosize.add(a!.filesize);
    duration.add(a.duration);
  }
}

class ListVideos extends StatefulWidget {
  ListVideos({Key? key, required this.name}) : super(key: key);
  var name;

  @override
  State<ListVideos> createState() => _ListVideosState();
}

var name;

class _ListVideosState extends State<ListVideos> {
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    name = widget.name;
    return listvideos(name);
  }

  // static String formatBytes(int bytes, ) {
  //   if (bytes <= 0) return "0 B";
  //   const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
  //   var i = (log(bytes) / log(1024)).floor();
  //   return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) +
  //       ' ' +
  //       suffixes[i];
  // }

  listvideos(name) {
    return ListView(
      children: [
        const SizedBox(
          height: 10,
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: name.length,
          itemBuilder: (BuildContext context, int index) {
            // getinfo(pathList[index]);
            var size;
            File file = File(name[index]);

            // String fileName =
            //     file.path.split('/')[file.path.split('/').length - 2];
            String fileName = file.path.split('/').last;

            var videoname = fileName;
            var i = pathList.indexOf(name[index]);
            if (videosize.length <= i) {
              size = '0.00';
            } else {
              size = filesize(videosize[i]);
            }
            var dur = '00:00';
            if (duration.length > i) {
              dur = getTimeString(duration[i]);
            }
            return ListTile(
              onTap: (() => Navigator.of(context).push(MaterialPageRoute(
                  builder: ((BuildContext context) =>
                      VideoPlay(path: name[index], name: fileName))))),
              title: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  videoname,
                ),
              ),
              subtitle: Text(size),
              leading: Container(
                alignment: Alignment.topRight,
                width: 97,
                height: 57,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: thumblist.length <= i
                        ? Image.asset("asset/images/s.png").image
                        : MemoryImage(thumblist[i]),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(0, 0, 0, 120),
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(
                        dur.substring(dur.length - 5, dur.length),
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    )),
              ),
              trailing: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                    onPressed: () {
                      moreDialogbox(
                          context, videoname, myController, name[index]);
                    },
                    icon: const Icon(Icons.more_vert)),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(
            height: 0.2,
            indent: 120,
          ),
        ),
      ],
    );
  }
}

Future<dynamic> moreDialogbox(
    BuildContext context, String videoname, myController, data) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: 250,
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    videoname,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  horizontalTitleGap: 0,
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const Divider(
                  thickness: 2,
                ),
                morelist(
                    morelisticon: Icons.playlist_add,
                    morelisttitle: 'Add to playlist',
                    ontapped: () {
                      Navigator.of(context).pop();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                                child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 300,
                                    child: ListView(
                                      shrinkWrap: true,
                                      children: [
                                        morelist(
                                            morelisttitle: 'Watch later',
                                            morelisticon: Icons.watch_later,
                                            ontapped: () {
                                              watchlistData(data, context);
                                              Navigator.of(context).pop();
                                            }),
                                        morelist(
                                            morelisttitle:
                                                'Create New PlayList',
                                            morelisticon: Icons.playlist_add,
                                            ontapped: () {
                                              Navigator.of(context).pop();
                                              addplaylistdialog(
                                                  context, myController);
                                            }),
                                        const Divider(),
                                        ValueListenableBuilder(
                                            valueListenable: playlistData,
                                            builder: (BuildContext ctx,
                                                List playlists, Widget? child) {
                                              return ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const ClampingScrollPhysics(),
                                                itemCount: playlists.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return morelist(
                                                      morelisttitle:
                                                          playlists[index]
                                                              ['playlist'],
                                                      morelisticon:
                                                          Icons.playlist_play,
                                                      ontapped: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        addToPlaylist(
                                                            data, index);
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(SnackBar(
                                                                content: Text(
                                                                    'Added to Playlist ${playlists[index]['playlist']}')));
                                                      });
                                                },
                                              );
                                            }),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ));
                          });
                    }),
                morelist(
                    morelisticon: Icons.favorite_outline,
                    morelisttitle: 'Add to Favourites',
                    ontapped: () {
                      favoritesData(data, context);
                      Navigator.of(context).pop();
                    }),
                morelist(
                    morelisticon: Icons.share_outlined,
                    morelisttitle: 'Share',
                    ontapped: () async {
                      await Share.shareFiles([data]);
                    }),
                morelist(
                    morelisticon: Icons.info_outline,
                    morelisttitle: 'Properties',
                    ontapped: () async {
                      var a = await videoInfo.getVideoInfo(data);

                      Navigator.of(context).pop();
                      propertyshowdialog(context: context, data: data, a: a);
                    }),
              ],
            ),
          ),
        );
      });
}

Future<dynamic> addplaylistdialog(BuildContext context, myController) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: 200,
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(
                    Icons.playlist_add,
                    size: 35,
                  ),
                  title: Text('Create New Playlist'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: myController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          label: const Text('Playlist name')),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            addNewPlaylist(myController.text);
                          },
                          child: const Text('Create PlayList')),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      });
}

List foldervideos = [];

Future<dynamic> propertyshowdialog({required context, required data, a}) {
  var dur = getTimeString(a!.duration);
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text(
                    'Properties',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const Divider(
                  thickness: 2,
                ),
                propertieslist(propertyname: 'Path', propertyvalue: data),
                propertieslist(
                    propertyname: 'Size', propertyvalue: filesize(a!.filesize)),
                propertieslist(propertyname: 'Format', propertyvalue: 'Mp4'),
                propertieslist(
                    propertyname: 'Length',
                    propertyvalue: dur.substring(dur.length - 5, dur.length))
              ],
            ),
          ),
        );
      });
}

propertieslist({required propertyname, required propertyvalue}) {
  return ListTile(
    leading: Text(
      propertyname,
      overflow: TextOverflow.visible,
    ),
    trailing: Padding(
      padding: const EdgeInsets.only(left: 90.0),
      child: Text(propertyvalue),
    ),
  );
}

morelist(
    {required morelisttitle,
    required morelisticon,
    morelisttrail = null,
    ontapped = null}) {
  return SizedBox(
      height: 40,
      child: ListTile(
        title: Text(morelisttitle),
        trailing: morelisttrail,
        leading: Icon(morelisticon),
        onTap: ontapped,
      ));
}

listhistoryvideos({required count}) {
  return ValueListenableBuilder(
    valueListenable: HistoryList,
    builder: (BuildContext context, List HistoryList, Widget? child) {
      return ListView(
        children: [
          const SizedBox(
            height: 10,
          ),
          ListView.separated(
            reverse: true,
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: HistoryList.length,
            itemBuilder: (BuildContext context, int index) {
              var i = pathList.indexOf(HistoryList[index]);

              File file = File(HistoryList[index]);
              String fileName = file.path.split('/').last;
              var videoname = basenameWithoutExtension(fileName);
              return ListTile(
                onTap: (() => Navigator.of(context).push(MaterialPageRoute(
                    builder: ((BuildContext context) =>
                        VideoPlay(path: HistoryList[index], name: fileName))))),
                title: Text(videoname),
                leading: Container(
                  alignment: Alignment.topRight,
                  width: 97,
                  height: 57,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: thumblist.length <= i
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
                          historyitemdelete(context, videoname, index);
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

Future<dynamic> historyitemdelete(
    BuildContext context, String videoname, int index) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(videoname),
          content:
              const Text('Are you sure to delete this \nmedia from history?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
                onPressed: () {
                  delHistory(index);
                  Navigator.of(context).pop();
                },
                child: const Text('Delete'))
          ],
        );
      });
}

Future<dynamic> historyclear(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("History"),
          content:
              const Text("Are you sure to delete all \nmedia's from history?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(onPressed: () {}, child: const Text('Delete'))
          ],
        );
      });
}

listvideofav({required name}) {
  getfavouritelist();
  return ValueListenableBuilder(
      valueListenable: favoritesList,
      builder: (BuildContext context, List favouritelist, Widget? child) {
        return favouritelist.isEmpty
            ? Center(child: Text('No Favourites'))
            : ListView(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: favouritelist.length,
                    itemBuilder: (BuildContext context, int index) {
                      var i = pathList.indexOf(favouritelist[index]);

                      // getinfo(pathList[index]);
                      File file = File(favouritelist[index]);
                      var size;
                      if (videosize.length <= i) {
                        size = '0.00';
                      } else {
                        size = filesize(videosize[i]);
                      }
                      var dur = '00:00';
                      if (duration.length >= i) {
                        dur = getTimeString(duration[i]);
                      }

                      // String fileName =
                      //     file.path.split('/')[file.path.split('/').length - 2];
                      String fileName = file.path.split('/').last;

                      var videoname = fileName;

                      return ListTile(
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(videoname),
                                content: const Text(
                                    "Are you sure to remove this from favourites?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        delfavoritesData(index);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Remove'))
                                ],
                              );
                            },
                          );
                        },
                        onTap: (() => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: ((BuildContext context) => VideoPlay(
                                    path: favouritelist[index],
                                    name: fileName))))),
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            videoname,
                          ),
                        ),
                        subtitle: Text(size),
                        leading: Container(
                          alignment: Alignment.topRight,
                          width: 97,
                          height: 57,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: thumblist.length <= i
                                  ? Image.asset("asset/images/s.png").image
                                  : MemoryImage(thumblist[i]),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(0, 0, 0, 120),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Padding(
                                padding: EdgeInsets.all(2.0),
                                child: Text(
                                  dur.substring(dur.length - 5, dur.length),
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.white),
                                ),
                              )),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(
                      height: 0.2,
                      indent: 120,
                    ),
                  ),
                ],
              );
      });
}
