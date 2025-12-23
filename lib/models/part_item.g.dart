// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'part_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PartItemAdapter extends TypeAdapter<PartItem> {
  @override
  final int typeId = 1;

  @override
  PartItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PartItem(
      name: fields[0] as String,
      category: fields[1] as PartCategory,
      quantity: fields[2] as int,
      purchased: fields[3] as bool,
      notes: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PartItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.quantity)
      ..writeByte(3)
      ..write(obj.purchased)
      ..writeByte(4)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PartItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PartCategoryAdapter extends TypeAdapter<PartCategory> {
  @override
  final int typeId = 0;

  @override
  PartCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PartCategory.engine;
      case 1:
        return PartCategory.transmission;
      case 2:
        return PartCategory.suspension;
      case 3:
        return PartCategory.brakes;
      case 4:
        return PartCategory.electrics;
      case 5:
        return PartCategory.body;
      case 6:
        return PartCategory.fluids;
      case 7:
        return PartCategory.other;
      default:
        return PartCategory.engine;
    }
  }

  @override
  void write(BinaryWriter writer, PartCategory obj) {
    switch (obj) {
      case PartCategory.engine:
        writer.writeByte(0);
        break;
      case PartCategory.transmission:
        writer.writeByte(1);
        break;
      case PartCategory.suspension:
        writer.writeByte(2);
        break;
      case PartCategory.brakes:
        writer.writeByte(3);
        break;
      case PartCategory.electrics:
        writer.writeByte(4);
        break;
      case PartCategory.body:
        writer.writeByte(5);
        break;
      case PartCategory.fluids:
        writer.writeByte(6);
        break;
      case PartCategory.other:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PartCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
