import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:uniprintgestao/app/app_module.dart';
import 'package:uniprintgestao/app/shared/services/utils_hive_service.dart';

part 'tipo_folha.g.dart';

@HiveType(typeId: 3)
class TipoFolha {
  @HiveField(0)
  int id;
  @HiveField(1)
  String nome;
  bool selecionado = false;

  TipoFolha({
    this.id,
    this.nome,
  });

  TipoFolha copyWith({
    int id,
    String nome,
  }) {
    return TipoFolha(
      id: id ?? this.id,
      nome: nome ?? this.nome,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
    };
  }

  static TipoFolha fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return TipoFolha(
      id: map['id'],
      nome: map['nome'],
    );
  }

  String toJson() => json.encode(toMap());

  static TipoFolha fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'TipoFolha id: $id, nome: $nome';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is TipoFolha && o.id == id && o.nome == nome;
  }

  @override
  int get hashCode => id.hashCode ^ nome.hashCode;

  List<TipoFolha> tiposFolha;

  static Future<List<TipoFolha>> getTiposFolha() async {
    Box box =
        await AppModule.to.getDependency<HiveService>().getBox('tipo_folha');
    var tiposFolha = box.values.toList();
    return tiposFolha;
  }
}
