import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'model.g.dart';

var playlists = ValueNotifier(List.empty(growable: true));

var playlistData = ValueNotifier(List.empty(growable: true));
var favoritesList = ValueNotifier(List.empty(growable: true));

@HiveType(typeId: 1)
class PlaylistModel extends HiveObject {
  @HiveField(1)
  late List playlistData;
}

