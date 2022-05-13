import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'watchlater.g.dart';

var Watchlaterlist = ValueNotifier([]);

@HiveType(typeId: 2)
class WatchlaterModel extends HiveObject {
  @HiveField(2)
  late List Watchlaterlist;
}
