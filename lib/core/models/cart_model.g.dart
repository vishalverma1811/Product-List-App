// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class cartModelAdapter extends TypeAdapter<cartModel> {
  @override
  final int typeId = 1;

  @override
  cartModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return cartModel(
      fields[0] as Product,
      fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, cartModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.selectedProduct)
      ..writeByte(1)
      ..write(obj.count);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is cartModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
