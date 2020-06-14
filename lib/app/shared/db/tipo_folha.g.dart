// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tipo_folha.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TipoFolhaAdapter extends TypeAdapter<TipoFolha> {
  @override
  final typeId = 3;

  @override
  TipoFolha read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TipoFolha(
      id: fields[0] as int,
      nome: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TipoFolha obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nome);
  }
}
