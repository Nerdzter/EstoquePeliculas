// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filme_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FilmeModelAdapter extends TypeAdapter<FilmeModel> {
  @override
  final int typeId = 0;

  @override
  FilmeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FilmeModel(
      id: fields[0] as String,
      marca: fields[1] as String,
      modelo: fields[2] as String,
      tipo: fields[3] as String,
      quantidade: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, FilmeModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.marca)
      ..writeByte(2)
      ..write(obj.modelo)
      ..writeByte(3)
      ..write(obj.tipo)
      ..writeByte(4)
      ..write(obj.quantidade);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FilmeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
