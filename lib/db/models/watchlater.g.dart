// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watchlater.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WatchlaterModelAdapter extends TypeAdapter<WatchlaterModel> {
  @override
  final int typeId = 2;

  @override
  WatchlaterModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WatchlaterModel()
      ..Watchlaterlist = (fields[2] as List).cast<dynamic>();
  }

  @override
  void write(BinaryWriter writer, WatchlaterModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(2)
      ..write(obj.Watchlaterlist);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WatchlaterModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
