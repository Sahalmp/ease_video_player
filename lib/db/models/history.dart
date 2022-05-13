import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'history.g.dart';

var HistoryList = ValueNotifier([]);

@HiveType(typeId: 2)
class HistoryModel extends HiveObject {
  @HiveField(2)
  late List HistoryList;
}
