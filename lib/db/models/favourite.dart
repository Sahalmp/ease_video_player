import 'package:hive_flutter/hive_flutter.dart';
    part 'favourite.g.dart';
@HiveType(typeId: 2)
class FavoritesModel extends HiveObject {
  @HiveField(2)
  late List favoritesList;
}
