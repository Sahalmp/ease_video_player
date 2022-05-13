import 'package:better_player/better_player.dart';
import 'package:ease_video_player/db/models/model.dart';
import 'package:ease_video_player/db/db_functions.dart';
import 'package:flutter/material.dart';

List<BetterPlayerDataSource> dataSourceList = [];

class PLaylistPage extends StatelessWidget {
  var data;
  var index;
  PLaylistPage({Key? key, this.data, this.index}) : super(key: key);

  List<BetterPlayerDataSource> createDataSet() {
    for (int i = index; i < data['contents'].length; i++) {
      dataSourceList.add(
        BetterPlayerDataSource(
          BetterPlayerDataSourceType.file,
          data['contents'][i],
        ),
      );
    }
    return dataSourceList;
  }

  @override
  Widget build(BuildContext context) {
    dataSourceList.clear();

    createDataSet();
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: BetterPlayerPlaylist(
          betterPlayerConfiguration: const BetterPlayerConfiguration(),
          betterPlayerPlaylistConfiguration:
              const BetterPlayerPlaylistConfiguration(),
          betterPlayerDataSourceList: dataSourceList,
          ),
    );
  }
}
