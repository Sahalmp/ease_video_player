import 'package:ease_video_player/Screens/playvideos/playlist.dart';
import 'package:ease_video_player/db/models/history.dart';
import 'package:ease_video_player/db/models/model.dart';
import 'package:ease_video_player/db/models/watchlater.dart';
import 'package:ease_video_player/main.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

addNewPlaylist(String playlistName) async {
  var playlistBox = await Hive.openBox('playlistBox');
  playlists.value = [
    {'playlist': playlistName, 'contents': []}
  ];
  playlistBox.add(playlists.value[0]);
  playlistData.value.add(playlistBox.getAt(playlistBox.length - 1));
  playlistData.notifyListeners();
}

getPlaylist() async {
  playlistData.value.clear();
  var playlistBox = await Hive.openBox('playlistBox');
  for (var i = 0; i < playlistBox.length; i++) {
    playlistData.value.add(playlistBox.getAt(i));
    playlistData.notifyListeners();
  }
}

addToPlaylist(data, index) async {
  var playlistBox = await Hive.openBox('playlistBox');
  playlistData.value[index]['contents'].add(data);
  playlistBox.putAt(index, playlistData.value[index]);
  playlistData.notifyListeners();
  
}

removePlaylist(int index) async {
  var playlistBox = await Hive.openBox('playlistBox');
  playlistBox.deleteAt(index);
  playlistData.value.removeAt(index);
}

// renamePlaylist(index, newName) async {
//   var playlistBox = await Hive.openBox('playlistBox');
//   playlistData[index]['playlist'] = newName;
//   playlistBox.putAt(index, playlistData[index]);
//   getPlaylist();
//   update();
// }

removePlaylistitem(int index, int values) async {
  playlistData.value.clear();
  var playlistBox = await Hive.openBox('playlistBox');
  for (var i = 0; i < playlistBox.length; i++) {
    playlistData.value.add(playlistBox.getAt(i));
  }
  playlistData.value[index]['contents'].removeAt(values);
  playlistBox.putAt(index, playlistData.value[index]);
}

favoritesData(String data, context) async {
  for (String item in favoritesList.value) {
    if (item == data) {
      return ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Video is already your favourite')));
    }
  }
  favoritesList.value.clear();

  var favorites = await Hive.openBox('favorites');
  await favorites.add(data);
  favoritesList.value.addAll(favorites.values);
  favoritesList.notifyListeners();
}

delfavoritesData(index) async {
  var favorites = await Hive.openBox('favorites');
  favoritesList.value.removeAt(index);
  favorites.deleteAt(index);
  favoritesList.notifyListeners();
}

watchlistData(String data, context) async {
  for (String item in Watchlaterlist.value) {
    if (item == data) {
      return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Video is already your Watchlater')));
    }
  }
  Watchlaterlist.value.clear();

  var watchlaters = await Hive.openBox('favorites');
  await watchlaters.add(data);
  Watchlaterlist.value.addAll(watchlaters.values);
  Watchlaterlist.notifyListeners();
}

delwatchlaterData(index) async {
  var watchlists = await Hive.openBox('favorites');
  Watchlaterlist.value.removeAt(index);
  watchlists.deleteAt(index);
  Watchlaterlist.notifyListeners();
}

Historydata(String data) async {
  for (String item in HistoryList.value) {
    if (item == data) {
      var i = HistoryList.value.indexOf(data);
      await delHistory(i);
      break;
    }
  }

  HistoryList.value.clear();

  var historys = await Hive.openBox('history');
  await historys.add(data);
  HistoryList.value.addAll(historys.values);
  HistoryList.notifyListeners();
}
gethistorylist() async{
   HistoryList.value.clear();
  var historys = await Hive.openBox('history');
  HistoryList.value.addAll(historys.values);
  HistoryList.notifyListeners();
}
getfavouritelist() async{
   favoritesList.value.clear();
  var favorites = await Hive.openBox('favorites');
  favoritesList.value.addAll(favorites.values);
  favoritesList.notifyListeners();
}

delHistory(index) async {
  var historys = await Hive.openBox('history');
  HistoryList.value.removeAt(index);
  historys.deleteAt(index);
  HistoryList.notifyListeners();
}
