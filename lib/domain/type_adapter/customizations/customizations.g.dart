// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customizations.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomizationsAdapter extends TypeAdapter<Customizations> {
  @override
  final int typeId = 3;

  @override
  Customizations read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Customizations(
      index: fields[0] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Customizations obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.index);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomizationsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
