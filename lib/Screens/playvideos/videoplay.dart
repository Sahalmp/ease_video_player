import 'package:ease_video_player/db/db_functions.dart';
import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';

class VideoPlay extends StatefulWidget {
  var path;
  var name;
  VideoPlay({Key? key, required this.path, required this.name})
      : super(key: key);

  @override
  State<VideoPlay> createState() => _VideoPlayState();
}

class _VideoPlayState extends State<VideoPlay> {
  late BetterPlayerController _betterPlayerController;

  @override
  void initState() {
    BetterPlayerControlsConfiguration controlsConfiguration =
        BetterPlayerControlsConfiguration(
      progressBarPlayedColor: Colors.blueGrey,
      controlBarHeight: 60,
      controlsHideTime: Duration(milliseconds: 100),
    );

    super.initState();
    Historydata(widget.path);

    BetterPlayerDataSource betterPlayerDataSource =
        BetterPlayerDataSource(BetterPlayerDataSourceType.file, widget.path);
    _betterPlayerController = BetterPlayerController(
        BetterPlayerConfiguration(
          autoPlay: true,
          autoDetectFullscreenDeviceOrientation: true,
          controlsConfiguration: controlsConfiguration,
        ),
        betterPlayerDataSource: betterPlayerDataSource);
    _setupDataSource();

    _betterPlayerController.addEventsListener((BetterPlayerEvent event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
        _betterPlayerController.setOverriddenAspectRatio(
            _betterPlayerController.videoPlayerController!.value.aspectRatio);
        setState(() {});
      }
    });
  }

  void _setupDataSource() async {
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.file,
      widget.path,
      notificationConfiguration: BetterPlayerNotificationConfiguration(
        showNotification: true,
        title: widget.name,
      ),
    );
    _betterPlayerController.setupDataSource(dataSource);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio:
          _betterPlayerController.videoPlayerController!.value.aspectRatio,
      child: BetterPlayer(
        controller: _betterPlayerController,
      ),
    );
  }
}
